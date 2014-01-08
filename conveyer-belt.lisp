(defpackage :belt
  (:use :cl)
  (:export :make-belt :drop :pick))
(in-package :belt)


(defun make-belt (size)
  "create a belt which can only hold the recent last size elements"
  (declare (type fixnum size))
  (cons (1- size) (make-array (list size))))

(defun drop (belt thing)
  "drop thing on the front of the belt"
  (declare (optimize (speed 3) (safety 0)))
  (when (zerop (the fixnum (car belt)))
    (setf (car belt) (the fixnum (length (the simple-vector (cdr belt))))))
  (setf (svref (cdr belt) (setf (car belt) (the fixnum (1- (the fixnum (car belt)))))) thing))

(defun pick (belt offset)
  "pick the last recent element from the element"
  (declare (optimize (speed 3) (safety 0))
           (type fixnum offset))
  (svref (cdr belt)
         (let ((noff (+ (the fixnum (car belt)) offset)))
           (if (>= (the fixnum noff) (length (the simple-vector (cdr belt))))
               (- (length (the simple-vector (cdr belt))) noff)
               noff))))
