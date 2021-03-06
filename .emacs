;; Run Emacs as a server.
(server-start)

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)

;; Allow inserting unicode chars by codepoint:
;(global-set-key [?\C-#] 'ucs-insert)

(setq tramp-default-method "scp")

;;; turn on auto-fill (emacs 19)
(setq-default auto-fill-function 'do-auto-fill)

;;; Allow extra space at the end of the line
(setq-default fill-column 74)
(global-set-key "\M-p" 'fill-region)
(setq-default transient-mark-mode t)

(setq-default line-number-mode t)

;; Make lines wrap automatically in text mode.
(add-hook 'text-mode-hook
          '(lambda () (auto-fill-mode 1)))

;; add local elisp dir. to the load-path
(push "~/elisp" load-path)

(setq inferior-lisp-program "sbcl")

(setq auto-mode-alist
      (cons '("\\.ml[iylp]?$" . caml-mode) auto-mode-alist))
(autoload 'caml-mode "caml" "Major mode for editing Caml code." t)
(autoload 'run-caml "inf-caml" "Run an inferior Caml process." t)

;; js-mode
(require 'js)
(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
(add-to-list 'auto-mode-alist '("\\.es$" . js-mode))
(add-to-list 'auto-mode-alist '("\\.es6$" . js-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . js-mode))

(require 'rust-mode)
(add-to-list 'auto-mode-alist '("\\.rs$" . rust-mode))
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'company-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)
(use-package lsp-mode
             :commands lsp
             :config (require 'lsp-clients))
(use-package lsp-ui)
(use-package toml-mode)
(use-package rust-mode
             :hook (rust-mode . lsp))
(use-package cargo
             :hook (rust-mode . cargo-minor-mode))
(use-package flycheck-rust
             :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
;; https://github.com/racer-rust/emacs-racer/issues/144
(setq racer-rust-src-path
      (let* ((sysroot (string-trim
                       (shell-command-to-string "rustc --print sysroot")))
             (lib-path (concat sysroot "/lib/rustlib/src/rust/library"))
             (src-path (concat sysroot "/lib/rustlib/src/rust/src")))
        (or (when (file-exists-p lib-path) lib-path)
            (when (file-exists-p src-path) src-path))))

;; css-mode
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(add-to-list 'auto-mode-alist '("\\.less$" . css-mode))

;; julia-mode
(require 'julia-mode)
(add-to-list 'auto-mode-alist '("\\.jl$" . julia-mode))

;(require 'scala-mode)
;(add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))
;(add-to-list 'auto-mode-alist '("\\.sbt$" . scala-mode))

(setq processing-location "/usr/local/bin/processing-java")
(setq processing-application-dir "/Applications/Processing.app")
(setq processing-sketchbook-dir "~/Documents/Processing")
(setq processing-output-dir "./build-tmp")
(defun my-indent-setup ()
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close '0)
  (c-set-offset 'arglist-cont-nonempty '+))
(add-hook 'processing-mode-hook 'my-indent-setup)

; ido.el
;(require 'ido)
;(ido-mode t)
;(setq ido-enable-flex-matching t) ; enable fuzzy matching

;; TextMate
;(add-to-list 'load-path "~/elisp/textmate.el")
;(require 'textmate)

(require 'ben)

;; key bindings
(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-r" 'toggle-read-only)
(global-set-key "\C-b" 'man)
(global-set-key "\C-f" 'compile)
(global-set-key "\C-x\C-b" 'electric-buffer-list)
(global-set-key [ (f9) ] 'bs-cycle-previous)
(global-set-key [ (f10) ] 'bs-cycle-next)

;; set tab width to 4 by default
(setq-default tab-width 4)

;; spaces instead of tabs by default...
(setq-default indent-tabs-mode nil)

;; Turn off the bell
(setq visible-bell t)

;;If at beginning of a line, don't make me C-k twice.
(setq kill-whole-line t)

;; Don't let me add new lines to the bottom of a file with the downarrow
(setq-default next-line-add-newlines nil)

;; Don't let next-line add space to the bottom of your file.
(setq-default next-line-add-newlines nil)

;; Set up hungry deleting for c and c++
(setq c-hungry-delete-key 1)


;Basic unit of spaces for each indentation level.  You can change
; the 4 if you need larger or smaller indents.

(add-hook 'c++-mode-hook '(lambda ()
    (setq c-basic-offset 4)))
(add-hook 'c-mode-hook '(lambda ()
    (setq c-basic-offset 2)))


; Use only spaces for indentation (default is tabs mixed with spaces)
; so that our files will always look the same regardless of the viewing
; software.

(add-hook 'c++-mode-hook '(lambda ()
    (setq indent-tabs-mode nil)))
(add-hook 'c-mode-hook '(lambda ()
    (setq indent-tabs-mode nil)))
(add-hook 'lisp-mode-hook '(lambda ()
	(setq indent-tabs-mode nil)))
(add-hook 'python-mode-hook '(lambda ()
	(setq indent-tabs-mode nil)))

; Make Emacs display the column number in the status bar.  Versions 19
; and 20 already display the line number by default.

(setq column-number-mode t)


; Make Emacs automatically hit return for you after left curly braces,
; right curly braces, and semi-colons.

;(setq c-auto-newline 1)


; Make Emacs use "newline-and-indent" when you hit the Enter key so
; that you don't need to keep using TAB to align yourself when coding.
; This is akin to setting autoindent in vi.

(global-set-key "\C-m" 'newline-and-indent)


; Turn on auto-fill-mode (line wrapping like in a word processor).
; This is VERY nice for typing end-of-line comments, since Emacs will
; not only position you on the next line when you go beyond the
; fill-column (set below), but it will line you up with the first
; slash on the previous line and then put two slashes and a space for
; you!  (In C mode it's a "/* */" pair with the cursor positioned
; correctly in the middle.)

(add-hook 'c++-mode-hook 'turn-on-auto-fill)
(add-hook 'c-mode-hook 'turn-on-auto-fill)


; Set the fill column (the column beyond which the line will "wrap")
; to 154.  Change the 154 to whatever column you like.

(add-hook 'c++-mode-hook '(lambda ()
    (setq fill-column 74)))
(add-hook 'c-mode-hook '(lambda ()
    (setq fill-column 74)))


; Set the default comment column for end-of-line comments to 40.
; When you want to comment the end of a line of code, put the
; cursor anywhere on that line and hold down Alt and press the
; semi-colon key (';').  Emacs automatically goes to column 40, puts
; in the appropriate comment characters, and then lets you type your
; comment.  With the auto-fill feature turned on, this also allows you
; to have your comment extend beyond the end of the line and still be
; lined up and enclosed with comment characters for you on the next
; line.

(add-hook 'c++-mode-hook '(lambda ()
    (setq comment-column 40)))
(add-hook 'c-mode-hook '(lambda ()
    (setq comment-column 40)))


;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
;(global-set-key [delete] 'delete-char)
;(global-set-key [kp-delete] 'delete-char)


;; Set up mouse wheel
;(defun up-slightly () (interactive) (scroll-up 5))
;(defun down-slightly () (interactive) (scroll-down 5))
;(global-set-key [mouse-4] 'down-slightly)
;(global-set-key [mouse-5] 'up-slightly)

;(defun up-one () (interactive) (scroll-up 1))
;(defun down-one () (interactive) (scroll-down 1))
;(global-set-key [S-mouse-4] 'down-one)
;(global-set-key [S-mouse-5] 'up-one)

;(defun up-a-lot () (interactive) (scroll-up))
;(defun down-a-lot () (interactive) (scroll-down))
;(global-set-key [C-mouse-4] 'down-a-lot)
;(global-set-key [C-mouse-5] 'up-a-lot)

;; Turn on global font-locking
(global-font-lock-mode t)

;; Set default foreground and background colors
;(set-foreground-color "White")
(set-background-color "Black")
;(set-cursor-color "Blue")
;(set-mouse-color "Black")
;(set-border-color "Black")

;(cond ((fboundp 'global-font-lock-mode)
;       ;; Customize face attributes
;       (setq font-lock-face-attributes
;             ;; Symbol-for-Face Foreground Background Bold Italic Underline
;             '((font-lock-comment-face       "DarkOrchid") ;MediumOrchid
;               (font-lock-string-face        "Firebrick") ;IndianRed 
;               (font-lock-keyword-face       "Blue")      ;Magenta, MediumBlue
;               (font-lock-variable-name-face "Red")     ;OrangeRed
;               (font-lock-type-face          "Black")     
;               ;(font-lock-reference-face     "greenyellow")    ;LimeGreen
;               ;(font-lock-doc-string-face    "Goldenrod")   
;               ))
;       (copy-face 'bold 'font-lock-function-name-face)        
;       ;; Load the font-lock package.
;       (require 'font-lock)
;       ;; Maximum colors
;       (setq font-lock-maximum-decoration t)
;       ;; Turn on font-lock in all modes that support it
;       (global-font-lock-mode t)))

; Faces that may be set with font-lock:
; -------------------------------------
; font-lock-comment-face 
; font-lock-string-face 
; font-lock-keyword-face 
; font-lock-builtin-face 
; font-lock-function-name-face 
; font-lock-variable-name-face 
; font-lock-type-face 
; font-lock-constant-face 
; font-lock-warning-face 
;(set-face-foreground 'font-lock-comment-face "Red")
;(set-face-foreground 'font-lock-string-face "LimeGreen")
;(set-face-foreground 'font-lock-keyword-face "Yellow")
;(set-face-foreground 'font-lock-builtin-face "Yellow")
;(copy-face 'bold 'font-lock-function-name-face)
;(set-face-foreground 'font-lock-variable-name-face "Cyan")
;(set-face-foreground 'font-lock-type-face "Yellow")
;(set-face-foreground 'font-lock-constant-face "AquaMarine")

;; Displays the name of the file being edited in the title bar.
(setq frame-title-format "%b")

;; TypeScript mode configuration
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (setq tide-tsserver-executable "node_modules/typescript/bin/tsserver")
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (setq-default typescript-indent-level 2)
  (company-mode +1)
  (setq company-idle-delay 0))
(add-hook 'typescript-mode-hook #'setup-tide-mode)
(add-to-list 'auto-mode-alist '("\\.tsx$" . typescript-mode))

;; Fix company-mode color scheme for my dark background
(require 'color)
(let ((bg (face-attribute 'default :background)))
  (custom-set-faces
   `(company-tooltip ((t (:inherit default :background ,(color-lighten-name bg 20)))))
   `(company-scrollbar-bg ((t (:background ,(color-lighten-name bg 10)))))
   `(company-scrollbar-fg ((t (:background ,(color-lighten-name bg 5)))))
   `(company-tooltip-selection ((t (:inherit font-lock-function-name-face))))
   `(company-tooltip-common ((t (:inherit font-lock-constant-face))))))

;; Makes the screen scroll only one line when the cursor moves past the edge.
(setq scroll-step 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(current-language-environment "English")
 '(global-font-lock-mode t nil (font-lock))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (cargo lsp-ui toml-mode ## yaml-mode lsp-mode racer flycheck-rust rust-mode markdown-mode find-file-in-project company swift3-mode swift-mode tide scala-mode processing-mode)))
 '(standard-indent 4)
 '(tab-always-indent nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-scrollbar-bg ((t (:background "#199919991999"))))
 '(company-scrollbar-fg ((t (:background "#0ccc0ccc0ccc"))))
 '(company-tooltip ((t (:inherit default :background "#333333333333"))))
 '(company-tooltip-common ((t (:inherit font-lock-constant-face))))
 '(company-tooltip-selection ((t (:inherit font-lock-function-name-face)))))

(setq-default password-cache-expiry nil)

(require 'prelude-numbers)
