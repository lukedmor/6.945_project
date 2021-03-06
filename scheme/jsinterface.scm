(load "scheme/fixes.scm")

(define (contract steps)
  (let ((last (list-ref steps (- (length steps) 1))))
    (let lp ((i (- (length steps) 2)))
      (if (< i 0)
        (list last)
        (if (equal? last (list-ref steps i))
            (lp (- i 1))
            (list-head steps (+ i 2)))))))

(define (output-parser steps)
  (let lp ((i 0) (s (contract steps)))
    (if (null? s)
        'done
        (let ((step (car s)))
          (let ilp ((v 0))
            (if (> v 3)
                (lp (+ i 1) (cdr s))
                (begin
                  (for-each
                    (lambda (atom)
                      (scheme-to-js (list->js-array atom) v i))
                    (vector-ref step v))
                  (ilp (+ v 1)))))))))

(load "scheme/dist.scm")
(define (input-parser)
  (let* ((inp (js-to-scheme))
         (graph (car inp))
         (num-rounds (cadr inp))
         (start-node (caddr inp)))
    (make-alg-args (list->vector (map list->vector graph))
                   num-rounds
                   start-node)))

;(load "scheme/algs/bellman_ford.scm")
;(load "scheme/algs/leader_elect.scm")
;(output-parser (runtime (input-parser)))

