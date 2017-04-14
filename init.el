
(when (equal system-type 'darwin)
    (setq mac-option-modifier 'meta))

(defmacro defvar-setq (name value)
    (if (boundp name)
    `(setq ,name ,value)
    `(defvar ,name ,value)))


;; Clipboard functions
(setq x-select-enable-clipboard t)
;; This was used on the mac
;;(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
(setq interprogram-paste-function 'x-selection-value)

(require 'package) 
;;(add-to-list 'package-archives '("elpa" . "http://tromey.com/elpa/") t)
;;(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(package-initialize) 
(require 'use-package)
(setq use-package-always-ensure t)
(desktop-save-mode 1)
;; use-package is only needed at compile time.

(use-package helm-config
    :ensure helm
    :config (progn (helm-mode 1))
    :demand t
    :bind (("M-y" . helm-show-kill-ring)
        ("M-x" . helm-M-x)
	("C-x x" . helm-M-x)
        ("C-x C-i" . helm-imenu)
        ("C-h a" . helm-apropos)
        ("C-c C-h" . helm-org-agenda-files-headings)
	("C-x C-f" . helm-find-files)
        ("C-c ;" . helm-recentf))
    )

(use-package projectile
  :config (progn (projectile-global-mode)))

(use-package evil)
(use-package helm-themes)
(use-package helm-projectile)
(use-package helm-ag)
(use-package go-mode)
(use-package auto-complete)
(use-package go-autocomplete)
(use-package server
    :config
        (progn
            (unless (server-running-p) (server-start))))
(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))
(use-package jedi)
(use-package elpy)
(use-package flycheck
  :config
  (progn (global-flycheck-mode))
  :diminish flycheck-mode)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package ace-window
  :config
  (progn
    ;; We use this so we can actually grab it in a terminal, unlike meta commands
    (global-set-key (kbd "C-x p") 'ace-window)
    (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))))

;; NEOTREE setup
(add-to-list 'load-path "/Users/jmccarthy/src/learning/redux-saga-beginner-tutorial")
(use-package neotree)
(global-set-key [f8] 'neotree-toggle)

(evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)


;;(exec-path-from-shell-copy-env "GOPATH")

;; autocomplete
(require 'auto-complete-config)
(ac-config-default)

;; General Emacs
(line-number-mode t)
(column-number-mode t)
(global-linum-mode t)
(show-paren-mode 1)
(evil-mode 1)
(setq tab-width 3)
	
;; KEYBINDINGS
(bind-key "S-C-<left>" 'shrink-window-horizontally)
(bind-key "S-C-h" 'shrink-window-horizontally)

(bind-key "S-C-<right>" 'enlarge-window-horizontally)
(bind-key "S-C-l" 'enlarge-window-horizontally)

(bind-key "S-C-<down>" 'shrink-window)
(bind-key "S-C-j" 'shrink-window)

(bind-key "S-C-<up>" 'enlarge-window)
(bind-key "S-C-k" 'enlarge-window)

(bind-key "S-C-f" 'toggle-frame-fullscreen)

;;(unbind-key "C-c p s a" projectile-command-map)
;;(unbind-key "C-c p s g" projectile-command-map)
;;(unbind-key "C-c p s s" projectile-command-map)
(bind-key "C-c p f" 'helm-projectile	)
(bind-key "C-c s" 'helm-projectile-ag)


;; APPEARANCE
(defun remove-fringe-and-hl-line-mode (&rest stuff)
    (interactive)
    (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
    (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
        (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
        ;;(set-fringe-mode 0) ;; Lets reenable fringes. They seem useful
        (defvar-setq linum-format 'dynamic)
        (setq left-margin-width 0)
        (defvar-setq hl-line-mode nil))

(defun setappearance (&optional frame)
    (interactive)
    (message "called set appearance")
    (if (display-graphic-p)
        (progn
            ;;(set-face-attribute 'default nil :font "Source Code Pro")
            (set-face-attribute 'default nil :weight 'semi-bold)
            (set-face-attribute 'default nil :height 135))
        (progn
            (load-theme 'source-code-pro t)
            (message "not setting font")))
        ;;(load-theme imalison:dark-theme t)
        (remove-fringe-and-hl-line-mode)

        (message "finished set appearance"))
(load-theme 'spacemacs-dark' t)
(add-hook 'after-init-hook 'setappearance)
(add-hook 'after-make-frame-functions 'setappearance)

;; GO HOOKS

(setq exec-path (cons "/usr/local/go/bin" exec-path))
(add-to-list 'exec-path "/Users/jmccarthy/src/go/bin")

(defun my-go-mode-hook ()
  ;; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go generate && go build -v && go test -v && go vet"))
  ;; Godef jump key binding
  ;;(local-set-key (kbd "M-.") 'godef-jump))
  (setq tab-width 3)
  (bind-key "M-d" 'godef-jump))


(add-hook 'go-mode-hook 'my-go-mode-hook)
