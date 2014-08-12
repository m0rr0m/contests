(let ((quicklisp-init #p".quicklisp/setup.lisp"))
  (unless (probe-file quicklisp-init)
    (load #p"./quicklisp.lisp")
    (funcall (symbol-function (find-symbol "INSTALL" (find-package "QUICKLISP-QUICKSTART"))) :path #p".quicklisp/"))
  (load quicklisp-init))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :iterate)
  (ql:quickload :metatilities)
  (ql:quickload :pileup)
  (load #p"./pochta.lisp")
  (sb-ext:save-lisp-and-die "pochta"
                            :toplevel (symbol-function (find-symbol "ENTRYPOINT" (find-package "POCHTA")))
                            :executable t))
                            
                            
  




