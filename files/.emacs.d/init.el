(load-theme 'tango-dark)
(global-linum-mode t)
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(tool-bar-mode -1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company-jedi company use-package flycheck neotree projectile which-key))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  :bind-keymap
  ("s-p" . projectile-command-map)
  ("C-c p" . projectile-command-map))

(use-package neotree
  :ensure t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))

(use-package company
  :ensure t)

(add-hook 'after-init-hook 'global-company-mode)

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(use-package company-jedi
  :ensure t
  :hook ('python-mode-hook 'my/python-mode-hook))

;; neotree - jump to opened file
(setq neo-smart-open t)

;; change neotree root when projectile project changes
(setq projectile-switch-project-action 'neotree-projectile-action)

