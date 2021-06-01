;; remove old modelines
;; NOTE: there should probably be a better way to do this
(remove-hook! +doom-dashboard-mode #'+modeline-set-project-format-h)
(remove-hook! '(special-mode-hook
                image-mode-hook
                circe-mode-hook) #'+modeline-set-special-format-h)

;; set some variables
(setq +modeline-bar-width nil
      ;; NOTE: would like for this to be dependent / adapt to text size but not
      ;; sure how to
      +modeline-height 26)

(def-modeline-var! +nano-modeline-buffer-identification
  '((:eval
     (propertize
      (or +modeline--buffer-id-cache "%b")
      'face (if (+modeline-active)  'mode-line-buffer-id)
      'help-echo (or +modeline--buffer-id-cache (buffer-name))))))

(defun vc-branch ()
  (if vc-mode
      (let ((backend (vc-backend buffer-file-name)))
        (concat "#" (substring-no-properties vc-mode
                                 (+ (if (eq backend 'Hg) 2 3) 2))))  nil))

(def-modeline-var! +nano-modeline-mode-and-vc
  '((:eval
     (let ((branch (vc-branch)))
       (concat "(" "%m"
               (if branch (concat ", " (propertize branch 'face 'italic)))
               ")")))))

(defun +nano-get-modeline-status ()
  (let ((read-only   buffer-read-only)
        (modified    (and buffer-file-name (buffer-modified-p))))
    (cond (modified  "**") (read-only "RO") (t "RW"))))

(def-modeline-var! +nano-modeline-status
  '((:eval
     (let ((status (+nano-get-modeline-status)))
       (propertize
        (concat " " status " ")
        'face (cond
               ((string= status "RO") 'nano-face-header-popout)
               ((string= status "**") 'nano-face-header-critical)
               ((string= status "RW") 'nano-face-header-faded)
               (t 'nano-face-header-popout)))))))

;; TODO fix this
;; (def-modeline-var! +nano-modeline-org-clock
;;   '((:eval
;;      (when (org-clocking-p)
;;        (concat "[" org-mode-line-string "]")))))
(def-modeline-var! +nano-modeline-org-clock '"")

(def-modeline-var! +nano-modeline-position '("%l:%C"))
(def-modeline-var! +nano-modeline-position-pdf
  '((:eval
     (let* ((total-pages (number-to-string (pdf-cache-number-of-pages)))
            (current-page (number-to-string (pdf-view-current-page)))
            (max-length (number-to-string (length total-pages)))
            (current-page-padded
             (format (concat "%" max-length "s") current-page)))
       (concat current-page "/" total-pages)))))

(def-modeline-var! +nano-modeline-time
  '((:eval
     (format-time-string "%H:%M"))))

(def-modeline-var! +nano-modeline-notmuch-query
  '((:eval
     (when (fboundp 'notmuch-search-get-query)
       (notmuch-search-get-query)))))

;; Nano mode line format:
;;
;; [ status | name (primary)               secondary | item1 | item2 ]

(defmacro nano-modeline! (name status bname primary &rest secondary-forms)
  `(def-modeline! ,name
     (list "" ,status " " ,bname " " ,primary)
     (list ,@(cl-loop for item in secondary-forms
                      append (list " " item))
           "  ")))

(nano-modeline! :nano
                +nano-modeline-status
                +nano-modeline-buffer-identification
                +nano-modeline-mode-and-vc
                +nano-modeline-org-clock
                +nano-modeline-position)
(set-modeline! :nano 'default)

(nano-modeline! :nano-pdf
                +nano-modeline-status
                +nano-modeline-buffer-identification
                +nano-modeline-mode-and-vc
                +nano-modeline-org-clock
                +nano-modeline-position-pdf)
(set-modeline-hook! 'pdf-view-mode-hook :nano-pdf)

(nano-modeline! :nano-notmuch-search
                +nano-modeline-status
                "Mail"
                ""
                +nano-modeline-notmuch-query)
(set-modeline-hook! 'notmuch-search-mode-hook :nano-notmuch-search)

(nano-modeline! :nano-org-agenda
                +nano-modeline-status
                "Agenda"
                ""
                +nano-modeline-org-clock
                "["
                +nano-modeline-time
                "]")
(set-modeline-hook! 'org-agenda-mode-hook :nano-org-agenda)
