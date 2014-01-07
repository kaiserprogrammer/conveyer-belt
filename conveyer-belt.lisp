(declaim (optimize (speed 3) (debug 0) (safety 0) (compilation-speed 0)))
(defpackage :belt
  (:use :cl :lisp-unit2))
(in-package :belt)

(defun make-belt (size)
  (cons (1- size) (make-array (list size))))

(defun drop (belt thing)
  (when (zerop (the fixnum (car belt)))
    (setf (car belt) (the fixnum (length (the simple-vector (cdr belt))))))
  (setf (svref (cdr belt) (decf (the fixnum (car belt)))) thing))

(defun pick (belt off)
  (svref (cdr belt)
         (let ((noff (+ (the fixnum (car belt)) (the fixnum off))))
           (if (>= (the fixnum noff) (length (the simple-vector (cdr belt))))
               (- (length (the simple-vector (cdr belt))) noff)
               noff))))

(remove-tests)

(defmacro with-belt ((size) &body body)
  `(let ((belt (make-belt ,size)))
     ,@body))

(define-test drop-and-retrieve-from-belt ()
  (with-belt (1)
    (drop belt 5)
    (assert-equal 5 (pick belt 0))))

(define-test multiple-drops ()
  (with-belt (5)
    (drop belt 1)
    (drop belt 10)
    (assert-equal 1 (pick belt 1))
    (assert-equal 10 (pick belt 0))))

(define-test too-many-drops ()
  (with-belt (2)
    (drop belt 10)
    (drop belt 20)
    (drop belt 30)
    (assert-equal 20 (pick belt 1))
    (assert-equal 30 (pick belt 0))))

(define-test reload-on-fallen-use ())

(with-test-results ()
  (run-tests))
