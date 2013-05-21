(require 'conf-mode)

(defvar conf-info-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?{ "(" table)
    (modify-syntax-entry ?} ")" table)
    (modify-syntax-entry ?\\ "\\" table)    
    (modify-syntax-entry ?_ "_" table)    
    (modify-syntax-entry ?\; "<" table)
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?\r ">" table)
    (modify-syntax-entry ?\" "\"" table)
    table)
  "Syntax table in `conf-info-mode' buffers.")

(defvar conf-info-font-lock-keywords
  "Keywords to highlight in Conf[Info] mode."
  `(("^#include[ \t]+" . font-lock-preprocessor-face)
    ("^[ \t]*\\([A-Za-z_0-9]+?\\)\\($\\|[ \t]+\\)" 1 font-lock-variable-name-face)
    ))

(defun conf-info-mode-indent-line ()
  "Extremely simple-minded indentation for conf-info-mode."
  (indent-to (* tab-width (car (syntax-ppss))))
  )

;;;###autoload
(define-derived-mode conf-info-mode conf-mode "Conf[Info]"
  "Conf Mode starter for Info style config files.
See http://www.boost.org/doc/libs/1_53_0/doc/html/boost_propertytree/parsers.html#boost_propertytree.parsers.info_parser
Example:

; Comment
Key 0
KeyWithChildren {
    Child1 \"String\"
    Child2 {
        \"StringKey\" \"Escaped \\\"Value\\\"
    }
}
#include \"file.info\""
  (kill-all-local-variables)
  (use-local-map conf-mode-map)
  (conf-mode-initialize ";")
  (set-syntax-table conf-info-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults)
       `(conf-info-font-lock-keywords))
  (set (make-local-variable 'indent-line-function) 'conf-info-mode-indent-line)
)

(provide 'conf-info-mode)
