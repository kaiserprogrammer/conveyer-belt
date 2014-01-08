(defpackage :belt
  (:use :cl)
  (:export :make-belt :drop :pick))
(in-package :belt)

(defun make-belt (size)
  (declare (type fixnum size))
  (cons (1- size) (make-array (list size))))

(defun drop (belt thing)
  (declare (optimize (speed 3) (safety 0)))
  (when (zerop (the fixnum (car belt)))
    (setf (car belt) (the fixnum (length (the simple-vector (cdr belt))))))
  (setf (svref (cdr belt) (setf (car belt) (the fixnum (1- (the fixnum (car belt)))))) thing))

(defun pick (belt off)
  (declare (optimize (speed 3) (safety 0)))
  (svref (cdr belt)
         (let ((noff (+ (the fixnum (car belt)) (the fixnum off))))
           (if (>= (the fixnum noff) (length (the simple-vector (cdr belt))))
               (- (length (the simple-vector (cdr belt))) noff)
               noff))))
