;; Load straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Load use-package
(straight-use-package 'use-package)

;; Use straight by default for use-package
(use-package straight
  :custom
  (straight-use-package-by-default t)
  (use-package-always-ensure 't))

(setq debug-on-error nil)


;; General configuration
;;;; Higher garbage collection threshold
(setq gc-cons-threshold 100000000)
;;;; Higher memory usage
(setq read-process-output-max (* 1024 4096))
;;;; No auto-save plz
(setq auto-save-default nil)
;;;; No backup files plz
(setq make-backup-files nil)
;;;; No lock files plz
(setq create-lockfiles nil)
;;;; Don't shout about warnings
(setq warning-minimum-level :emergency)

(setq calendar-set-date-style 'european)
(setq org-startup-indented t)

;; Modes
;;;; Delete selection
(delete-selection-mode t)
;;;; Remove toolbar
(tool-bar-mode -1)
;;;; Remove context menu
(menu-bar-mode -1)
;;;; Pretty up symbols
(global-prettify-symbols-mode 1)
;;;; Highlight the current line
(global-hl-line-mode 1)
;;;; Display column number in modeline
(column-number-mode 1)

;; Theme
;;;; Font
(add-to-list 'default-frame-alist '(font . "PragmataPro Mono Liga-12"))
;;;; Set all fonts - fixes lsp-mode sideline and docs
(set-face-attribute 'fixed-pitch nil :family "PragmataPro Mono Liga-12")
(set-face-attribute 'variable-pitch nil :family "Open Sans-12")

;;;; Theme
(setq modus-themes-syntax '(green-strings yellow-comments alt-syntax))
(setq modus-themes-bold-constructs t)
(setq modus-themes-italic-constructs t)
(setq modus-themes-hl-line '(accented))
(setq modus-themes-subtle-line-numbers t)
(setq modus-themes-paren-match '(intense))
(load-theme 'modus-vivendi)

;;;; completions
(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; General Packages
;;;; Built-in project package
(require 'project)

;;;; Get the shell paths, not emacs custom
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;;;; Include local node modules
(use-package add-node-modules-path)

;;;; Why would you never use direnv?
(use-package envrc
  :config (envrc-global-mode))

;;;; Hints for key chords
(use-package which-key
  :config (which-key-mode))

;;;; Expand and contract the selection with ease
(use-package expand-region
  :bind (("C-=" . er/expand-region)
         ("C--" . er/contract-region)))

;;;; Git
(use-package magit
  :bind (("C-x g" . magit-status)))

;;;; Company
(use-package company)
;;;; Company box for use with copilot
(use-package company-box)

;;;; Flycheck
(use-package flycheck)

;; Custom globals
;;;; Kill the buffer without a prompt
(defun lukewh/kill-buffer ()
  "Kill the active buffer, without a prompt."
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x K") 'lukewh/kill-buffer)

;;;; Flycheck shortcuts
(global-set-key (kbd "C-c N") #'flycheck-next-error)
(global-set-key (kbd "C-c P") #'flycheck-previous-error)

;;;; Tabs and spaces
;; Our Custom Variable
(setq custom-tab-width 2)

(defun disable-tabs () (setq-default indent-tabs-mode nil))
(defun enable-tabs  ()
  (local-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq-default indent-tabs-mode t)
  (setq-default tab-width custom-tab-width))

(disable-tabs)
;; Making electric-indent behave sanely
(setq-default electric-indent-inhibit t)

;; Make the backspace properly erase the tab instead of
;; removing 1 space at a time.
(setq backward-delete-char-untabify-method 'hungry)

;; WARNING: This will change your life
;; (OPTIONAL) Visualize tabs as a pipe character - "|"
;; This will also show trailing characters as they are useful to spot.
(setq whitespace-style '(face tabs tab-mark trailing))
(custom-set-faces
 '(whitespace-tab ((t (:foreground "#636363")))))
(setq whitespace-display-mappings
  '((tab-mark 9 [124 9] [92 9]))) ; 124 is the ascii ID for '\|'
(global-whitespace-mode) ; Enable whitespace mode everywhere
; END TABS CONFIG

;; Programming (general)
(use-package rainbow-delimiters)
(use-package copilot
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :init (setq copilot-idle-delay 1))

(defun lukewh/code ()
  "Init common modes."
  (interactive)
  (display-line-numbers-mode t)
  ;;(flymake-mode)
  (flycheck-mode)
  (company-mode)
  (company-box-mode)
  (rainbow-delimiters-mode)
  ;;(global-set-key (kbd "C-c c c") #'copilot-mode)
  (copilot-mode 1)
  (define-key copilot-completion-map (kbd "C-<tab>") 'copilot-accept-completion)
  (global-set-key (kbd "C-.") #'xref-find-definitions)
  (global-set-key (kbd "C-,") #'xref-find-references))

;;;; lsp-mode
(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-c l")
  :hook (
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp lsp-deferred)

(defun lukewh/lsp-followup ()
  "Some follow up stuff for when lsp-mode has been activated"
  (interactive)
  ;; m-. for definitions
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  ;; m-, for references
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references))

(use-package lsp-ui
  :custom
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-code-actions t)
  ;;(lsp-diagnostics-provider :flymake)
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  :config
  (lukewh/lsp-followup)
  :commands lsp-ui-mode)

;; Javascript
;;;; prettier
(use-package prettier-js)

;;;; Hook
(defun lukewh/javascript-editing ()
  "Start javscript editing."
  (interactive)
  (setq-default js-indent-level custom-tab-width)
  (prettier-js-mode)
  ; some settings for deno
  (setq lsp-clients-deno-config "./tsconfig.json")
  (setq lsp-clients-deno-import-map "./import_map.json")
  (lsp-deferred))

(add-hook 'js-mode-hook 'lukewh/javascript-editing)

;; Typescript
;;;; mode
(use-package typescript-mode)
(add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-mode))

;;;; Hook
(defun lukewh/typescript-editing ()
  "Start Typescript editing."
  (interactive)
  (setq-default typescript-indent-level custom-tab-width)
  (prettier-js-mode)
  ; some settings for deno
  (setq lsp-clients-deno-config "./tsconfig.json")
  (setq lsp-clients-deno-import-map "./import_map.json")
  (lsp-deferred))

(add-hook 'typescript-mode-hook 'lukewh/typescript-editing)

;; SCSS
(defun lukewh/scss-editing ()
  "Start SCSS editing."
  (interactive)
  (setq-default css-indent-offset custom-tab-width)
  (prettier-js-mode)
  (lsp-deferred))

(add-hook 'scss-mode-hook 'lukewh/scss-editing)

;; Python
;;;; flake8
;;(use-package flymake-python-pyflakes
;;  :custom (flymake-python-pyflakes-executable "flake8"))
(use-package flycheck-local-flake8
  :straight (:host github :repo "rmuslimov/flycheck-local-flake8" :files ("*.el")))
(add-hook 'flycheck-before-syntax-check-hook
          #'flycheck-local-flake8/flycheck-virtualenv-set-python-executables 'local)

;;;; black
;;;; install black globally first 'pip install black'
(use-package python-black
  :custom (python-black-extra-args '("--line-length" "79")))

;;;; virtualenvwrapper
(use-package virtualenvwrapper)

;;;; auto-virtualenvwrapper
(use-package auto-virtualenvwrapper)

;;;; lsp-server
"Each project should contain a pyrightconfig.json file
{
  'include': ['webapp', 'tests'],
  'exclude': ['.venv'],
  'venvPath': '.',
  'venv': '.venv',
  'pythonVersion': '3.8',
  'pythonPlatform': 'Linux',
  'executionEnvironment': [
    {
      'root': './webapp/',
      'venv': './'
    }
  ]
}"
(use-package lsp-pyright)

;;;; Hook
(defun lukewh/python-editing()
  "Start python editing."
  (interactive)
  (setq-default python-indent-offset 4)
  (untabify (point-min) (point-max))
  ;;(flymake-python-pyflakes-load)
  (python-black-on-save-mode)
  (auto-virtualenvwrapper-activate)
  (require 'lsp-pyright)
  ;;;;;; TODO: LSP isn't auto-starting
  (lsp-deferred))

(add-hook 'python-mode-hook 'lukewh/python-editing)

;; prog-mode
(add-hook 'prog-mode-hook 'lukewh/code)

;; Jinja 2
;;;; jinja2-mode
(use-package jinja2-mode)

;;;; Hook
(defun lukewh/jinja2-editing()
  "Start jinja2 editing."
  (interactive)
  (lukewh/code)
  ;; This is broken for some reason
  ;;(jinja2-mode)
  (lsp-deferred))

(add-hook 'html-mode-hook 'lukewh/jinja2-editing)

;; YAML
(use-package yaml-mode)

;; Beancount
(use-package beancount-mode
  :straight (beancount-mode :host github :repo "beancount/beancount-mode"))

;;;; Hook
(defun lukewh/beancount-editing()
  "Start beancount editing."
  (interactive)
  (setq-local electric-indent-chars nil)
  (outline-minor-mode)
  (setq beancount-highlight-transaction-at-point))

(add-hook 'beancount-mode-hook 'lukewh/beancount-editing)

;;;; Open .beancount files in beancount-mode
(add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode))

;; Flutter
(use-package dart-mode)

(defun lukewh/flutter()
  "Start flutter editing."
  (interactive)
  (lsp-deferred))

(add-hook 'dart-mode-hook 'lukewh/flutter)

;; COMMON LISP
(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")

;; Org mode
(defun lukewh/org-editing()
  "Org mode stuff."
  (interactive)
  (setq buffer-face-mode-face '(:family "Open Sans" :height 110 :weight normal ))
  (setq org-support-shift-select t)
  (org-sticky-header-mode)
  (org-bullets-mode)
  (visual-line-mode)
  (variable-pitch-mode t)
  (toc-org-mode)
  (buffer-face-mode)
  (auto-fill-mode 1)
  (set-fill-column 78))

(add-hook 'org-mode-hook 'lukewh/org-editing)

(setq org-hide-emphasis-markers t)
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(use-package org-sticky-header)
(use-package org-bullets)
(use-package toc-org)

;; rust-lang
(use-package rust-mode)
(defun lukewh/rust-editing()
  "Rust stuff."
  (interactive)
  (setq rust-format-on-save t)
  (setq indent-tabs-mode nil)
  (rust-mode)
  (lsp-deferred))

(add-hook 'rust-mode-hook 'lukewh/rust-editing)

;; popper
(use-package popper
  :bind (("C-`" . popper-cycle))
  :config
  (popper-mode +1)
  (setq popper-group-function #'popper-group-by-project)
  (setq popper-mode-line nil)
  (setq popper-reference-buffers
        '("^\\*eshell.*\\*$" eshell-mode ;eshell as a popup
          "^\\*shell.*\\*$"  shell-mode  ;shell as a popup
          "^\\*term.*\\*$"   term-mode   ;term as a popup
          "^\\*vterm.*\\*$"  vterm-mode  ;vterm as a popup
          )))

;; neotree
(defun lukewh/toggle-neotree ()
        "Toggle neotree."
        (interactive)
        (if (neo-global--window-exists-p)
                (neotree-hide)
          (if (project-current) 
              (neotree-find (project-root(project-current)))
            (neotree-show)
            )
           ))

(use-package neotree
  :bind (("C-'" . lukewh/toggle-neotree))
  :config
  (setq neo-autorefresh nil))

(use-package editorconfig
  :config (editorconfig-mode 1))
