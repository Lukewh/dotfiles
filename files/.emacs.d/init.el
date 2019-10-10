(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" default)))
 '(package-selected-packages
   (quote
    (company-tern elpy helm-projectile helm solarized-theme company-quickhelp blacken treemacs-projectile editorconfig projectile-mode flycheck prettier-js pretter-js company buffer-move yaml-mode rjsx-mode org-bullets which-key try use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun indentation (n)
  (setq-local js-indent-level n)
  (setq-local css-indent-offset n))

(defun set-environment ()
  (interactive)
  (message "2 space indentation")

  (setq indent-tabs-mode nil)

  (indentation 2))

;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Backup files in ~/.saves
(setq backup-directory-alist '(("." . "~/.saves")))

(add-to-list 'default-frame-alist '(font . "Essential PragmataPro-13"))

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package try
  :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package helm
  :ensure t
  :config (helm-mode 1))

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(use-package treemacs
  :ensure t
  :bind
  (:map global-map
	([f8] . treemacs))
  :config
  (progn
   (setq treemacs-is-never-other-window t)))

(use-package buffer-move
  :ensure t)

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode))

(use-package company-quickhelp
  :ensure t
  :config
  (company-quickhelp-mode))

(use-package company-tern
  :ensure t
  :init
  (add-to-list 'company-backends 'company-tern)
   (add-hook 'prettier-js-mode-hook (lambda () (tern-mode t))))

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map)
  (projectile-mode +1))

(use-package helm-projectile
  :ensure t
  :config (helm-projectile-on))

(use-package treemacs-projectile
  :ensure t)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;; Modes
(use-package rjsx-mode
  :ensure t
  :mode "\\.js\\'")

(use-package flycheck
  :ensure t
  :init
  (progn
    (global-flycheck-mode)
    (add-hook 'flycheck-mode-hook 'my/use-eslint-from-node-modules)))

(use-package prettier-js
  :ensure t)
(add-hook 'rjsx-mode-hook 'prettier-js-mode)

(use-package blacken
  :ensure t)
(setq blacken-line-length 79)
(add-hook 'python-mode-hook 'blacken-mode)

(use-package yaml-mode
  :ensure t
  :mode "\\.ya?ml\\'")

;; Themes
;(use-package doom-themes
;  :ensure t
                                        ;  :config (load-theme 'doom-one t))
(use-package solarized-theme
  :ensure t
  :init (
         load-theme 'solarized-dark))

;; Org-mode stuff
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;;(setq indo-enable-flex-matching t)
;;(setq ido-everywhere t)
;;(ido-mode 1)

;; Programming hooks
(add-hook 'prog-mode-hook 'set-environment)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Prevent ctrl + z fucking things up
(global-unset-key (kbd "C-z"))

(show-paren-mode 1)

;; ctrl + d delete line
(global-set-key "\C-d" 'kill-whole-line)

