;; zinc (zach's insignifigant notmuch clone)



;; TODO: need to look into behavior from exiting out C-g from prompt
;; TODO: need to look at replacing all these
;; [X] notmuch-search
;; [X] notmuch-search-filter
;; [ ] notmuch-tree

(defun +notmuch-search-buffer ()
  (get-buffer-create "*notmuch-search*"))

(defvar +notmuch-live-search-filter-active nil
  "When non-nil, Notmuch is currently reading a filter from the minibuffer.
When live editing the filter, it is bound to :live.")

;; TODO document / choose from saved searches?
(defvar +notmuch-live-search-default-query "tag:inbox")

(defvar +notmuch-live-search-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map notmuch-search-mode-map)
    (define-key map "s" #'+notmuch-live-search-filter)
    (define-key map "S" #'+notmuch-live-search-filter-empty)
    map))

;; TODO: only works within doom emacs
(when (featurep! :editor evil)
  (map! :map +notmuch-live-search-mode-map
        :n "s" #'+notmuch-live-search-filter
        :n "S" #'+notmuch-live-search-filter-empty))

(define-derived-mode +notmuch-live-search-mode
  notmuch-search-mode
  "Notmuch Live Search"
  "TODO docstring

Special commands:
\\{+notmuch-live-search-mode-map}"
  ;; (kill-all-local-variables)
  (unless notmuch-search-query-string
    (setq notmuch-search-query-string +notmuch-live-search-default-query))
  (+notmuch-live-search-update :force))

(defun +notmuch-live-search (&optional query)
  "Enter notmuch live interactive search."
  (interactive)
  (switch-to-buffer (+notmuch-search-buffer))
  (unless (eq major-mode '+notmuch-live-search-mode)
    (+notmuch-live-search-mode)))

;; TODO live updating
(defun +notmuch-live-search-filter (&optional query)
  "Filter the notmuch-search buffer as the filter is written."
  (interactive)
  (unwind-protect
      (let ((+notmuch-search-filter-active :live))
        (if query
            (setq notmuch-search-query-string query)
          (setq notmuch-search-query-string
                (read-from-minibuffer "Notmuch search: " notmuch-search-query-string)))
        (+notmuch-live-search-update :force))))

(defun +notmuch-live-search-filter-empty ()
  (interactive)
  (unwind-protect
      (let ((+notmuch-search-filter-active :live))
        (setq notmuch-search-query-string
              (read-from-minibuffer "Notmuch search: ")))
    (+notmuch-live-search-filter)))

(defun +notmuch-live-search-update (&optional force)
  "Update the elfeed-search buffer listing to match the database.
When FORCE is non-nil, redraw even when the database hasn't changed."
  (interactive)
  (with-current-buffer (+notmuch-search-buffer)
    (when (or force
              ;; TODO make this smart enough to update when the db has been updated
              ;; (and (not +notmuch-search-filter-active)
              ;; (< +notmuch-search-last-update (elfeed-db-last-update))
              )
      (save-excursion
        (let ((inhibit-read-only t))
          (when (get-buffer-process (current-buffer))
            (kill-process))
          (erase-buffer)
          (unless (string-empty-p notmuch-search-query-string)
            (let* (
                   ;; TODO: this as a parameter?
                   (oldest-first (default-value 'notmuch-search-oldest-first))

                   (proc (notmuch-start-notmuch
                          "notmuch-search" (current-buffer) #'notmuch-search-process-sentinel
                          "search" "--format=sexp" "--format-version=4"
                          (if oldest-first
                              "--sort=oldest-first"
                            "--sort=newest-first")
                          notmuch-search-query-string)))
              ;; Use a scratch buffer to accumulate partial output.
              ;; This buffer will be killed by the sentinel, which
              ;; should be called no matter how the process dies.
              (process-put proc 'parse-buf
                           (generate-new-buffer " *notmuch search parse*"))
              (set-process-filter proc 'notmuch-search-process-filter)
              (set-process-query-on-exit-flag proc nil))



            ;; (elfeed-search--update-list)
            ;;     (dolist (entry elfeed-search-entries)
            ;;       (funcall elfeed-search-print-entry-function entry)
            ;;       (insert "\n"))
            ;;     (setf elfeed-search-last-update (float-time))))
            ;; (when (zerop (buffer-size))
            ;;   ;; If nothing changed, force a header line update
            ;;   (force-mode-line-update))
            ;; (run-hooks 'elfeed-search-update-hook))
            ))
        (run-hooks 'notmuch-search-hook)))))


;; (defvar +notmuch-search-last-update 0
;;   "The last time the buffer was redrawn in epoch seconds.")

;; (defvar +notmuch-db nil
;;   "A plist storing some metadata about the notmuch database")

;; (defun +notmuch-db-ensure)

;; (defun +notmuch-db-last-update ()
;;   (+notmuch-db-ensure)
;;   (let (()))
;;   (or (plist-get +notmuch-db :last-update) 0))

;; (defun +elfeed-search-update (&optional force)
;;   "Update the elfeed-search buffer listing to match the database.
;; When FORCE is non-nil, redraw even when the database hasn't changed."
;;   (interactive)
;;   (with-current-buffer (elfeed-search-buffer)
;;     (when (or force (and (not elfeed-search-filter-active)
;;                          (< elfeed-search-last-update (elfeed-db-last-update))))
;;       (elfeed-save-excursion
;;         (let ((inhibit-read-only t)
;;               (standard-output (current-buffer)))
;;           (erase-buffer)
;;           (elfeed-search--update-list)
;;           (dolist (entry elfeed-search-entries)
;;             (funcall elfeed-search-print-entry-function entry)
;;             (insert "\n"))
;;           (setf elfeed-search-last-update (float-time))))
;;       (when (zerop (buffer-size))
;;         ;; If nothing changed, force a header line update
;;         (force-mode-line-update))
;;       (run-hooks 'elfeed-search-update-hook))))


;; (defun +notmuch-search-live-filter ()
;;   (interactive)

;;   )

;; (defun notmuch-search (&optional query oldest-first target-thread target-line no-display)
;;   "Display threads matching QUERY in a notmuch-search buffer.

;; If QUERY is nil, it is read interactively from the minibuffer.
;; Other optional parameters are used as follows:

;;   OLDEST-FIRST: A Boolean controlling the sort order of returned threads
;;   TARGET-THREAD: A thread ID (without the thread: prefix) that will be made
;;                  current if it appears in the search results.
;;   TARGET-LINE: The line number to move to if the target thread does not
;;                appear in the search results.
;;   NO-DISPLAY: Do not try to foreground the search results buffer. If it is
;;               already foregrounded i.e. displayed in a window, this has no
;;               effect, meaning the buffer will remain visible.

;; When called interactively, this will prompt for a query and use
;; the configured default sort order."
;;   (interactive
;;    (list
;;     ;; Prompt for a query
;;     nil
;;     ;; Use the default search order (if we're doing a search from a
;;     ;; search buffer, ignore any buffer-local overrides)
;;     (default-value 'notmuch-search-oldest-first)))

;;   (let* ((query (or query (notmuch-read-query "Notmuch search: ")))
;; 	 (buffer (get-buffer-create (notmuch-search-buffer-title query))))
;;     (if no-display
;; 	(set-buffer buffer)
;;       (pop-to-buffer-same-window buffer))
;;     (notmuch-search-mode)
;;     ;; Don't track undo information for this buffer
;;     (setq buffer-undo-list t)
;;     (setq notmuch-search-query-string query)
;;     (setq notmuch-search-oldest-first oldest-first)
;;     (setq notmuch-search-target-thread target-thread)
;;     (setq notmuch-search-target-line target-line)
;;     (notmuch-tag-clear-cache)
;;     (when (get-buffer-process buffer)
;;       (error "notmuch search process already running for query `%s'" query))
;;     (let ((inhibit-read-only t))
;;       (erase-buffer)
;;       (goto-char (point-min))
;;       (save-excursion
;; 	(let ((proc (notmuch-start-notmuch
;; 		     "notmuch-search" buffer #'notmuch-search-process-sentinel
;; 		     "search" "--format=sexp" "--format-version=4"
;; 		     (if oldest-first
;; 			 "--sort=oldest-first"
;; 		       "--sort=newest-first")
;; 		     query)))
;; 	  ;; Use a scratch buffer to accumulate partial output.
;; 	  ;; This buffer will be killed by the sentinel, which
;; 	  ;; should be called no matter how the process dies.
;; 	  (process-put proc 'parse-buf
;; 		       (generate-new-buffer " *notmuch search parse*"))
;; 	  (set-process-filter proc 'notmuch-search-process-filter)
;; 	  (set-process-query-on-exit-flag proc nil))))
;;     (run-hooks 'notmuch-search-hook)))

;; (defvar +notmuch-live-search-filter-syntax-table
;;   (let ((table (make-syntax-table)))
;;     (modify-syntax-entry ?+ )))

;; FIXME: live updating doesn't work
(defun +notmuch-live-search--minibuffer-setup ()
  (when +notmuch-live-search-filter-active
    ;; (set-syntax-table )
    (when (eq :live +notmuch-live-search-filter-active)
      (add-hook 'post-command-hook #'+notmuch-search--live-update nil :local))))

(add-hook 'minibuffer-setup-hook #'+notmuch-live-search--minibuffer-setup)

(defun +notmuch-search--live-update ()
  (when (eq :live +notmuch-live-search-filter-active)
    (let ((notmuch-search-query-string (minibuffer-contents-no-properties)))
      (+notmuch-live-search-update :force))))

;; TODO BUGS
;; [ ] pressing C-g in the minibuffer after =S= search causes another search
;;     prompt
