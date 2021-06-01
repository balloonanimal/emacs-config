;; TODO: figure out why hide-mode-line isn't working
;; TODO: try to find a way to open notmuch-search in the same buffer
;; TODO: center notmuch-hello using (visual-)fill-column
;; TODO: buttons J and R don't work rn, need interactive call
;; TODO: the overloaded notmuch-search calls don't work for long names like tags etc
;; TODO: figure out the mime-type stuff, especially multipart
;;         ESPECIALLY find some way to not display in buffer
;;         look at mu4e https://www.djcbsoftware.nl/code/mu/mu4e/Displaying-rich_002dtext-messages.html
;; TODO: look at
;;       https://github.com/tecosaur/doom-emacs/tree/m4e4u/modules/email/mu4e
;;       to see if there's anything good there
;; TODO: look at transient
;; TODO: no buttons work right now


(use-package! notmuch
  :defer t
  :init
  (after! org
    (add-to-list 'org-modules 'ol-notmuch))


  :config
  (load! "notmuch-live-search")

  (setq-default notmuch-search-oldest-first nil)

  (set-popup-rules!
    '(("^\\*notmuch-hello" :side left :size 35 :ttl 0 :modeline nil)
      ("^\\*notmuch-search" :ignore t)
      ("^\\*notmuch-saved-search" :ignore t)
      ("^\\*notmuch-thread" :size 0.75 :actions (display-buffer-below-selected)
       :select t :quit t :ttl 300 :modeline nil)))

  (map! :map notmuch-common-keymap
        :n "R" #'+notmuch-jump-search-recent
        :n "T" #'+notmuch-jump-search-tags)

  ;; TODO
  (defun +notmuch-inbox ()
    "Enter notmuch inbox."
    (interactive)
    (+notmuch-live-search)
    (notmuch-hello))

  ;; util
  (defun +notmuch--build-recent-searches ()
    (let ((search-list
           (cl-loop for i from 1 to notmuch-hello-recent-searches-max
                    for search in notmuch-search-history
                    collect (list
                             :name search
                             :query search
                             :key (number-to-string i)))))
      (notmuch-hello-query-counts
       search-list
       :show-empty-searches
       t
       ;; notmuch-show-empty-saved-searches
       )))


  (defun +notmuch--build-tag-searches ()
    (let* ((tag-alist (notmuch-hello-generate-tag-alist))
           (search-list
            (cl-loop for search in tag-alist
                     collect (list
                              :name (car search)
                              :query (cdr search)
                              ;; :key (number-to-string i)
                              ))))
      (notmuch-hello-query-counts search-list)))

  ;; notmuch-hello
  (setq notmuch-hello-sections '(+notmuch-hello-header
                                 +notmuch-hello-insert-saved-searches
                                 +notmuch-hello-insert-recent-searches
                                 +notmuch-hello-insert-tags)
        notmuch-hello-indent 2)

  (defface +notmuch-hello-button-face
    '((t (:inherit font-lock-keyword-face)))
    "Face used in notmuch-hello for buttons."
    :group 'notmuch-faces)

  (defun +notmuch-hello-header ()
    (widget-insert (propertize "Notmuch mail\n" 'face 'nano-face-strong))
    (widget-insert (propertize "Type ? for help\n" 'face 'nano-face-faded)))

  (defun +notmuch-hello-insert-buttons (searches)
    "Insert buttons for SEARCHES.

SEARCHES must be a list of plists each of which should contain at
least the properties :name NAME :query QUERY and :count COUNT,
where QUERY is the query to start when the button for the
corresponding entry is activated, and COUNT should be the number
of messages matching the query.  Such a plist can be computed
with `notmuch-hello-query-counts'."
    (let* ((column-width 25)
           (column-indent 6)
           (max-title-length 13)
           (max-columns 2)
           (padchar ?.)

           (widest-key
            (or (cl-loop for elem in searches
                         maximize (length (notmuch-saved-search-get elem :key)))
                0))
           (key-button-padding (if (= 0 widest-key) 0 (+ 3 widest-key)))
           (tags-per-line (min max-columns (max 1
                                (/ (- (window-width) notmuch-hello-indent)
                                        (+ column-width column-indent)))))
           (current-column-indent 0)
           (count 0)
           (reordered-list (notmuch-hello-reflect searches tags-per-line)))
      ;; dme: It feels as though there should be a better way to
      ;; implement this loop than using an incrementing counter.
      (mapc (lambda (elem)
              ;; (not elem) indicates an empty slot in the matrix.
              (when elem
                (when (> current-column-indent 0)
                  (widget-insert (make-string column-indent ? )))
                (let* ((key (plist-get elem :key))
                       (name (plist-get elem :name))
                       (query (plist-get elem :query))
                       (oldest-first (cl-case (plist-get elem :sort-order)
                                       (newest-first nil)
                                       (oldest-first t)
                                       (otherwise notmuch-search-oldest-first)))
                       (search-type (plist-get elem :search-type))
                       (msg-count (plist-get elem :count)))
                  (if key
                      ;; Insert [key] button
                      (progn
                        (widget-create 'push-button
                                        :notify #'notmuch-hello-widget-search
                                        :notmuch-search-terms query
                                        :notmuch-search-oldest-first oldest-first
                                        :notmuch-search-type search-type
                                        :button-face '+notmuch-hello-button-face
                                        key
                                        ;; (format "[%s] " key)
                                        )
                        (widget-insert (make-string (- widest-key (length key)) ? ))
                        (widget-insert " "))
                    ;; Pad for alignment with other [key] buttons
                    (widget-insert (make-string key-button-padding ? )))

                  (widget-insert
                   (let ((title
                          (if (< (length name) max-title-length)
                              name
                            (format "%s\\" (substring name 0 max-title-length)))))
                     (format "%s %s %d"
                             title
                             (make-string (- column-width
                                             2 ;; spaces on either side
                                             key-button-padding
                                             (length title)
                                             (length (number-to-string msg-count)))
                                          padchar)
                             msg-count)))
                  (setq current-column-indent column-indent)))
              (cl-incf count)
              (when (eq (% count tags-per-line) 0)
                (setq current-column-indent 0)
                (widget-insert "\n")))
            reordered-list)
      ;; If the last line was not full (and hence did not include a
      ;; carriage return), insert one now.
      (unless (eq (% count tags-per-line) 0)
        (widget-insert "\n"))))

  (defun +notmuch-hello-insert-saved-searches ()
    "Insert the saved-searches section."
    (let ((searches (notmuch-hello-query-counts
                     (if notmuch-saved-search-sort-function
                         (funcall notmuch-saved-search-sort-function
                                  notmuch-saved-searches)
                       notmuch-saved-searches)
                     :show-empty-searches notmuch-show-empty-saved-searches)))
      (when searches
        (widget-create 'push-button
                       :notify #'notmuch-jump-search
                       :button-face '+notmuch-hello-button-face
                       "J")
        (widget-insert " Saved searches: ")
        (widget-insert "\n\n")
        (let ((start (point)))
          (+notmuch-hello-insert-buttons searches)
          (indent-rigidly start (point) 2)))))

  (defun +notmuch-hello-insert-recent-searches ()
    "Insert the recent-searches section."
    (when notmuch-search-history
      (let* ((searches (+notmuch--build-recent-searches)))
        (widget-create 'push-button
                       :notify #'notmuch-jump-search
                       :button-face '+notmuch-hello-button-face
                       "R")
        (widget-insert " Recent searches: ")
        (widget-insert "\n\n")
        (let ((start (point)))
          (+notmuch-hello-insert-buttons searches)
          (indent-rigidly start (point) 2)))))

  (defvar +notmuch-hello-tag-max 9)
  (defvar +notmuch-hello--largest-tags nil)

  (defun +notmuch-hello--build-largest-tags ()
    (let* ((tag-searches (+notmuch--build-tag-searches))
           (sorted-tag-searches
            (sort tag-searches
                  (lambda (search1 search2)
                    (> (plist-get search1 :count)
                       (plist-get search2 :count)))))
           (relevant-tag-searches
            (cl-loop for i from 1 to +notmuch-hello-tag-max
                     for search in sorted-tag-searches
                     collect (plist-put search :key (number-to-string i)))))
      (setq +notmuch-hello--largest-tags relevant-tag-searches)
      relevant-tag-searches))

  (defun +notmuch-hello-insert-tags ()
    (let* ((relevant-tag-searches (+notmuch-hello--build-largest-tags)))
      (widget-create 'push-button
                     :notify #'notmuch-jump-search
                     :button-face '+notmuch-hello-button-face
                     "T")
      (widget-insert " Tags: ")
      (widget-insert "\n\n")
      (let ((start (point)))
        (+notmuch-hello-insert-buttons relevant-tag-searches)
        (indent-rigidly start (point) 2))))

  ;; notmuch-search
  (setq notmuch-search-result-format
        '(("authors" . "%-20.20s ")
          ("count" . "%7.7s ")
          ("subject" . "%-50.50s ")
          ("date" . "%12.12s ")
          ("tags" . "%s"))
        goto-address-mail-face 'font-lock-keyword-face)

  (add-hook! notmuch-search-mode
             (setq line-spacing 0.2))

  (defadvice! +notmuch-no-one-counts (orig-fn field format-string result)
    :around #'notmuch-search-insert-field
    (if (and (string-equal field "count")
             (= (plist-get result :total) 1))
        (insert (format format-string ""))
      (funcall orig-fn field format-string result)))

  ;; notmuch-show
  (add-hook! '(notmuch-show-mode-hook
               notmuch-show-hook)
             #'hide-mode-line-mode)

  (setq notmuch-message-headers '("Subject" "From" "To" "Cc" "Date" "Tags"))

  (defadvice! +notmuch-show-add-tags-header (orig-fn msg depth)
    :around #'notmuch-show-insert-msg
    (let* ((tags (plist-get msg :tags))
           (orig-tags (plist-get msg :orig-tags))
           (new-headers (append
                         (plist-get msg :headers)
                         (list :Tags (notmuch-tag-format-tags tags orig-tags))))
           (new-msg (plist-put msg :headers new-headers)))
      (message "%s" (plist-get new-msg :headers))
      (funcall orig-fn new-msg depth)))

  (defadvice! +notmuch-show-no-headerline (&rest r)
    :override #'notmuch-show-insert-headerline
    (ignore))

  (defadvice! +notmuch-show-no-header-line ()
    :after #'notmuch-show--build-buffer
    (setq header-line-format nil))

  ;; TODO: look at notmuch-show-markup-headers-hook
  (defadvice! +notmuch-show-fontify-header--better ()
    :override #'notmuch-show-fontify-header
    (let ((face (cond
                 ((looking-at "[Tt]o:")
                  'message-header-to)
                 ((looking-at "[Ff]rom:")
                  'message-header-to)
                 ((looking-at "[Bb]?[Cc][Cc]:")
                  'message-header-cc)
                 ((looking-at "[Ss]ubject:")
                  'message-header-subject)
                 (t
                  'message-header-other))))
      (overlay-put (make-overlay (point) (re-search-forward ":"))
                   'face 'message-header-name)
      (overlay-put (make-overlay (point) (re-search-forward ".*$"))
                   'face face)))

  ;; (defadvice! +notmuch-search-truncate-title (orig-fn field format-string result)
  ;;   :around #'notmuch-search-insert-field
  ;;   (if (string-equal field "subject")
  ;;       (let ((start-point (point)))
  ;;         (funcall orig-fn field format-string result)
  ;;         ;; more than characters have been inserted
  ;;         ;; FIXME this can't be the right way to do this
  ;;         (when (< 50 (- (point) start-point))
  ;;             (goto-char start-point)
  ;;             (forward-char 48)
  ;;             (kill-line)
  ;;             (insert-char ?…)))
  ;;       (funcall orig-fn field format-string result)))

  ;; FUNCTION MODIFICATIONS
  (defun +notmuch-jump-search-recent ()
    (interactive)
    (let ((notmuch-saved-searches (+notmuch--build-recent-searches)))
      (call-interactively #'notmuch-jump-search)))

  (defun +notmuch-jump-search-tags ()
    (interactive)
    (let ((notmuch-saved-searches +notmuch-hello--largest-tags))
      (call-interactively #'notmuch-jump-search)))

  (defadvice! +notmuch-thread-name-advice (orig-fn thread-id &optional elide-toggle parent-buffer query-context buffer-name)
    :around #'notmuch-show
    (let* ((sterile-bname (cond
                          ((and buffer-name (string-match
                                             "^\\*\\(.+\\)\\*$"
                                             buffer-name))
                           (match-string 1 buffer-name))
                          ((buffer-name) buffer-name)
                          (t thread-id)))
          (buffer-name (generate-new-buffer-name
                        (concat "*notmuch-thread [" sterile-bname "]*"))))
      (funcall orig-fn thread-id elide-toggle parent-buffer query-context buffer-name)))



  ;; IN PROGRESS
  (defun display-buffer-reuse-or-same-window (buffer alist)
    (if-let (window (get-buffer-window buffer))
        (display-buffer-reuse-window buffer alist)
      (display-buffer-same-window buffer alist)))
  ;; (display-buffer a '((display-buffer-reuse-or-same-window)))


;; (defadvice! shut-up-org-fancy-priorities-mode-a (orig-fn &rest args)
;;   :around #'org-fancy-priorities-mode
;;   (ignore-errors (apply orig-fn args)))
  )

;; (notmuch-show THREAD-ID &optional ELIDE-TOGGLE PARENT-BUFFER QUERY-CONTEXT BUFFER-NAME)
;; *notmuch-search-*
;; *notmuch-saved-search-*
;;
;;
;; notmuch-search-show-thread
;;
;; notmuch-show-mark-read-function

(use-package! org-mime
  :after (org notmuch)
  :config (setq org-mime-library 'mml))

(use-package! counsel-notmuch
  :when (featurep! :completion ivy)
  :commands counsel-notmuch
  :after notmuch)
