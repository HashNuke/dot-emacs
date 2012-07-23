(require 'cl)
(push "/usr/local/bin" exec-path)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")


(setq color-theme-is-global t)
(load "~/.emacs.d/hooks")

(load-theme 'tomorrow-night t)

(unless (require 'el-get nil t)
  (url-retrieve
    "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
    (lambda (s)
    (let (el-get-master-branch)
      (end-of-buffer)
      (eval-print-last-sexp)))))

;; custom packages and their sources
(setq
 el-get-sources
 '((:name buffer-move     ; have to add your own keys
    :after (progn (lambda ()
       (global-set-key (kbd "<C-S-up>")     'buf-move-up)
       (global-set-key (kbd "<C-S-down>")   'buf-move-down)
       (global-set-key (kbd "<C-S-left>")   'buf-move-left)
       (global-set-key (kbd "<C-S-right>")  'buf-move-right))))

   (:name smex        ; a better (ido like) M-x
    :after (progn (lambda ()
       (setq smex-save-file "~/.emacs.d/.smex-items"))
       (global-set-key (kbd "M-x") 'smex)
       (global-set-key (kbd "M-X") 'smex-major-mode-commands)))
   
   (:name ruby-mode
	  :type elpa
	  :after (progn (lambda () (ruby-mode-hook))))

   (:name vline
          :type elpa)

   (:name css-mode 
	  :type elpa 
          :after (progn (lambda () (css-mode-hook))))

   (:name rainbow-mode
          :type elpa)

   (:name yasnippet
          :type git
          :url "git://github.com/capitaomorte/yasnippet.git"
          :load "yasnippet.el")

   (:name feature-mode
          :type git
          :url "https://github.com/michaelklishin/cucumber.el.git"
          :load "feature-mode.el")

   (:name textmate
	  :type git
	  :url "git://github.com/defunkt/textmate.el.git"
	  :load "textmate.el")

   (:name js2-mode
	  :type git
	  :url "https://github.com/mooz/js2-mode.git"
	  :load "js2-mode.el")

   (:name haml-mode
	  :type git
	  :url "git://github.com/nex3/haml-mode.git"
	  :load "haml-mode.el")

   (:name sass-mode
	  :type git
	  :url "git://github.com/nex3/sass-mode.git"
	  :load "sass-mode.el")

   (:name rspec
          :type git
          :url "https://github.com/pezra/rspec-mode.git"
          :load "rspec-mode.el"
          :compile ("rspec-mode.el"))

   (:name gist-mode
          :type git 
          :url "https://github.com/defunkt/gist.el.git"
          :load "gist.el"
          :compile ("gist.el"))
   
   (:name rhtml
	  :type git
	  :url "https://github.com/eschulte/rhtml.git"
	  :features rhtml-mode
	  :after (progn (lambda () (rhtml-mode-hook))))

   (:name magit       ; git meet emacs, and a binding
    :after (progn (lambda ()
       (global-set-key (kbd "C-x C-z") 'magit-status))))

   (:name goto-last-change    ; move pointer back to last change
    :after (progn (lambda ()
       ;; when using AZERTY keyboard, consider C-x C-_
       (global-set-key (kbd "C-x C-/") 'goto-last-change))))))



;; load the packages required
;; now set our own packages
(setq
 my:el-get-packages
 '(;el-get              ; el-get is self-hosting
   php-mode-improved    ; if you're into php...
   switch-window        ; takes over C-x o
   auto-complete        ; complete as you type with overlays
   zencoding-mode       ; http://www.emacswiki.org/emacs/ZenCoding
   color-theme          ; nice looking emacs
   haml-mode
   sass-mode
   js2-mode
   yasnippet
   rspec-mode
   ruby-mode
   vline
   ;; perspective
   yaml-mode
   coffee-mode
   scss-mode))

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer 
        (delq (current-buffer) 
          (remove-if-not 'buffer-file-name (buffer-list)))))

(defun kill-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(defun echo-false-comint ()
  (setq comint-process-echoes t))

(add-hook 'comint-mode-hook 'echo-false-comint)

;;
;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
;;
(when (el-get-executable-find "cvs")
  (add-to-list 'my:el-get-packages 'emacs-goodies-el)) ; the debian addons for emacs

(when (el-get-executable-find "svn")
  (loop for p in '(psvn       ; M-x svn-status
       yasnippet    ; powerful snippet mode
       )
  do (add-to-list 'my:el-get-packages p)))

(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)


;; i hate tabs
(setq-default indent-tabs-mode nil)

;; on to the visual settings
(setq inhibit-splash-screen t)    ; no splash screen, thanks
(line-number-mode 1)        ; have line numbers and
(column-number-mode 1)      ; column numbers in the mode line
(setq linum-format "%d  ")
(menu-bar-mode 0)

(blink-cursor-mode t)
(show-paren-mode t) ;highlights parens
;; (setq ido-show-dot-for-dired t)
 ; if mark active, insertion replaces selection
(delete-selection-mode t)

(tool-bar-mode -1)      ; no tool bar with icons
(scroll-bar-mode -1)     ; no scroll bars
(unless (string-match "apple-darwin" system-configuration)
  ;; on mac, there's always a menu bar drown, don't have it empty
  (menu-bar-mode -1))

;; choose your own fonts, in a system dependant way
;; (if (string-match "apple-darwin" system-configuration)
;;    (set-face-font 'default "Monaco-13")
;;  (set-face-font 'default "Monospace-10"))

(global-hl-line-mode)     ; highlight current line
(global-linum-mode 1)     ; add line numbers on the left

;; avoid compiz manager rendering bugs
(add-to-list 'default-frame-alist '(alpha . 100))

;; Disable copy/paste with C-c and C-v and C-x, check out C-RET too
(cua-mode -1)

;; set font size to 16pt
(set-face-attribute 'default nil :height 160)

;; under mac, have Command as Meta and keep Option for localized input
(when (string-match "apple-darwin" system-configuration)
  (setq mac-allow-anti-aliasing t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; Use the clipboard, pretty please, so that copy/paste "works"
;; (setq x-select-enable-clipboard t)

;; Navigate windows with M-<arrows>
(windmove-default-keybindings 'meta)
(setq windmove-wrap-around t)

; winner-mode provides C-<left> to get back to previous window layout
(winner-mode 1)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;; M-x shell is a nice shell interface to use, let's make it colorful.  If
;; you need a terminal emulator rather than just a shell, consider M-x term
;; instead.
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; If you do use M-x term, you will notice there's line mode that acts like
;; emacs buffers, and there's the default char mode that will send your
;; input char-by-char, so that curses application see each of your key
;; strokes.
;;
;; The default way to toggle between them is C-c C-j and C-c C-k, let's
;; better use just one key to do the same.
(require 'term)
(define-key term-raw-map  (kbd "C-'") 'term-line-mode)
(define-key term-mode-map (kbd "C-'") 'term-char-mode)

;; Have C-y act as usual in term-mode, to avoid C-' C-y C-'
;; Well the real default would be C-c C-j C-y C-c C-k.
(define-key term-raw-map  (kbd "C-y") 'term-paste)

;; use ido for minibuffer completion
(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)

;; default key to switch buffer is C-x b, but that's not easy enough
;;
;; when you do that, to kill emacs either close its frame from the window
;; manager or do M-x kill-emacs.  Don't need a nice shortcut for a once a
;; week (or day) action.
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
;;(global-set-key (kbd "C-x C-c") 'ido-switch-buffer)
(global-set-key (kbd "C-x B") 'ibuffer)

;; this takes care of the meta-key
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; backward word kill
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; C-x C-j opens dired with the cursor right on the file you're editing
(require 'dired-x)

;; full screen
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
           (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [f11] 'fullscreen)

(setq make-backup-files nil)
(setq auto-save-default nil)

;; coffee-mode tabbing fix
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#81a2be" "#c5c8c6"])
 '(ansi-term-color-vector [unspecified "#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#81a2be" "#c5c8c6"] t)
 '(coffee-tab-width 2)
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(custom-safe-themes (quote ("9a661ab3f59729ab4df6669cc0e6f880a8c6fbfc" default)))
 '(menu-bar-mode nil)
 '(safe-local-variable-values (quote ((encoding . utf-8) (ruby-compilation-executable . "ruby") (ruby-compilation-executable . "ruby1.8") (ruby-compilation-executable . "ruby1.9") (ruby-compilation-executable . "rbx") (ruby-compilation-executable . "jruby"))))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; set color theme
(defalias 'yes-or-no-p 'y-or-n-p)
