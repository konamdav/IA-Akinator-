; Fonctions relative aux faits

(defun initBF()
	(setq *BF* nil)
)

;pré remplie la BF (mode SE simple)
(defun initBF_for_explore_se()
	
	(setq *BF* nil)
	;tout les parametres qui permettent de déduire WORD
	(create-parameter-in-bf 'DROITS)
	(add-variables-in-bf 'DROITS 'GRATUIT 'NON '=)
	(add-variables-in-bf 'DROITS 'PROTEGE_DROIT_AUTEUR 'OUI '=)
	(add-variables-in-bf 'DROITS 'REVENTE_AUTORISE 'NON '=)
	
	(create-parameter-in-bf 'FONCTION)
	(add-variables-in-bf 'FONCTION 'TRAITEMENT_TEXTE 'OUI '=)
	
	(create-parameter-in-bf 'COMMUNAUTE_DEVELOPPEURS)
	(add-variables-in-bf 'COMMUNAUTE_DEVELOPPEURS 'ACTIVE 'NON '=)
	(add-variables-in-bf 'COMMUNAUTE_DEVELOPPEURS 'INACTIVE 'NON '=)

	(create-parameter-in-bf 'COMMUNAUTE_UTILISATEUR)
	(add-variables-in-bf 'COMMUNAUTE_UTILISATEUR 'IMPORTANTE 'OUI '=)

	(create-parameter-in-bf 'PRISE_EN_MAIN)
	(add-variables-in-bf 'PRISE_EN_MAIN 'FACILE 'OUI '=)
	
	(create-parameter-in-bf 'DOCUMENTATION)
	(add-variables-in-bf 'DOCUMENTATION 'EXHAUSTIVE 'OUI '=)

	(create-parameter-in-bf 'THEME)
	(add-variables-in-bf 'THEME 'BUREAUTIQUE 'OUI '=)
	
	(create-parameter-in-bf 'TYPE)
	(add-variables-in-bf 'TYPE 'APPLICATION 'OUI '=)

	(create-parameter-in-bf 'ANNEE)
	(add-variables-in-bf 'ANNEE '1989 'OUI '=)
		
	(create-parameter-in-bf 'EDITEUR)
	(add-variables-in-bf 'EDITEUR 'MICROSOFT 'OUI '=)
	
)

(defun update-BF (container)

	(let ((name_parameter (get-np container)) (name_variable (get-nv container)) (operator (get-o container)) (answer (get-v container)) (parameter_line nil) (variables nil) (container_temp nil) (flag nil))
		;suppression des parameters
		
		(delete-parameter-value (assoc name_parameter *PARAMETERS_SEARCH*) name_variable answer)
		
		(cond 
			((not (setq parameter_line (is-name-parameter-in-BF name_parameter)))		; Le paramètre n'existe pas : on le créé et on ajoute la valeur à la BF
				(create-parameter-in-bf name_parameter)
				(add-variables-in-bf name_parameter name_variable answer operator)
			)
			((not (setq flag (is-name-variable-in-BF parameter_line name_variable))) 			; Attribut n'existe pas déjà mais le paramètre si : on le créé avec la valeur
				(add-variables-in-bf name_parameter name_variable answer operator)
			)
		)

		; Si type est UNIQUE et VARIABLE = OUI et la variable créé au dessus a bien été créé à l'instant (et non pas à une autre question), alors on met toutes les autres variables à non
		(when (and (not flag) (not (is-type-LISTE name_parameter)) (convert-to-bool answer) (not (equal name_parameter 'NOM)))		
			(setq parameter_line (is-name-parameter-in-BF name_parameter))
			(setq variables (remove name_variable (get-parameter-attribut  (assoc name_parameter *PARAMETERS*) 'VALUES)))
			(dolist (var variables)
				(when (not (is-name-variable-in-BF parameter_line var))
					(setq container_temp (create-container (list var '= 'NON)))
					(add-variables-in-bf (get-np container_temp) (get-nv container_temp) (get-v container_temp) (get-o container_temp))
				)
			)
		)
	)
)

(defun get-np (c)
	(car c)
)
(defun get-nv (c)
	(cadr c)
)
(defun get-o (c)
	(caddr c)
)
(defun get-v (c)
	(cadddr c)
)

(defun convert-answer-to-value (answer)
	(cond 
		((equal answer 1) 'OUI)
		((equal answer 2) 'NON)
		((equal answer 3) '?)
	)
)

(defun is-name-parameter-in-BF(name_parameter)
	(let ((bf *BF*)(line nil))
		(loop
			(cond 
				((not (setq line (pop bf))) (return-from is-name-parameter-in-BF nil))
				((and (eq 'NOM name_parameter)(not (member (caaadr line) *SOFT_BLACKLIST*))(equal (car line) name_parameter)) (return-from is-name-parameter-in-BF line))
				((and (not (eq 'NOM name_parameter))(equal (car line) name_parameter)) (return-from is-name-parameter-in-BF line))
			)
		)
	)
)

(defun get-name-software ()
	(car (is-name-parameter-in-BF 'NOM))
)

(defun is-name-variable-in-BF(parameter_line name_variable)
	(let ((vars (cadr parameter_line))(line nil)(lines nil))
		(loop
			(cond 
				((not (setq line (pop vars)))(return-from nil))
				((equal (car line) name_variable) (return-from is-name-variable-in-BF line))
				((and (listp name_variable) (member (car line) name_variable)) (push line lines))
			)
		)
		lines
	)
)

(defun get-name-parameter (_*P*)
	(car _*P*)
)

(defun remove-attribut (attribut)
	(if (not (assoc attribut *BF*))
		(return-from remove-attribut nil))

	(remove (assoc attribut *BF*) *BF* :test #'equal)
)