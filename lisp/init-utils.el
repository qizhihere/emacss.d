;; some common used functions

(defun lqz/iter-eval (target cmd)
  "apply cmd to target or every element in list target."
  (if (listp target)
    (dolist (x target) (eval cmd))
    (let ((x target)) (eval cmd))))

(defun if-gui (cmd &optional cmd1)
  "execute cmd if in gui, otherwise execute cmd1."
  (if (display-graphic-p)
      (eval cmd)
    ( eval cmd1)))

(defun is-theme (theme)
  "check if current theme is the theme."
  (and (stringp theme)
       (boundp 'lqz/theme)
       (string= theme lqz/theme)))

(defun lqz/mkrdir (dir)
  "create subdirectories relative to ~/.emacs.d"
  (lqz/iter-eval dir
    '(if (not (file-exists-p x))
    (make-directory (lqz/init-dir x) t))))

(defun lqz/select-file (msg &optional dir)
  (let ((file (file-relative-name
	       (read-file-name msg
		  (if (and dir (file-exists-p dir))
		      dir
		   (if (and (boundp 'lqz/last-dir) (file-exists-p lqz/last-dir))
		     lqz/last-dir
		   default-directory))))))
    (setq lqz/last-dir (file-name-directory (file-truename file)))
    file))

(defun lqz/delete-file (file)
  (and (file-exists-p file) (delete-file file)))

(defun lqz/delete-directory (dir)
  (and (file-exists-p dir) (delete-directory dir t)))

(defun lqz/load-file (path)
  "load file according to its relative path to init.el"
  (load-file (lqz/init-dir path)))

(defun lqz/send-keys (keys)
  (execute-kbd-macro (read-kbd-macro keys)))

(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (if (file-exists-p filePath)
      (with-temp-buffer
	(insert-file-contents filePath)
	(buffer-string))
    ""))

(defun add-more-to-list (target source)
  "append source list to target list."
  (dolist (x source) (add-to-list target x)))

(defun lqz/require (package)
  (lqz/iter-eval package
    '(let ((x (if (stringp x) (intern x) x)))
    (if (not (package-installed-p x))
	(package-install x))
    (require x))))



(provide 'init-utils)
