(defpackage #:pochta
  (:use :cl :iterate :metatilities)
  (:shadowing-import-from :metatilities minimize finish))

(in-package :pochta)

(defstruct fsm-queue-item
  (row 0 :type fixnum)
  (col 0 :type fixnum)
  (state nil :type function))

(defun make-empty-fsm-queue ()
  (pileup:make-heap (lambda (a b)
                      (declare (optimize (speed 3) (safety 0)) (type fsm-queue-item a b))
                      (or (< (fsm-queue-item-row a) (fsm-queue-item-row b))
                          (and (= (fsm-queue-item-row a) (fsm-queue-item-row b)) (< (fsm-queue-item-col a) (fsm-queue-item-col b)))))))

(defun push-to-fsm-queue (state row col fsm-queue)
  (pileup:heap-insert (make-fsm-queue-item :row row :col col :state state) fsm-queue)
  fsm-queue)

(defun take-first-fsm-queue (fsm-queue row col)
  (iter (with item-row = row)
        (with item-col = col)
        (until (zerop (pileup:heap-count fsm-queue)))
        (for item = (pileup:heap-top fsm-queue))
        (cond ((and (= (fsm-queue-item-row item) item-row) (= (fsm-queue-item-col item) item-col))
               (collect (fsm-queue-item-state item) into states))
              ((or (> (fsm-queue-item-row item) item-row) (and (= (fsm-queue-item-row item) item-row) (> (fsm-queue-item-col item) item-col)))
               (iterate:finish)))
        (pileup:heap-pop fsm-queue)
        (finally (return (values states fsm-queue)))))

(defun make-fsm-queue (init-fsm)
  (lambda (char row col fsm-queue)
    (multiple-value-bind (states next-fsm-queue)
        (take-first-fsm-queue (push-to-fsm-queue (funcall init-fsm row col) row col fsm-queue) row col)
      (reduce (lambda (next-fsm-queue fsm)
                (funcall fsm
                         char
                         (lambda (next-state row col) (push-to-fsm-queue next-state row col next-fsm-queue))
                         (constantly next-fsm-queue)))
              states
              :initial-value next-fsm-queue))))

(defun process-stream (fsm stream)
  (iter (with row = 0)
        (with col = 0)
        (with fsm-queue = (make-empty-fsm-queue))
        (for octet in-stream stream using #'read-byte)
        (case octet
          (#.(char-code #\Newline) (incf row) (setf col 0))
          (t (setf fsm-queue (funcall fsm octet row col fsm-queue)) (incf col)))))

(defun process-file (fsm filename)
  (with-open-file (src filename :element-type '(unsigned-byte 8)) (process-stream fsm src)))

(defmacro deffsm (name &rest patterns)
  (let ((fsm (iter main-loop
                   (with max-height = (reduce #'max patterns :key (compose #'length #'second)))
                   (with max-width = (reduce #'max patterns :key (compose (curry #'reduce #'max) (curry #'mapcar #'length) #'second)))
                   (with state-index = 0)
                   (with current-states = (list (cons state-index patterns)))
                   (for row from 0 below max-height)
                   (iter (for col from 0 below max-width)
                         (iter states-loop
                               (for (current-state-index . state-patterns) in current-states)
                               (iter (with ht = (make-hash-table))
                                     (for (target pattern) in state-patterns)
                                     (if (and (< row (length pattern))
                                              (< col (length (elt pattern row))))
                                         (push (list target
                                                     (and (= (1+ row) (length pattern)) (= (1+ col) (length (elt pattern row))))
                                                     pattern)
                                               (gethash (elt (elt pattern row) col) ht))
                                         (push (list target nil pattern)
                                               (gethash :default ht)))
                                     (finally
                                      (let ((trans (iter (for (key transition) in-hashtable ht)
                                                         (for next-state-index = (incf state-index))
                                                         (for (values stops next-patterns) =
                                                              (iter (for (target stop-p pattern) in transition)
                                                                    (if stop-p
                                                                        (collect target into stops)
                                                                        (collect (list target pattern) into next-patterns))
                                                                    (finally (return (values stops next-patterns)))))
                                                         (when next-patterns
                                                           (in states-loop (collect (cons next-state-index next-patterns) into next-states)))
                                                         (collect (cons key (cons (when next-patterns next-state-index) stops))))))
                                        (in main-loop (collect (cons (list current-state-index row col) trans))))))
                               (setf current-states next-states))))))
    (labels ((state-label (state) (form-symbol 'state- state))
             (state-next-funcall (state)
               (let ((coords (cdar (find state fsm :key #'caar))))
                 `(funcall next (function ,(state-label state))
                           (the fixnum (+ init-row ,(first coords)))
                           (the fixnum (+ init-col ,(second coords)))))))
      `(defun ,name (init-row init-col)
         (declare (optimize (speed 3) (safety 0)) (type fixnum init-row init-col))
         (labels ,(iter (for ((state row col) . transitions) in fsm)
                        (collect `(,(state-label state) (char next reset)
                                    (declare (ignorable next)
                                             (type (unsigned-byte 8) char)
                                             (type function next reset))
                                    (cond ,@(iter (for (key next-state . stop-set) in (remove-if (curry #'eq :default) transitions :key #'car))
                                                  (collect `((= char ,(char-code key))
                                                             ,@(iter (for stop in stop-set)
                                                                     (collect `(format t ,(format nil ";; found [ ~a ] @ (~~a, ~~a)~~%" stop)
                                                                                       init-col init-row)))
                                                             ,(if next-state
                                                                  (state-next-funcall next-state)
                                                                  `(funcall reset)))))
                                          (t ,(let ((default (find :default transitions :key #'car)))
                                                   (if (and default (second default))
                                                       (state-next-funcall (second default))
                                                       `(funcall reset))))))))
           (function ,(state-label 0)))))))

(deffsm mail-digits
  (0 ((#\1 #\1 #\1) (#\1 #\0 #\1) (#\1 #\0 #\1) (#\1 #\0 #\1) (#\1 #\1 #\1)))
  (1 ((#\1 #\1 #\0) (#\0 #\1 #\0) (#\0 #\1 #\0) (#\0 #\1 #\0) (#\1 #\1 #\1)))
  (2 ((#\1 #\1 #\1) (#\0 #\0 #\1) (#\1 #\1 #\1) (#\1 #\0 #\0) (#\1 #\1 #\1)))
  (3 ((#\1 #\1 #\1) (#\0 #\0 #\1) (#\1 #\1 #\1) (#\0 #\0 #\1) (#\1 #\1 #\1)))
  (4 ((#\1 #\0 #\1) (#\1 #\0 #\1) (#\1 #\1 #\1) (#\0 #\0 #\1) (#\0 #\0 #\1)))
  (5 ((#\1 #\1 #\1) (#\1 #\0 #\0) (#\1 #\1 #\1) (#\0 #\0 #\1) (#\1 #\1 #\1)))
  (6 ((#\1 #\1 #\1) (#\1 #\0 #\0) (#\1 #\1 #\1) (#\1 #\0 #\1) (#\1 #\1 #\1)))
  (7 ((#\1 #\1 #\1) (#\0 #\0 #\1) (#\0 #\1 #\1) (#\0 #\1 #\0) (#\0 #\1 #\0)))
  (8 ((#\1 #\1 #\1) (#\1 #\0 #\1) (#\1 #\1 #\1) (#\1 #\0 #\1) (#\1 #\1 #\1)))
  (9 ((#\1 #\1 #\1) (#\1 #\0 #\1) (#\1 #\1 #\1) (#\0 #\0 #\1) (#\1 #\1 #\1))))
    
(defun entrypoint ()
  (process-stream (make-fsm-queue #'mail-digits) *standard-input*))

