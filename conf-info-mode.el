
(require 'conf-mode)

(defvar conf-info-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?{ "(" table)
    (modify-syntax-entry ?} ")" table)
    (modify-syntax-entry ?\\ "\\" table)    
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?\; "<" table)
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?\r ">" table)
    (modify-syntax-entry ?\" "\"" table)
    table)
  "Syntax table in `conf-info-mode' buffers.")

(defvar conf-info-font-lock-keywords
  `((
     ;; key blah
     ("^[ \t]*\\(\\sw+\\)"
      (1 font-lock-variable-name-face))
     ;; #include "blah"
     ("^#include" . font-lock-preprocessor-face)
     ))
  "Keywords to highlight in Conf[Info] mode.")

(defun conf-info-mode-indent-line ()
  "Indent current line of Sample code."
  (interactive)
  (let ((savep (> (current-column) (current-indentation)))
        (indent (condition-case nil (max (conf-info-mode-calculate-indentation) 0)
                  (error 0))))
    (if savep
        (save-excursion (indent-line-to indent))
      (indent-line-to indent))))

(defun conf-info-mode-calculate-indentation ()
  "Calculate the column to which the current line should be indented for `conf-info-mode'."
  (* tab-width (car (syntax-ppss))))

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

  :syntax-table conf-info-mode-syntax-table
  
  (conf-mode-initialize ";")
  ;; (make-local-variable 'conf-assignment-sign)
  ;; (setq conf-assignment-sign nil)
  (setq font-lock-defaults conf-info-font-lock-keywords)
  (setq indent-line-function 'conf-info-mode-indent-line)
  )

(provide 'conf-info-mode)
