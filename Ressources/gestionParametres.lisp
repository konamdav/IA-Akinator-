; initialisation
(setq *PARAMETERS* NIL)
(setq *SOFT_FOUND* NIL)
(setq *SOFT_BLACKLIST* NIL)

;fonction qui ajoute un parametre en indiquant les propriétés du parametre
(defun add-parameter (name-parameter type-parameter ask-parameter auto-complete-parameter values-parameter question-parameter)
	(pushnew (cons name-parameter (list 
		(list 'TYPE type-parameter) 
		(list 'ASK ask-parameter)
		(list 'AUTO-COMPLETE auto-complete-parameter)
		(list 'VALUES values-parameter)
		(list 'QUESTION question-parameter)
		)) *PARAMETERS*)
)

;ajoute une valeur dans un parameter déja créer
(defun add-value-to-parameter (name-parameter new-value)
	(pushnew new-value (cadr (assoc 'VALUES (cdr (assoc name-parameter *PARAMETERS*)))))
)

;verifie que la valeur est déja dans le domaine de définition du parameter
(defun is-value-to-parameter (name-parameter value-parameter)
	(if (assoc name-parameter *PARAMETERS*)	
		(member value-parameter (get-parameter-attribut (assoc name-parameter *PARAMETERS*)  'VALUES))
		t
	)
)


;mélange des parameters (pour que la première question ne soit pas la même)
(defun init_parameters ()
	(let 
		(
			(result NIL)
			(liste NIL)
		)
		
		(dolist (p *PARAMETERS*)
			
			(when (eq  (get-parameter-attribut p 'ASK) 'OUI)
				(push p liste)
			)
		)
		
		(load (concatenate 'string *chemin* "Donnees/parametres.lisp"));
		
;		(setq liste '(*SUITE_LOGICIELLE* *FONCTION*))
;		(setq liste '(*PLATEFORME* *SUITE_LOGICIELLE* *SUPPORT* *FONCTION* *EDITEUR*))
		;(setq liste '(*LICENCE* *DROITS* *SUPPORT* *SUITE_LOGICIELLE*  *EDITEUR* *FONCTION* *PLATEFORME* *TYPE* *UTILISATEUR*))
		
		(do ()
			((null liste) result)
		  	(let* 
				((which (random (length liste)))
				(it (nth which liste)))
				(push it result)
				(setq liste (remove it liste :count 1))
			)
		)
		
		(setq *PARAMETERS_SEARCH* result)
	)
)

;partie intéractive : 
;déroulement des questions
(defun ask-user()
	
	(let*
		(
			(tmp (find-question))
			(name-parameter (car tmp))
			(name-variable (cadr tmp))
			(indParameter 0)
			(indVariable 0)
			(input NIL)
			(question NIL)
			(choix NIL)
			
		)
		
			(when (null name-parameter)
				(setq indParameter (random (length *PARAMETERS_SEARCH*)))
				(setq name-parameter (car (nth indParameter *PARAMETERS_SEARCH*)))
			)
			
			
			(when (null name-variable) 
				
				(setq indVariable (random (length  (get-parameter-attribut (assoc name-parameter *PARAMETERS_SEARCH*)  'VALUES))))
				(setq name-variable (nth indVariable (get-parameter-attribut (assoc name-parameter *PARAMETERS_SEARCH*)  'VALUES )))
			)
			
			(setq question (get-parameter-attribut (assoc name-parameter *PARAMETERS_SEARCH*)  'QUESTION))
			(separate '*)
			(format t "~%QUESTION ~S :~%" name-parameter)
			(format t question name-variable)
			(format t "1 - Oui~%" )
			(format t "2 - Non~%" )
			(format t "3 - Je ne sais pas~%" )	
			
			(loop
				(format t "Entre ton choix: ")
				(setq input (read))
				(if (and (> input 0) (<= input 4))
					(return-from nil T)
					(format t "Erreur: Choix impossible~%")
				)
			)


		; Fonction pour le debug : 4 pour quitter le programme			
		(if (= input 4)
			(return-from ask-user t))

		

		;MISE A JOUR DE LA BASE DE FAITS
		(update-BF (create-container (list name-variable '= (convert-answer-to-value input))))
		(format t "~%" )
		
		;ACTIVATION DEMON ELIMINATE-DATE SI ANNEE = NON
		(if (and (eq name-parameter 'ANNEE) (> input 1))
			(eliminate-date name-variable)
		)
	)
	nil
)


;reste-il des parameters à questionner ?.
(defun is-parameters-not-asked ()
	(> (length *PARAMETERS_SEARCH*) 0)
)

;supprimer une valeur du parameter (ou le parameter en entier si il est vide)
(defun delete-parameter-value (parameter variable value)
	(when parameter
			(let 
				(
					(values (list 'VALUES  (get-parameter-attribut  parameter 'VALUES)))
				)
				
					(setq *PARAMETERS_SEARCH* (remove parameter *PARAMETERS_SEARCH* ::test #'equal))
					(setq parameter (remove  values parameter :test #'equal))
					(setf (cadr values) (remove variable (cadr values)))
					(setq parameter (append parameter (list values)))
					(pushnew parameter *PARAMETERS_SEARCH*)
					
					(cond
						((null (get-parameter-attribut  (assoc (car parameter) *PARAMETERS_SEARCH*) 'VALUES))
							(setq *PARAMETERS_SEARCH* (remove parameter *PARAMETERS_SEARCH* :test #'equal))

						)
						((and (eq value 'OUI)(eq (get-parameter-attribut  parameter 'TYPE) 'UNIQUE))
							(setq *PARAMETERS_SEARCH* (remove parameter *PARAMETERS_SEARCH* :test #'equal))

						)
						
					)
							
			)
		
		)
)

;obtenir une propriété du parameter
(defun get-parameter-attribut (parameter name-attribut)
	(let 
		((tmp (assoc name-attribut (cdr parameter))))
		(if tmp
			(cadr tmp)
			NIL
		)
	)
)

;demande la confirmation du logiciel trouvé
(defun software-found ()
	(let ((input NIL))
	
		(format t "Je crois avoir trouve le logiciel...~%")
		(format t "C'est ~S ?~%" *SOFT_FOUND*)
		(format t "1 - Oui~%" )
		(format t "2 - Non~%" )
			
		(loop
			(format t "Entrez votre choix: ")
			(setq input (read))
			(if (and (> input 0) (<= input 2))
				(return-from nil T)
				(format t "Erreur: Choix impossible~%")
			)
		)
		
		(if (= input 1)
			(return-from software-found t)
			(set-not-found)
		)
	
	)

)
;logiciel trouvé ?
(defun is-answer-found()
	*SOFT_FOUND*
)

;indiquer qu'un logiciel est trouvé
(defun set-found(soft)
	(setq *SOFT_FOUND* soft)
)

;le logiciel trouvé n'est pas le bon
(defun set-not-found()
	(push *SOFT_FOUND* *SOFT_BLACKLIST*)
	(setq *SOFT_FOUND* NIL)
)

;initialisation de la liste noire des logiciels
(defun reset-not-found ()
	
	(setq *SOFT_BLACKLIST* NIL)
)

;auto-complétion des questions (heuristique)
;score des regles et selection de la meilleur regle quasi candidate
(defun find-question ()
	(let ((rule NIL)(check 0)(parameter NIL)(score 0)(nbPrems 0)(max-score -1)(regles (select-rules *BR* *BR_blacklist*)) (flag t)(conclusions NIL)(prems nil)(P nil)(regles_candidates nil))
		(dolist (R regles (reverse regles_candidates)) 		;Pour chaque règle
			
			(setq flag t)
			(setq prems (premisses R))
			(setq conclusions (conclusion R))
			(setq nbPrems (length prems))
			(setq score 0)
			
			(dolist (p conclusions)				
				(if (and flag (prem-different-exists-in-BF p))
					(setq flag NIL)
				)
			)
						
			(when flag
				(setq check NIL)
				(dolist (p prems)				; Parcourt de toutes les prémisses : si flag reste vrai alors la Règle est candidate
					(cond 
						((get-parent-name (car p)) ; premice est une variable et on récupere le paramètre
							(setq parameter (get-parent-name (car p)))
						)
						(T 
							(setq parameter (car p))
						)
					)
					
					(if (prem-exists-in-BF p)
						(setq score (+ score 1))
						(if (and flag (prem-different-exists-in-BF p)) ; un fait contraire à une premice se trouve dans BF -> regle inutile
							(setq flag NIL)
						)
					)
				
					(if (and (not(prem-exists-in-BF p)) (eq 'OUI (get-parameter-attribut (assoc parameter *PARAMETERS*)  'ASK)))
						(setq check T)
						;(if (and (not(prem-exists-in-BF p)) (eq 'NON (get-parameter-attribut (assoc parameter *PARAMETERS*)  'ASK)))
						;	(setq flag NIL)
						;)
					)
				)
				(setq score (/ score nbPrems))
				
				(when flag
					(setq flag  check)
				)
				
				
				(if (not flag)
					(setq score 0)
				)
				;(format t "rule ~S ~%" R)
				;(format t "score ~S ~%" score)
				
				
				(when (and flag (> score 0)(< score 1)(> score max-score))
					(setq max-score score)
					(setq rule R)
					
				)
			)
		)
		
		(search-question-by-rule rule)
	)
)

;determination du prochain parameter a questionner et sa variable
(defun search-question-by-rule (R)
	
	(cond 
		((not (null R))
			(let 
				((tmp NIL)(parameter NIL)(variable NIL)(prems (premisses R)))
				(dolist (p prems)	; Parcourt de toutes les prémisses : si flag reste vrai alors la Règle est candidate
					(when (null tmp)
						(cond 
							((get-parent-name (car p)) ; premice est une variable et on récupere le paramètre
								(setq variable (car p))
								(setq parameter (get-parent-name (car p)))
								
							)
							(T 
								(setq variable (caddr p))
								(setq parameter (car p))
								
							)
						)
					)
					
					(setq score 0)
					(when (and (eq 'OUI (get-parameter-attribut (assoc parameter *PARAMETERS*)  'ASK)) (not (prem-exists-in-BF p))(not (prem-different-exists-in-BF p)))
						(setq tmp  p)		
					)
					(when (eq 'NON (get-parameter-attribut (assoc parameter *PARAMETERS*)  'AUTO-COMPLETE))
						(setq variable NIL)
					)
				)
					
				(list parameter variable)
			)
		)
		(T
			 (list NIL NIL)
		)
	)

)

;elimine les annee qui sont au dessus d'une date dont la réponse était non
(defun eliminate-date (date)
	(let
		((dates (get-parameter-attribut (assoc 'ANNEE *PARAMETERS_SEARCH*)  'VALUES)))
		(dolist (d dates)
			(if (<= d date)
				(update-BF (create-container (list d '= 'NON)))
			)
		)
	)
)