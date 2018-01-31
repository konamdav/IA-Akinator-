; Fonctions de service

(defun separate (&optional (caractere '_) (before 0) (after 1))
	(format t "~%" )	
	(dotimes (i before)
		(format t "~%")
	)
	(dotimes (i 80)
		(format t "~S" caractere)
	)
	(if (equal caractere '_)
		(format t "~%")
	)
	(dotimes (i after)
		(format t "~%")
	)
	(format t "~%" )	
)


(defun generate-id-unique (name)
	(gentemp name)
)