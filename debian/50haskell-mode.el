;; 
;; /etc/emacs/site-start.d/50haskell-mode.el
;;

(setq auto-mode-alist
      (append auto-mode-alist
              '(("\\.[hg]s$"  . haskell-mode)
                ("\\.hi$"     . haskell-mode)
                ("\\.l[hg]s$" . literate-haskell-mode))))

(setq interpreter-mode-alist
      (append interpreter-mode-alist
              '(("^#!.*runhugs" . haskell-mode))))

(autoload 'haskell-mode "haskell-mode"
  "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
  "Major mode for editing literate Haskell scripts." t)
(autoload 'turn-on-haskell-ghci "haskell-ghci"
  "Turn on interaction with a GHC interpreter." t)

(add-hook 'haskell-mode-hook 'turn-on-haskell-font-lock)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(if (not (string-match "Lucid\\|XEmacs" emacs-version))
    (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode))
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-hugs)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)
(debian-pkg-add-load-path-item "/usr/share/emacs/site-lisp/haskell-mode")
