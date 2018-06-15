(require 'subr-x)
(defun phpdoc-function ()
  "print the phpdoc for function"
  (interactive)
  ;; expected the cursor on method name
  ;; find keyword "function"
  (end-of-line)
  (search-backward " function")

  ;; get method name ;;;;;;;;;;;;;;;;;;;;;;;;
  (right-word)
  (search-forward " ")
  ;; cursor position: " function |func(...)"
  ;; set function name start point
  (setq method-name-start (point))
  ;; move cursor to word end
  ;; " function func|(...)"
  (right-word)
  (setq method-name-end (point))
  (setq method-name (string-trim (buffer-substring-no-properties method-name-start method-name-end)))

  ;; get params ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (search-forward "(")
  (setq params-start (point))
  (search-forward ")")
  (left-char)
  (setq params-end (point))
  (setq params (buffer-substring-no-properties params-start params-end))

  (replace-regexp-in-string "$+" "" params)
  (setq params (split-string (replace-regexp-in-string ")" "" params) ","))

  ;; move cursor position to head of method
  (search-backward " function")

  (phpdoc-block-position)
  (setq inicio (point))
  (setq init-block-point (point))
  (phpdoc-insert-doc-start)     ; insert /**
  ;; (phpdoc-insert-new-line method-name) ; insert  * method-name
  ;; (phpdoc-insert-new-line)             ; insert  *
  (phpdoc-insert-params params) ; insert  * @param param
  (phpdoc-insert-new-line "@return ")  ; insert  * @return
  (phpdoc-insert-doc-end)       ; insert  */
  (indent-region inicio (point))
  (goto-char init-block-point)
  (message "Insert ther phpdoc for methood")
)


(defun php-create-setter ()
  "create-the-setter-for-a-variable"
  (interactive)
  (search-backward "$")
  ;; (setq method-name (phpdoc-get-method-description))
  ;; (setq params (phpdoc-get-params))
  ;; (phpdoc-block-position)
  (setq inicio (point))
  (setq init-block-point (point))
  (phpdoc-insert-doc-start)
  (phpdoc-insert-new-line method-name)
  (phpdoc-insert-new-line)
  (phpdoc-insert-params params)
  (phpdoc-insert-doc-end)
  (indent-region inicio (point))
  (goto-char init-block-point)
  (message "PHPDocumentor block created")
)


(defun phpdoc-block-position ()
  (previous-line)
  (beginning-of-line)
  (newline)
)

(defun phpdoc-insert-new-line (&optional phpdoc-str)
  (insert (concat "* " phpdoc-str))
  (newline)
)

(defun phpdoc-insert-doc-end ()
  (insert "*/")
)

(defun phpdoc-insert-doc-start ()
  (insert "/**")
  (newline)
)

(defun phpdoc-get-method-description ()
)

(defun phpdoc-get-variable-name ()
  (search-forward " ")
  (setq init-word (point))
  (right-word)
  (buffer-substring-no-properties init-word (point))
)


(defun phpdoc-insert-params (param-list)
  (if (> (length param-list) 0)
  (while param-list
    (phpdoc-insert-new-line (concat "@param " (string-trim (car param-list))))
    (setq param-list (cdr param-list))
   )
  )
)

(defun phpdoc-get-params ()
  (search-forward "(")
  (setq init-word (point))
  (search-forward ")")
  (setq params (buffer-substring-no-properties init-word (point)))
  (replace-regexp-in-string ")" "" (replace-regexp-in-string "$+" "" params))
  (setq param-list (split-string (replace-regexp-in-string ")" "" params) ","))
)
