;;; package --- Summary
;;; Code:
;;; Commentary:
(global-font-lock-mode 1)

(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq tab-stop-list (number-sequence 2 200 2))
(setq indent-line-function 'insert-tab)

(require 'package)
(defvar package-list)
(setq package-list '(auto-complete magit jump inflections findr ruby-mode web-mode yaml-mode flycheck feature-mode markdown-mode json-mode go-mode go-autocomplete jedi helm-ls-git rainbow-delimiters speedbar moe-theme powerline go-eldoc helm-swoop sr-speedbar evil git-gutter)) ;helm-go-package))
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(dolist (package package-list)
  (when (not (package-installed-p package))
    (package-install package)))

(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Berksfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Thorfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rhtml$" . html-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.go" . go-mode))
(setq ac-disable-inline t)
(require 'auto-complete)
(require 'go-autocomplete)

(global-auto-complete-mode t)

(add-hook 'after-init-hook #'global-flycheck-mode)

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
(make-directory "~/.virtualenvs" t)
(setq jedi:environment-root "~/.virtualenvs/python3-base")
(setq jedi:environment-virtualenv
      (list "virtualenv" "-p" "/usr/bin/python3" "--system-site-packages"))

(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump))
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
;  (go-oracle-mode)
(add-hook 'go-mode-hook 'my-go-mode-hook)

;(eval-after-load 'go-mode
;                   '(substitute-key-definition 'go-import-add 'helm-go-package go-mode-map))

(column-number-mode)


; Fuzzy matching
(require 'ido)
(ido-mode t)
;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
(defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
(add-hook 'ido-setup-hook 'ido-define-keys)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(fset 'yes-or-no-p 'y-or-n-p)
(set 'use-dialog-box t)

(defadvice yes-or-no-p (around prevent-dialog activate)
           "Prevent yes-or-no-p from activating a dialog"
           (let ((use-dialog-box nil))
             ad-do-it))
(defadvice y-or-n-p (around prevent-dialog-yorn activate)
           "Prevent y-or-n-p from activating a dialog"
           (let ((use-dialog-box nil))
             ad-do-it))

;(projectile-global-mode)
(global-set-key (kbd "s-1") 'delete-other-windows)
(global-set-key (kbd "s-S-h") 'replace-regexp)
(global-set-key (kbd "s-b") 'ido-switch-buffer)
(global-set-key (kbd "s-d") 'ido-switch-buffer)
(global-set-key (kbd "s-f") 'isearch-forward)
(global-set-key (kbd "s-h") 'replace-string)
(global-set-key (kbd "s-l") 'goto-line)
(global-set-key (kbd "s-l") 'sr-speedbar-toggle)
(global-set-key (kbd "s-n") 'new-buffer)
(global-set-key (kbd "s-o") 'ido-find-file)
(global-set-key (kbd "s-p") 'helm-ls-git-ls)
(setq-default compile-command "go build -v && go test -v && go vet")
(global-set-key (kbd "s-t") 'recompile)
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-w") 'kill-this-buffer)
(global-set-key (kbd "s-z") 'undo)



(electric-pair-mode t)

(setq inhibit-startup-message t)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'go-mode-hook 'rainbow-delimiters-mode)

(require 'speedbar)
(make-face 'speedbar-face)
(set-face-font 'speedbar-face "Droid Sans-9")
(setq speedbar-mode-hook '(lambda () (buffer-face-set 'speedbar-face)))
;(setq sr-speedbar-right-side)
(speedbar-add-supported-extension ".go")

(setq-default tab-width 4) 

(menu-bar-mode -1)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Liberation Mono for Powerline" :foundry "unknown" :slant normal :weight normal :height 140 :width normal)))))
; Powerline not working
(require 'powerline)
(powerline-default-theme)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(cua-mode t nil (cua-base))
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode (quote (only . t)))
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))

(global-hl-line-mode 1)
(global-linum-mode)
(setq flycheck-display-errors-delay 0.3)
(setq scroll-step 1)
(add-hook 'flycheck-mode-hook 'flycheck-list-errors)

(require 'moe-theme)
(powerline-moe-theme)
;(moe-light)

(require 'go-eldoc)
(add-hook 'go-mode-hook 'go-eldoc-setup)

(setq helm-swoop-split-direction 'split-window-vertically)

(require 'sr-speedbar)
(setq speedbar-use-images nil)
;(setq sr-speedbar-right-side t)
(setq sr-speedbar-left-side t)
(setq sr-speedbar-max-width 10)
;(sr-speedbar-open)

(require 'evil)
(evil-mode 1)

(load-file "$GOPATH/src/golang.org/x/tools/refactor/rename/rename.el")
(load-file "$GOPATH/src/code.google.com/p/go.tools/cmd/oracle/oracle.el")

(require 'git-gutter)
(global-git-gutter-mode t)
(git-gutter:linum-setup)
(custom-set-variables
   '(git-gutter:update-interval 2))
(provide 'init)
;;; init.el ends here
