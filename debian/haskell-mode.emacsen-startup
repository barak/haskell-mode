;;
;; /etc/emacs/site-start.d/50haskell-mode.el
;;

(let ((package-dir (concat "/usr/share/"
			   (symbol-name flavor)
			   "/site-lisp/haskell-mode")))
  (debian-pkg-add-load-path-item package-dir))

(load "haskell-mode-autoloads")
