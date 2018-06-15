(require 'subr-x)
(defun phpdoc-method ()
  "print the phpdoc for method"
  (interactive)
  ;; expected the cursor on method name
  ;; find keyword "function"
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
  (setq params-end (point))
  (setq params (buffer-substring-no-properties params-start params-end))
  (replace-regexp-in-string ")" "" (replace-regexp-in-string "$+" "" params))
  (setq params (split-string (replace-regexp-in-string ")" "" params) ","))

  ;; move cursor position to head of method
  (search-backward " function")

  (phpdoc-block-position)
  (setq inicio (point))
  (setq init-block-point (point))
  (phpdoc-insert-doc-start)     ; insert /**
  (phpdoc-new-line method-name) ; insert  * method-name
  (phpdoc-new-line)             ; insert  *
  (phpdoc-insert-params params) ; insert  * @param param
  (phpdoc-insert-doc-end)       ; insert  */
  (indent-region inicio (point))
  (goto-char init-block-point)
  (message "Insert ther phpdoc for methood")
)


(defun php-create-setter ()
  "create-the-setter-for-a-variable"
  (interactive)
  (search-backward "$")
  (setq method-name (phpdoc-get-method-description))
  (setq params (phpdoc-get-params))
  (phpdoc-block-position)
  (setq inicio (point))
  (setq init-block-point (point))
  (phpdoc-insert-doc-start)
  (phpdoc-new-line method-name)
  (phpdoc-new-line)
  (phpdoc-insert-params params)
  (phpdoc-insert-doc-end)
  (indent-region inicio (point))
  (goto-char init-block-point)
  (message "PHPDocumentor block created")
)


(defun phpdoc-block-position ()
  (previous-line)(beginning-of-line)(newline)
)

(defun phpdoc-new-line (&optional phpdoc-str)
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
    (phpdoc-new-line (concat "@param " (string-trim (car param-list))))
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

(fset 'php-create-setter
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([134217848 115 97 backspace 101 97 114 tab 98 97 tab return 36 return right 67108896 C-right 134217847 134217790 134217848 115 101 97 114 tab 98 97 tab return 125 return return up return tab 112 117 98 99 108 105 backspace backspace backspace 108 105 99 32 102 117 110 99 105 backspace backspace 99 116 105 111 110 32 115 101 116 25 C-left 21 51 right 67108896 right 134217848 99 97 112 105 116 97 108 105 tab 45 114 101 103 tab return 5 40 36 25 41 32 123 return tab 36 116 104 105 115 45 62 25 32 61 32 36 25 59 return 125 return] 0 "%d")) arg)))
