(declaim (optimize (speed 3) (debug 0) (safety 0) (compilation-speed 0)))
(defpackage :belt
  (:use :cl :lisp-unit2))
(in-package :belt)

(defun make-belt (size)
  (cons 0 (make-array (list size))))

(defun drop (belt thing)
  (incf (the fixnum (car belt)))
  (when (= (the fixnum (car belt)) (the fixnum (length (the simple-vector (cdr belt)))))
    (setf (car belt) 0))
  (setf (svref (cdr belt) (car belt)) thing))

(defun pick (belt off)
  (let ((noff (- (the fixnum (car belt)) (the fixnum off))))
    (svref (cdr belt) (if (< (the fixnum noff) 0)
                          (+ (length (the simple-vector (cdr belt))) noff)
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
  (with-belt (2)
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
