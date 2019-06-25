
(defmacro answer (&body msg)
	;; open output stream
	`(with-open-file (out (second argv) :direction :output :if-exists :supersede)

		;; redirect standard output there (in case `msg` prints)
		(let ((*standard-output* out))

			;; print result
			(format out "~A~%" ,@msg))))

(let ((argv (cdr sb-ext:*posix-argv*)))
(if (< (length argv) 2)
	(format t "2 parameters- pipes needed!")

	(loop	;; If second side close stream, our get closed to
		;; we want to reopen whenever it happens

	(with-open-file (in (first argv) :direction :input)
	(let ((*standard-input* in))			;; redirect all input to our stream

	(loop (handler-case				;; handling errors
		(let ((cmd (read in nil :eof)) )	;; read one expression from in
		(if (eql cmd :eof) (return)		;; if eof, reopen input
			(answer (eval cmd))))		;; else evaluate and print result
		(condition (c) (answer c)))))))))	;; print if error happened
