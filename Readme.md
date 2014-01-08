# Conveyer Belt

A forgetful data structure

```lisp
(let ((belt (make-belt 2)))
  (drop belt 10)
  (assert-equal 10 (pick belt 0))
  (drop belt 20)
  (assert-equal 10 (pick belt 1))
  (drop belt 30)
  (assert-equal 20 (pick belt 1))
  (assert-equal 30 (pick belt 0)))
```
