
(defun clamp (val min max)
  (cond
    ((< val min) min)
    ((> val max) max)
    (t val)))

(defun clampmin (val min)
  (if (< val min) min
      val))

(defun incmodf (counters i start base)
  (let ((newval (clampmin (mod (1+ (elt counters i)) (clampmin base 1)) start)))
    (setf (elt counters i) newval)
    (= newval start)))

(defun counter-inc (counters finvals &key initvals)
  (when (not initvals)
    (setf initvals (make-array (array-dimensions finvals))))
  (let ((n (length counters)))
    ;;(format t "n: ~a~%" n)
    (do ((i (- n 1)))
        ((< i 0) t)
      ;;(format t "i: ~a counters: ~a~%" i counters)
      (if (incmodf counters i (elt initvals i) (elt finvals i))
          (decf i)
          (return nil)))))

(defun doexp (vars fun)
  (let* (
         (n (length vars))
         (initvals (make-array n ::initial-contents (map 'list #'car vars)))
         (finvals (make-array n ::initial-contents (map 'list #'cadr vars)))
         (done nil)
         (dostep #'(lambda (x) (let ((res (counter-inc x finvals :initvals initvals)))
                                 (when res (setf done t)))
                     x)))
    (do ((counters (copy-seq initvals) (funcall dostep counters)))
        (done)
      (funcall fun counters))))

(defun doexpl (vars fun)
  (let* (
         (n (length vars))
         (initvals (make-array n ::initial-contents (map 'list #'car vars)))
         (finvals (make-array n ::initial-contents (map 'list #'cadr vars)))
         (done nil)
         (dostep #'(lambda (x) (let ((res (counter-inc x finvals :initvals initvals)))
                                 (when res (setf done t)))
                     x)))
    (do ((counters (copy-seq initvals) (funcall dostep counters)))
        (done)
      (funcall fun (coerce counters 'list)))))


(defmacro doloops (vardefs &body body)
  (let ((vars (mapcar #'car vardefs)))
    `(let* ((n (length ',vardefs))
            (initvals (make-array n ::initial-contents (mapcar #'cadr ',vardefs)))
            (finvals (make-array n ::initial-contents (mapcar #'caddr ',vardefs)))
            (done nil)
            (dostep #'(lambda (x) (let ((res (counter-inc x finvals :initvals initvals)))
                                    (when res (setf done t)))
                        x)))
       (do ((counters (copy-seq initvals) (funcall dostep counters)))
           (done)
         (destructuring-bind ,vars (coerce counters 'list)
           ,@body)))))

(defun dotestloops ()
  (doloops ((i 0 5) (j 0 5))
    (format t "i=~a j=~a~%" i j)))

(defun dotestexp ()
  (doexp '((0 5) (0 5))
         #'(lambda (x) (format t "x: ~a~%" x))))

(defun dotestexpl ()
  (doexpl '((0 5) (0 5))
         #'(lambda (x) (format t "x: ~a~%" x))))

(defun dotestexpl-stuck ()
  (doexpl '((0 5) (5 5) (0 0))
         #'(lambda (x) (format t "x: ~a~%" x))))

