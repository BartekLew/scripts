
(defmacro answer (&body msg)
	`(with-open-file (out (second argv) :direction :output :if-exists :supersede)
	(let ((*standard-output* out))
	(format out "~A~%" ,@msg))))

(let ((argv (cdr sb-ext:*posix-argv*)))
(if (< (length argv) 2)
	(format t "2 parameters- pipes needed!")
	(loop
	(with-open-file (in (first argv) :direction :input)
	(let ((*standard-input* in))
	(loop (handler-case
		(let ((cmd (read in nil :eof)))
		(if (eql cmd :eof) (return)
			(answer (eval cmd))))
		(condition (c) (answer c)))))))))
