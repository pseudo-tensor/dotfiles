;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-themes-enable-bold nil
      doom-themes-enable-italic nil)
(setq doom-theme 'doom-one)

(after! doom-themes
  (custom-set-faces!
    '(default :background "#1d2021")
    '(doom-modeline-bar :background "#1d2021")
    '(mode-line :background "#1d2021")
    '(mode-line-inactive :background "#1d2021")
    '(minibuffer-prompt :background "#1d2021")
    '(hl-line :background "#282828")
    '(region :background "#3c3836")))

(setq display-line-numbers-type 'relative)
(setq org-directory "~/org/")

(setq doom-font (font-spec :family "ZedMono Nerd Font Mono" :size 20 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "ZedMono Nerd Font Mono" :size 20)
      doom-big-font (font-spec :family "ZedMono Nerd Font Mono" :size 22))

(setq evil-default-cursor 'box)
(setq evil-insert-state-cursor 'box)

;; Prevent Doom from auto-enabling tree-sitter
(after! doom-editor
  (setq major-mode-remap-alist nil))

;; Make tree-sitter modes redirect to classic modes
(defalias 'c++-ts-mode #'c++-mode)
(defalias 'c-ts-mode #'c-mode)

(after! lsp-mode
  (setq lsp-enable-on-type-formatting nil
        lsp-enable-indentation nil))

(after! lsp-mode
  (setq lsp-lens-enable nil)
  (setq lsp-rust-analyzer-lens-enable nil))

;; Clear the remap
(setq major-mode-remap-alist
      (assq-delete-all 'c++-mode major-mode-remap-alist))
(setq major-mode-remap-alist
      (assq-delete-all 'c-mode major-mode-remap-alist))

;; Fix indentation - use Linux/K&R style
(after! cc-mode
  (setq c-default-style '((java-mode . "java")
                          (awk-mode . "awk")
                          (other . "linux"))
        indent-tabs-mode nil      ;; disable tabs
        c-basic-offset 4)

  ;; Custom offsets to prevent function brace indentation
  (c-set-offset 'defun-open 0)
  (c-set-offset 'defun-close 0)
  (c-set-offset 'defun-block-intro '+)
  (c-set-offset 'class-open 0)
  (c-set-offset 'inline-open 0)
  (c-set-offset 'block-open 0)
  (c-set-offset 'statement-block-intro '+)
  (c-set-offset 'substatement-open 0))

(setq company-tooltip-limit 5)

(add-hook 'c-mode-common-hook (lambda () (setq indent-tabs-mode nil)))

(map! :n "H" #'previous-buffer
      :n "L" #'next-buffer)
