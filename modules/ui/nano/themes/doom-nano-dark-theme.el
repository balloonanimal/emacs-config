;; TODO not really sure what nano-theme--minibuffer does

(setq nano-color-foreground "#ECEFF4") ;; Snow Storm 3  / nord  6
(setq nano-color-background "#2E3440") ;; Polar Night 0 / nord  0
(setq nano-color-highlight  "#3B4252") ;; Polar Night 1 / nord  1
(setq nano-color-critical   "#EBCB8B") ;; Aurora        / nord 11
(setq nano-color-salient    "#81A1C1") ;; Frost         / nord  9
(setq nano-color-strong     "#ECEFF4") ;; Snow Storm 3  / nord  6
(setq nano-color-popout     "#D08770") ;; Aurora        / nord 12
(setq nano-color-subtle     "#434C5E") ;; Polar Night 2 / nord  2
(setq nano-color-faded      "#677691") ;;
(nano-faces)
(set-face-attribute 'nano-face-strong nil :weight 'bold)
(set-face-attribute 'nano-face-critical nil :foreground nano-color-background)

(defgroup doom-nano-dark-theme nil
  "Options for doom-themes"
  :group 'doom-themes)

(def-doom-theme doom-nano-dark
  "A dark theme inspired by Nano."
  ;; name        default   256       16
  ((bg         `(,nano-color-background nil       nil            ))
   (bg-alt     `(,nano-color-background nil       nil            ))
   (base0      '("#191C25" "black"   "black"        ))
   (base1      '("#242832" "#1e1e1e" "brightblack"  ))
   (base2      '("#2C333F" "#2e2e2e" "brightblack"  ))
   (base3      '("#373E4C" "#262626" "brightblack"  ))
   (base4      '("#434C5E" "#3f3f3f" "brightblack"  ))
   (base5      '("#4C566A" "#525252" "brightblack"  ))
   (base6      '("#9099AB" "#6b6b6b" "brightblack"  ))
   (base7      '("#D8DEE9" "#979797" "brightblack"  ))
   (base8      '("#F0F4FC" "#dfdfdf" "white"        ))
   (fg         `(,nano-color-foreground "#ECECEC" "white"        ))
   (fg-alt     '("#E5E9F0" "#bfbfbf" "brightwhite"  ))

   (grey       base4)
   (red        '("#BF616A" "#ff6655" "red"          )) ;; Nord11
   (orange     '("#D08770" "#dd8844" "brightred"    )) ;; Nord12
   (green      '("#A3BE8C" "#99bb66" "green"        )) ;; Nord14
   (teal       '("#8FBCBB" "#44b9b1" "brightgreen"  )) ;; Nord7
   (yellow     '("#EBCB8B" "#ECBE7B" "yellow"       )) ;; Nord13
   (blue       '("#81A1C1" "#51afef" "brightblue"   )) ;; Nord9
   (dark-blue  '("#5E81AC" "#2257A0" "blue"         )) ;; Nord10
   (magenta    '("#B48EAD" "#c678dd" "magenta"      )) ;; Nord15
   (violet     '("#5D80AE" "#a9a1e1" "brightmagenta")) ;; ??
   (cyan       '("#88C0D0" "#46D9FF" "brightcyan"   )) ;; Nord8
   (dark-cyan  '("#507681" "#5699AF" "cyan"         )) ;; ??

   ;; face categories -- required for all themes
   (highlight      nano-color-subtle)
   (vertical-bar   nano-color-subtle)
   (selection      nano-color-subtle)
   (builtin        nano-color-salient)
   (comments       nano-color-faded)
   (doc-comments   nano-color-faded)
   (constants      nano-color-salient)
   (functions      nano-color-foreground)
   (keywords       nano-color-salient)
   (methods        nano-color-foreground)
   (operators      nano-color-salient)
   (type           nano-color-salient)
   (strings        nano-color-popout)
   (variables      nano-color-foreground)
   (numbers        nano-color-popout)
   (region         nano-color-subtle)
   (error          nano-color-critical)
   (warning        nano-color-popout)
   (success        nano-color-salient)
   (vc-modified    nano-color-popout)
   (vc-added       nano-color-salient)
   (vc-deleted     nano-color-faded)

   ;; custom categories
   ;; (hidden     `(,(car bg) "black" "black"))
   ;; (-modeline-bright doom-nano-dark-brighter-modeline)
   ;; (-modeline-pad
   ;;  (when doom-nano-dark-padded-modeline
   ;;    (if (integerp doom-nano-dark-padded-modeline) doom-nano-dark-padded-modeline 4)))

   ;; (region-fg
   ;;  (when (memq doom-nano-dark-region-highlight '(frost snowstorm))
   ;;    base0))

   ;; (modeline-fg     nil)
   ;; (modeline-fg-alt base6)

   ;; (modeline-bg
   ;;  (if -modeline-bright
   ;;      (doom-blend bg base5 0.2)
   ;;    base1))
   ;; (modeline-bg-l
   ;;  (if -modeline-bright
   ;;      (doom-blend bg base5 0.2)
   ;;    `(,(doom-darken (car bg) 0.1) ,@(cdr base0))))
   ;; (modeline-bg-inactive   (doom-darken bg 0.1))
   ;; (modeline-bg-inactive-l `(,(car bg) ,@(cdr base1)))
   )


  ;; --- extra faces ------------------------
  (;; structural
   (bold :inherit 'nano-face-strong)
   (italic :inherit 'nano-face-faded)
   (bold-italic :inherit 'nano-face-strong)
   (region :inherit 'nano-face-subtle)
   (highlight :inherit 'nano-face-subtle)
   ;; (fixed-pitch-serif :inherit 'nano-face-default)
   ;; (variable-pitch :inherit 'nano-face-default)
   ;; (cursor :inherit 'nano-face-default)

   (cursor :background nano-color-foreground)
   (window-divider :foreground nano-color-background)
   (vertical-border :foreground nano-color-subtle)

   ;; semantic
   (shadow :inherit 'nano-face-faded)
   (success :inherit 'nano-face-salient)
   (warning :inherit 'nano-face-popout)
   (error :inherit 'nano-face-critical)
   (match :inherit 'nano-face-popout)

   ;; general
   (buffer-menu-buffer :inherit 'nano-face-strong)
   (minibuffer-prompt :inherit 'nano-face-strong)
   (link :inherit 'nano-face-salient)
   (fringe :inherit 'nano-face-faded
           :foreground nano-color-subtle
           :background nano-color-background)
   (isearch :inherit 'nano-face-strong)
   (isearch-fail :inherit 'nano-face-faded)
   (lazy-highlight :inherit 'nano-face-subtle)
   (trailing-whitespace :inherit 'nano-face-subtle)
   (show-paren-match :inherit 'nano-face-popout)
   (show-paren-mismatch :inherit 'nano-face-default)
   (secondary-selection :inherit 'nano-face-subtle)
   (completions-common-part :inherit 'nano-face-faded)
   (completions-first-difference :inherit 'nano-face-default)

   ;; font-lock
   (font-lock-comment-face :inherit 'nano-face-faded)
   (font-lock-doc-face :inherit 'nano-face-faded)
   (font-lock-string-face :inherit 'nano-face-popout)
   (font-lock-constant-face :inherit 'nano-face-salient)
   (font-lock-warning-face :inherit 'nano-face-popout)
   (font-lock-function-name-face :inherit 'nano-face-strong)
   (font-lock-variable-name-face :inherit 'nano-face-strong)
   (font-lock-builtin-face :inherit 'nano-face-salient)
   (font-lock-type-face :inherit 'nano-face-salient)
   (font-lock-keyword-face :inherit 'nano-face-salient)

   ;; mode-line
   (mode-line :weight 'light
              :background nano-color-subtle
              :box `(:line-width 1 :color ,nano-color-background :style nil))
   (mode-line-inactive :inherit 'mode-line)
   (mode-line-emphasis :inherit 'nano-face-strong)

   ;; hl-line
   (hl-line :background nano-color-highlight)

   ;; buttons
   (custom-button :foreground nano-color-faded
                  :background nano-color-background
                  :box `(:line-width 1 :style nil))
   (custom-button-mouse :foreground nano-color-faded
                        :background nano-color-subtle
                        :box `(:line-width 1 :style nil))
   (custom-button-pressed :foreground nano-color-foreground
                          :background nano-color-salient
                          :inherit 'nano-face-salient
                          :box `(:line-width 1
                                 :color ,nano-color-salient
                                 :style nil))

   ;; info
   (info-menu-header :inherit 'nano-face-strong)
   (info-header-node :inherit 'nano-face-default)
   (info-index-match :inherit 'nano-face-salient)
   (Info-quoted :inherit 'nano-face-faded)
   (info-title-1 :inherit 'nano-face-strong)
   (info-title-2 :inherit 'nano-face-strong)
   (info-title-3 :inherit 'nano-face-strong)
   (info-title-4 :inherit 'nano-face-strong)

   ;; speedbar
   (speedbar-button-face :inherit 'nano-face-faded)
   (speedbar-directory-face :inherit 'nano-face-strong)
   (speedbar-file-face :inherit 'nano-face-default)
   (speedbar-highlight-face :inherit 'nano-face-highlight)
   (speedbar-selected-face :inherit 'nano-face-subtle)
   (speedbar-separator-face :inherit 'nano-face-faded)
   (speedbar-tag-face :inherit 'nano-face-faded)

   ;; bookmark
   (bookmark-menu-heading :inherit 'nano-face-strong)
   (bookmark-menu-bookmark :inherit 'nano-face-salient)

   ;; message
   (message-cited-text-1 :inherit 'nano-face-faded)
   (message-cited-text-2 :inherit 'nano-face-faded)
   (message-cited-text-3 :inherit 'nano-face-faded)
   (message-cited-text-4 :inherit 'nano-face-faded)
   (message-cited-text :inherit 'nano-face-faded)
   (message-header-cc :inherit 'nano-face-default)
   (message-header-name :inherit 'nano-face-strong)
   (message-header-newsgroups :inherit 'nano-face-default)
   (message-header-other :inherit 'nano-face-default)
   (message-header-subject :inherit 'nano-face-salient)
   (message-header-to :inherit 'nano-face-salient)
   (message-header-xheader :inherit 'nano-face-default)
   (message-mml :inherit 'nano-face-popout)
   (message-separator :inherit 'nano-face-faded)

   ;; outline
   (outline-1 :inherit 'nano-face-strong)
   (outline-2 :inherit 'nano-face-strong)
   (outline-3 :inherit 'nano-face-strong)
   (outline-4 :inherit 'nano-face-strong)
   (outline-5 :inherit 'nano-face-strong)
   (outline-6 :inherit 'nano-face-strong)
   (outline-7 :inherit 'nano-face-strong)
   (outline-8 :inherit 'nano-face-strong)

   ;; customize
   (widget-field :inherit 'nano-face-subtle)
   (widget-button :inherit 'nano-face-strong)
   (widget-single-line-field :inherit 'nano-face-subtle)
   (custom-group-subtitle :inherit 'nano-face-strong)
   (custom-group-tag :inherit 'nano-face-strong)
   (custom-group-tag-1 :inherit 'nano-face-strong)
   (custom-comment :inherit 'nano-face-faded)
   (custom-comment-tag :inherit 'nano-face-faded)
   (custom-changed :inherit 'nano-face-salient)
   (custom-modified :inherit 'nano-face-salient)
   (custom-face-tag :inherit 'nano-face-strong)
   (custom-variable-tag :inherit 'nano-face-default)
   (custom-invalid :inherit 'nano-face-popout)
   (custom-visibility :inherit 'nano-face-salient)
   (custom-state :inherit 'nano-face-salient)
   (custom-link :inherit 'nano-face-salient)

   ;; package
   (package-description :inherit 'nano-face-default)
   (package-help-section-name :inherit 'nano-face-default)
   (package-name :inherit 'nano-face-salient)
   (package-status-avail-obso :inherit 'nano-face-faded)
   (package-status-available :inherit 'nano-face-default)
   (package-status-built-in :inherit 'nano-face-salient)
   (package-status-dependency :inherit 'nano-face-salient)
   (package-status-disabled :inherit 'nano-face-faded)
   (package-status-external :inherit 'nano-face-default)
   (package-status-held :inherit 'nano-face-default)
   (package-status-incompat :inherit 'nano-face-faded)
   (package-status-installed :inherit 'nano-face-salient)
   (package-status-new :inherit 'nano-face-default)
   (package-status-unsigned :inherit 'nano-face-default)

   ;; flyspell
   (flyspell-duplicate :inherit 'nano-face-popout)
   (flyspell-incorrect :inherit 'nano-face-popout)

   ;; ido
   (ido-first-match :inherit 'nano-face-salient)
   (ido-only-match :inherit 'nano-face-faded)
   (ido-subdir :inherit 'nano-face-strong)

   ;; diff
    (diff-header :inherit 'nano-face-faded)
    (diff-file-header :inherit 'nano-face-strong)
    (diff-context :inherit 'nano-face-default)
    (diff-removed :inherit 'nano-face-faded)
    (diff-changed :inherit 'nano-face-popout)
    (diff-added :inherit 'nano-face-salient)
    (diff-refine-added :inherit '(nano-face-salient nano-face-strong))
    (diff-refine-changed :inherit 'nano-face-popout)
    (diff-refine-removed :inherit 'nano-face-faded
                         :strike-through t)

    ;; TODO term, probably covered by doom pretty well

    ;; calendar
    (calendar-today :inherit 'nano-face-strong)

    ;; agenda
    (org-agenda-calendar-event :inherit 'nano-face-default)
    (org-agenda-calendar-sexp :inherit 'nano-face-salient)
    (org-agenda-clocking :inherit 'nano-face-faded)
    (org-agenda-column-dateline :inherit 'nano-face-faded)
    (org-agenda-current-time :inherit 'nano-face-strong)
    (org-agenda-date :inherit 'nano-face-salient)
    (org-agenda-date-today :inherit '(nano-face-salient nano-face-strong))
    (org-agenda-date-weekend :inherit 'nano-face-faded)
    (org-agenda-diary :inherit 'nano-face-faded)
    (org-agenda-dimmed-todo-face :inherit 'nano-face-faded)
    (org-agenda-done :inherit 'nano-face-faded)
    (org-agenda-filter-category :inherit 'nano-face-faded)
    (org-agenda-filter-effort :inherit 'nano-face-faded)
    (org-agenda-filter-regexp :inherit 'nano-face-faded)
    (org-agenda-filter-tags :inherit 'nano-face-faded)
    (org-agenda-restriction-lock :inherit 'nano-face-faded)
    (org-agenda-structure :inherit 'nano-face-strong)

    ;; org
    ;; TODO org-archived, org-block, etc
    (org-archived :inherit 'nano-face-faded)
    (org-block :inherit 'hl-line :extend t)
    (org-block-begin-line :inherit 'nano-face-faded :extend t)
    (org-block-end-line :inherit 'nano-face-faded :extend t)
    (org-checkbox                 :inherit           'nano-face-faded)
    (org-checkbox-statistics-done :inherit           'nano-face-faded)
    (org-checkbox-statistics-todo :inherit           'nano-face-faded)
    (org-clock-overlay            :inherit           'nano-face-faded)
    (org-code                     :inherit           'nano-face-faded)
    (org-column                   :inherit           'nano-face-faded)
    (org-column-title             :inherit           'nano-face-faded)
    (org-date                     :inherit           'nano-face-faded)
    (org-date-selected            :inherit           'nano-face-faded)
    (org-default                  :inherit           'nano-face-faded)
    (org-document-info            :inherit           'nano-face-faded)
    (org-document-info-keyword    :inherit           'nano-face-faded)
    (org-document-title           :inherit           'nano-face-faded)
    (org-done                     :inherit           'nano-face-default)
    (org-drawer                   :inherit           'nano-face-faded)
    (org-ellipsis                 :inherit           'nano-face-faded)
    (org-footnote                 :inherit           'nano-face-faded)
    (org-formula                  :inherit           'nano-face-faded)
    (org-headline-done            :inherit           'nano-face-faded)
    (org-latex-and-related        :inherit           'nano-face-faded)
    ;; inherited from outline
    ;; (org-level-1               :inherit              'nano-face-strong)
    ;; (org-level-2               :inherit              'nano-face-strong)
    ;; (org-level-3               :inherit              'nano-face-strong)
    ;; (org-level-4               :inherit              'nano-face-strong)
    ;; (org-level-5               :inherit              'nano-face-strong)
    ;; (org-level-6               :inherit              'nano-face-strong)
    ;; (org-level-7               :inherit              'nano-face-strong)
    ;; (org-level-8               :inherit              'nano-face-strong)
    (org-link                     :inherit           'nano-face-salient)
    (org-list-dt                  :inherit           'nano-face-faded)
    (org-macro                    :inherit           'nano-face-faded)
    (org-meta-line                :inherit           'nano-face-faded)
    (org-mode-line-clock          :inherit           'nano-face-faded)
    (org-mode-line-clock-overrun  :inherit           'nano-face-faded)
    (org-priority                 :inherit           'nano-face-faded)
    (org-property-value           :inherit           'nano-face-faded)
    (org-quote                    :inherit           'nano-face-faded)
    (org-scheduled                :inherit           'nano-face-faded)
    (org-scheduled-previously     :inherit           'nano-face-faded)
    (org-scheduled-today          :inherit           'nano-face-faded)
    (org-sexp-date                :inherit           'nano-face-faded)
    (org-special-keyword          :inherit           'nano-face-faded)
    (org-table                    :inherit           'nano-face-faded)
    (org-tag                      :inherit           'nano-face-popout)
    (org-tag-group                :inherit           'nano-face-faded)
    (org-target                   :inherit           'nano-face-faded)
    (org-time-grid                :inherit           'nano-face-faded)
    (org-todo                     :inherit           'nano-face-salient)
    (org-upcoming-deadline        :inherit           'nano-face-default)
    (org-verbatim                 :inherit           'nano-face-popout)
    (org-verse                    :inherit           'nano-face-faded)
    (org-warning                  :inherit           'nano-face-popout)

    (+org-todo-active             :inherit           'nano-face-popout)
    (+org-todo-onhold             :inherit           'nano-face-salient)
    (+org-todo-cancel             :inherit           'nano-face-faded)
    (+org-todo-project            :inherit           'nano-face-default)

    ;; TODO mu4e

    ;; elfeed
    (elfeed-log-date-face :inherit 'nano-face-faded)
    (elfeed-log-info-level-face :inherit 'nano-face-default)
    (elfeed-log-debug-level-face :inherit 'nano-face-default)
    (elfeed-log-warn-level-face :inherit 'nano-face-popout)
    (elfeed-log-error-level-face :inherit 'nano-face-popout)
    (elfeed-search-tag-face :inherit 'nano-face-faded)
    (elfeed-search-date-face :inherit 'nano-face-faded)
    (elfeed-search-feed-face :inherit 'nano-face-salient)
    (elfeed-search-filter-face :inherit 'nano-face-faded)
    (elfeed-search-last-update-face :inherit 'nano-face-salient)
    (elfeed-search-title-face :inherit 'nano-face-default)
    (elfeed-search-tag-face :inherit 'nano-face-faded)
    (elfeed-search-unread-count-face :inherit 'nano-face-strong)
    (elfeed-search-unread-title-face :inherit 'nano-face-strong)

    ;; deft
    (deft-filter-string-error-face :inherit 'nano-face-popout)
    (deft-filter-string-face :inherit 'nano-face-default)
    (deft-header-face :inherit 'nano-face-salient)
    (deft-separator-face :inherit 'nano-face-faded)
    (deft-summary-face :inherit 'nano-face-faded)
    (deft-time-face :inherit 'nano-face-salient)
    (deft-title-face :inherit 'nano-face-strong)

    ;; rst
    (rst-adornment :inherit 'nano-face-faded)
    (rst-block :inherit 'nano-face-default)
    (rst-comment :inherit 'nano-face-faded)
    (rst-definition :inherit 'nano-face-salient)
    (rst-directive :inherit 'nano-face-salient)
    (rst-emphasis1 :inherit 'nano-face-faded)
    (rst-emphasis2 :inherit 'nano-face-strong)
    (rst-external :inherit 'nano-face-salient)
    (rst-level-1 :inherit 'nano-face-strong)
    (rst-level-2 :inherit 'nano-face-strong)
    (rst-level-3 :inherit 'nano-face-strong)
    (rst-level-4 :inherit 'nano-face-strong)
    (rst-level-5 :inherit 'nano-face-strong)
    (rst-level-6 :inherit 'nano-face-strong)
    (rst-literal :inherit 'nano-face-salient)
    (rst-reference :inherit 'nano-face-salient)
    (rst-transition :inherit 'nano-face-default)

    ;; markdown
    (markdown-blockquote-face :inherit 'nano-face-default)
    (markdown-bold-face :inherit 'nano-face-strong)
    (markdown-code-face :inherit 'nano-face-default)
    (markdown-comment-face :inherit 'nano-face-faded)
    (markdown-footnote-marker-face :inherit 'nano-face-default)
    (markdown-footnote-text-face :inherit 'nano-face-default)
    (markdown-gfm-checkbox-face :inherit 'nano-face-default)
    (markdown-header-delimiter-face :inherit 'nano-face-faded)
    (markdown-header-face :inherit 'nano-face-strong)
    (markdown-header-face-1 :inherit 'nano-face-strong)
    (markdown-header-face-2 :inherit 'nano-face-strong)
    (markdown-header-face-3 :inherit 'nano-face-strong)
    (markdown-header-face-4 :inherit 'nano-face-strong)
    (markdown-header-face-5 :inherit 'nano-face-strong)
    (markdown-header-face-6 :inherit 'nano-face-strong)
    (markdown-header-rule-face :inherit 'nano-face-default)
    (markdown-highlight-face :inherit 'nano-face-default)
    (markdown-hr-face :inherit 'nano-face-default)
    (markdown-html-attr-name-face :inherit 'nano-face-default)
    (markdown-html-attr-value-face :inherit 'nano-face-default)
    (markdown-html-entity-face :inherit 'nano-face-default)
    (markdown-html-tag-delimiter-face :inherit 'nano-face-default)
    (markdown-html-tag-name-face :inherit 'nano-face-default)
    (markdown-inline-code-face :inherit 'nano-face-popout)
    (markdown-italic-face :inherit 'nano-face-faded)
    (markdown-language-info-face :inherit 'nano-face-default)
    (markdown-language-keyword-face :inherit 'nano-face-default)
    (markdown-line-break-face :inherit 'nano-face-default)
    (markdown-link-face :inherit 'nano-face-salient)
    (markdown-link-title-face :inherit 'nano-face-default)
    (markdown-list-face :inherit 'nano-face-faded)
    (markdown-markup-face :inherit 'nano-face-faded)
    (markdown-math-face :inherit 'nano-face-default)
    (markdown-metadata-key-face :inherit 'nano-face-faded)
    (markdown-metadata-value-face :inherit 'nano-face-faded)
    (markdown-missing-link-face :inherit 'nano-face-default)
    (markdown-plain-url-face :inherit 'nano-face-default)
    (markdown-pre-face :inherit 'nano-face-default)
    (markdown-reference-face :inherit 'nano-face-salient)
    (markdown-strike-through-face :inherit 'nano-face-faded)
    (markdown-table-face :inherit 'nano-face-default)
    (markdown-url-face :inherit 'nano-face-salient)

    ;; ivy
    (ivy-action :inherit 'nano-face-faded)
    (ivy-completions-annotations :inherit 'nano-face-faded)
    (ivy-confirm-face :inherit 'nano-face-faded)
    (ivy-current-match :inherit '(nano-face-strong nano-face-subtle))
    (ivy-cursor :inherit 'nano-face-strong)
    (ivy-grep-info :inherit 'nano-face-strong)
    (ivy-grep-line-number :inherit 'nano-face-faded)
    (ivy-highlight-face :inherit 'nano-face-strong)
    (ivy-match-required-face :inherit 'nano-face-faded)
    (ivy-minibuffer-match-face-1 :inherit 'nano-face-faded)
    (ivy-minibuffer-match-face-2 :inherit 'nano-face-faded)
    (ivy-minibuffer-match-face-3 :inherit 'nano-face-faded)
    (ivy-minibuffer-match-face-4 :inherit 'nano-face-faded)
    (ivy-minibuffer-match-highlight :inherit 'nano-face-strong)
    (ivy-modified-buffer :inherit 'nano-face-popout)
    (ivy-modified-outside-buffer :inherit 'nano-face-strong)
    (ivy-org :inherit 'nano-face-faded)
    (ivy-prompt-match :inherit 'nano-face-faded)
    (ivy-remote :inherit 'nano-face-default)
    (ivy-separator :inherit 'nano-face-faded)
    (ivy-subdir :inherit 'nano-face-faded)
    (ivy-virtual :inherit 'nano-face-faded)
    (ivy-yanked-word :inherit 'nano-face-faded)

    ;; helm
    (helm-selection :inherit '(nano-face-strong nano-face-subtle))
    (helm-match :inherit 'nano-face-strong)
    (helm-source-header :inherit 'nano-face-salient)
    (helm-swoop-target-line-face :inherit '(nano-face-strong nano-face-subtle))
    (helm-visible-mark :inherit 'nano-face-strong)
    (helm-moccur-buffer :inherit 'nano-face-strong)
    (helm-ff-file :inherit 'nano-face-faded)
    (helm-ff-prefix :inherit 'nano-face-strong)
    (helm-ff-dotted-directory :inherit 'nano-face-faded)
    (helm-ff-directory :inherit 'nano-face-strong)
    (helm-ff-executable :inherit 'nano-face-popout)
    (helm-grep-match :inherit 'nano-face-strong)
    (helm-grep-file :inherit 'nano-face-faded)
    (helm-grep-lineno :inherit 'nano-face-faded)
    (helm-grep-finish :inherit 'nano-face-default)

    ;; company
    (company-tooltip-selection :inherit '(nano-face-strong nano-face-subtle))
    (company-tooltip :inherit 'nano-face-default)
    (company-scrollbar-fg :inherit 'nano-face-faded)
    (company-scrollbar-bg :inherit 'nano-face-default)
    (company-tooltip-common :inherit 'nano-face-default)
    (company-tooltip-common-selection :inherit '(nano-face-strong nano-face-subtle))
    (company-tooltip-annotation :inherit 'nano-face-default)
    (company-tooltip-annotation-selection :inherit '(nano-face-strong nano-face-subtle))

    ;; notmuch
    (notmuch-search-matching-authors :inherit 'nano-face-default)
    (notmuch-search-date :inherit 'nano-face-default)
    (notmuch-search-count :inherit 'nano-face-faded)
    (notmuch-tag-face :inherit 'nano-face-default)
    (notmuch-tag-unread :inherit 'nano-face-popout)
   )


  ;; --- extra variables ---------------------
  ()
  )

;; (provide 'nano-doom-themes)
