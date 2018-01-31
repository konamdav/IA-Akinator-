
(defun explore()
	(let* ((regles_candidates_depart (regles-candidates)) (regles_candidates regles_candidates_depart) (R nil))														
		(loop										
			(cond
				((is-name-parameter-in-BF 'NOM) 
					(set-found (caaadr (is-name-parameter-in-BF 'NOM)))
					(return-from explore nil)
				)
				((not (setq R (pop regles_candidates))) 
					(if (is-parameters-not-asked)
						(if (ask-user) 
							(return-from explore t)
							(setq regles_candidates (append regles_candidates (nouvelles-regles-candidates regles_candidates)));ajout des regles trouvés via les questions users
						)
						(return-from explore nil)
					)
				)										
				(T
					(declenchement R)																						
					(push R *BR_blacklist*)
					(remove R regles_candidates)
					(setq regles_candidates (append regles_candidates (nouvelles-regles-candidates regles_candidates)))
				)
			)
		)
	)
	nil
)

(defun explore_arr()
	(let* ((regles_candidates_depart (regles-candidates_arr)) (regles_candidates regles_candidates_depart) (R nil))														
		(loop										
			(cond
				((not (setq R (pop regles_candidates))) (return-from explore_arr nil))										
				(T
					(declenchement_arr R)																						
					(push R *BR_blacklist*)
					(remove R regles_candidates)
					(setq regles_candidates (append regles_candidates (nouvelles-regles-candidates_arr regles_candidates)))
				)
			)
		)
	)
)

(defun exploreLargeur()
	(setq *NB_REGLES* 0)
	(let* ((regles_candidates_depart (regles-candidates)) (regles_candidates regles_candidates_depart) (R nil))														
		(print "----------------")
		(format t "~%Regles candidates : ~S ~%" regles_candidates)

		(loop										
			(cond
				((is-name-parameter-in-BF 'NOM)(return-from exploreLargeur (set-found (caaadr (is-name-parameter-in-BF 'NOM)))))
				((not (setq R (pop regles_candidates))) (return-from exploreLargeur nil))										
				(T
					(format t "~%Declenchement de la regle : ~S ~%" R)
					(setq *NB_REGLES* (+ *NB_REGLES* 1))
					(declenchement R)																						
					(push R *BR_blacklist*)
					(remove R regles_candidates)

					(format t "~%Nouvelles regles candidates : ~S ~%" (nouvelles-regles-candidates regles_candidates))
					(setq regles_candidates (append regles_candidates (nouvelles-regles-candidates regles_candidates)))
					(format t "~%Ensemble des regles candidates : ~S ~%" regles_candidates)
				)
			)
		)
	)
)

(defun exploreProfondeur()
	(setq *NB_REGLES* 0)
	(let* ((regles_candidates_depart (regles-candidates)) (regles_candidates regles_candidates_depart) (R nil))														
		(print "----------------")
		(format t "~%Regles candidates : ~S ~%" regles_candidates)

		(loop										
			(cond
				((is-name-parameter-in-BF 'NOM)(return-from exploreProfondeur (set-found (caaadr (is-name-parameter-in-BF 'NOM)))))
				((not (setq R (pop regles_candidates))) (return-from exploreProfondeur nil))										
				(T
					(format t "~%Declenchement de la regle : ~S ~%" R)
					(setq *NB_REGLES* (+ *NB_REGLES* 1))
					(declenchement R)
					(push R *BR_blacklist*)
					(remove R regles_candidates)

					(format t "~%Nouvelles regles candidates : ~S ~%" (nouvelles-regles-candidates regles_candidates))
					(setq regles_candidates (append (nouvelles-regles-candidates regles_candidates) regles_candidates))
					(format t "~%Ensemble des regles candidates : ~S ~%" regles_candidates)
				)
			)
		)
	)
)

(defun nouvelles-regles-candidates (regles_candidates_depart) ; Renvoie uniquement les nouvelles règles
	(let ((newRules nil))
		(dolist (RC (regles-candidates) (reverse newRules))
			(when (not (member RC regles_candidates_depart))
				(push RC newRules))
		)
	)
)

(defun nouvelles-regles-candidates_arr (regles_candidates_depart) ; Renvoie uniquement les nouvelles règles
	(let ((newRules nil))
		(dolist (RC (regles-candidates_arr) (reverse newRules))
			(when (not (member RC regles_candidates_depart))
				(push RC newRules))
		)
	)
)

(defun declenchement (R)
	
	(let ((conclusions (conclusion R)) (name_parameter nil) (operator nil)(name_variable nil) (value nil) (parameter_line nil))
		
		(dolist (C conclusions)						; C = (PARAMETRE = VARIABLE)
			(update-BF (create-container C))
		)
	)
)

(defun declenchement_arr (R)
	
	(let ((prems (premisses R)))
		
		(dolist (p prems)		; p = (PARAMETRE = VARIABLE)
			(if (prem-different-exists-in-BF p)
			(pushnew (car p) *INCOHERENCE*)
			(update-BF (create-container p))
			)
		)
	)
)

(defun is-comparison-operator (operator)
	(cond
		((equal operator '<=) t)
		((equal operator '>=) t)
		((equal operator '<) t)
		((equal operator '>) t)
		(t nil)
	)
)

(defun create-container (assertion) ; FORMAT standart : (PARAMETRE/VARIABLE operateur VARIABLE/VALEUR)
	
	(let ((name_variable (car assertion)) (operator (cadr assertion)) (value (caddr assertion)))
		(cond 
			((is-set-operator operator)											; Opérateur assembliste de type : (PARAMETRE IN (VARIABLES1 ... N))
				(list name_variable value operator value))
			((is-comparison-operator operator)									; Opérateur de comparaison de type : (PARAMETRE >= VALEUR)
				(list name_variable value operator value))
			((get-parent-name name_variable)									; On a : (VARIABLE operateur VALEUR)
				(list (get-parent-name name_variable) name_variable '= (get-meaning-value operator value)))
			(t 																	; On a : (PARAMETRE operateur VARIABLE)
				(list name_variable value '= (get-meaning-value operator 'OUI)))
		)
	)
)
; Container : préparation pour l'insertion en BF
; Base de faits : que des = OUI ou = NON.

(defun get-meaning-value (operator value)
	(let ((bool (convert-to-bool value)))
		(cond 
			((equal operator '=) (convert-to-value bool))
			((equal operator '!) (convert-to-value (not bool)))
		)
	)
)


(defun create-parameter-in-bf (parameter)
	(push (list parameter nil) *BF*)
)

(defun add-variables-in-bf (parameter variable value operator)
	(when (assoc parameter *BF*)
		(cond
			((is-set-operator operator)
				(cond 
					((equal operator 'IN)
						(dolist (var value)
							(push (list var '=  'OUI) (cadr (assoc parameter *BF*)))
						)
					)
				)
			)
			((is-comparison-operator operator)
				(cond 
					((equal operator '>=)
						(push (list value '= 'OUI) (cadr (assoc parameter *BF*)))
					)
				)
			)
			((equal operator '=)
				(push (list variable '= value) (cadr (assoc parameter *BF*)))
			)
		)
	)
)

(defun conclusion (R)
	(if (listp R)
		(caddr R)
		(caddr (get-regle R))
	)
)

(defun premisses (R)
	(if (listp R)
		(cadr R)
		(cadr (get-regle R))
	)
)

(defun get-regle (R*)
	(assoc R* *BR*)
)

(defun regles-candidates_arr ()
	(let ((regles (select-rules *BR* *BR_blacklist*)) (flag t)(conclusions nil)(P nil)(regles_candidates nil))
		(dolist (R regles (reverse regles_candidates)) 		;Pour chaque règle
			(setq flag NIL)
			(setq conclusions (conclusion R))
			(dolist (c conclusions)
				(when (prem-exists-in-BF c)
					(setq flag t)
				)
			)	
			(when flag
				(push (car R) regles_candidates))
		)
	)
)

(defun regles-candidates ()
	(let ((regles (select-rules *BR* *BR_blacklist*)) (flag t)(prems nil)(P nil)(regles_candidates nil))
		(dolist (R regles (reverse regles_candidates)) 		;Pour chaque règle
			(setq flag t)
			(setq prems (premisses R))
			(loop				; Parcourt de toutes les prémisses : si flag reste vrai alors la Règle est candidate
				(cond 
					((not flag)(return-from nil))
					((not (setq P (pop prems)))(return-from nil))
					((not (prem-exists-in-BF P)) (setq flag nil))
				)
			)

			(when flag
				(push (car R) regles_candidates))
		)
	)
)

(defun select-rules (BR BR_blacklist)
	(let ((result nil))
		(dolist (R BR (reverse result))
			(when (not (member (car R) BR_blacklist))
				(push R result))
		)
	)
)

(defun prem-exists-in-BF (premisse)  ; de la forme (A operateur B)
	(let ((c (create-container premisse))(parameter_line nil)(variable_line nil))
		(cond 
			((not (setq parameter_line (is-name-parameter-in-BF (get-np c)))) (return-from prem-exists-in-BF nil)) ; parameter_line = ligne de la BF avec comme clé le paramètre recherché (FONCTION (TRAITEMENT_TEXTE = OUI) (...)) ==> le paramètre est bien dans la BF
			((not (setq variable_line (is-name-variable-in-BF parameter_line (get-nv c)))) (return-from prem-exists-in-BF nil)) ; variable_line = sous-élément de parameter_line : (TRAITEMENT_TEXTE = OUI) ==> La variable est bien dans la BF
			((is-true variable_line (get-o c) (get-v c)) (return-from prem-exists-in-BF t)) ; la valeur associée à la variable est bonne
		)
		nil
	)
)

(defun prem-different-exists-in-BF (premisse)  ; de la forme (A operateur B)
	(let ((c (create-container premisse))(parameter_line nil)(variable_line nil))
		(cond 
			((not (setq parameter_line (is-name-parameter-in-BF (get-np c)))) (return-from prem-different-exists-in-BF nil)) ; parameter_line = ligne de la BF avec comme clé le paramètre recherché (FONCTION (TRAITEMENT_TEXTE = OUI) (...)) ==> le paramètre est bien dans la BF
			((not (setq variable_line (is-name-variable-in-BF parameter_line (get-nv c)))) (return-from prem-different-exists-in-BF nil)) ; variable_line = sous-élément de parameter_line : (TRAITEMENT_TEXTE = OUI) ==> La variable est bien dans la BF
			((not(is-true variable_line (get-o c) (get-v c))) (return-from prem-different-exists-in-BF t)) ; la valeur associée à la variable est bonne
		)
		nil
	)
)





(defun is-set-operator (O)
	(cond
		((equal O 'IN) t)
		(t nil)
	)
)

(defun is-true (line O_BR V_BR) ; line = (Variable = valeur) dans la BF ; O et V viennent de la BR
	(cond 
		((and (listp line) (listp (car line))) ; Si line est une liste contenant au moins une sous-liste, on utilise la récursion sur chaque sous-liste
			(let ((vars line)(var nil)(flag nil))
				(loop
					(cond 
						(flag (return-from is-true t))
						((not (setq var (pop vars)))(return-from is-true nil))
						(t (setq flag (is-true var O_BR V_BR)))
					)
				)
			)
		)
		(t 
			(let ((parameter NIL)(ret NIL)(variable (car line))(O_BF (cadr line)) (V_BF (caddr line))) ; provient de la BF
				(cond 
					((equal O_BR '=) ; SI règle de la forme : (VARIABLE = VALEUR)
						(return-from is-true (not (xor-values V_BR V_BF)))
					)
					((equal O_BR '!) ; SI règle de la forme : (VARIABLE ! VALEUR)
						(return-from is-true (xor-values V_BR V_BF))
					)
					((equal O_BR '>=) ; SI règle de la forme : (VARIABLE >= VALEUR)
						
						(cond 
							((get-parent-name variable) ; premice est une variable et on récupere le paramètre
								(setq parameter (get-parent-name variable))
								
							)
							(T 
								(setq parameter (car variable))
								
							)
						)
						
						(dolist (v (cadr (is-name-parameter-in-BF parameter)))
							(if (and (eq (caddr v) 'OUI) (>= variable))
								(setq ret T)
							)
						)
					
						(return-from is-true ret)
					)
					((equal O_BR 'IN) ; SI règle de la forme : (VARIABLE IN (VALEUR1 VALEUR2))
						(if (and (convert-to-bool V_BF) (member variable V_BR))
							(return-from is-true t)
							(return-from is-true nil)
						)
					)
				)
			)
		)
	)
)


(defun xor-values (a b)
	(setq a (convert-to-bool a))
	(setq b (convert-to-bool b))
	(if (xor a b) t nil)
)

(defun xor (x y)
	(if (or (and x (not y)) (and (not x) y))
		t
		nil
	)
)

(defun convert-to-bool (V)
	(if (equal V 'OUI)
		t
		nil
	)
)

(defun convert-to-value (V)
	(if V
		'OUI
		'NON
	)
)

(defun get-parent-name (P) ; Retourne nil si P est déjà un paramètre
	(let ((params *PARAMETERS*)(Parent nil))
		(when (assoc P params) ; si c'est déjà un paramètre lui-même
			(return-from get-parent-name nil))
		(loop
			(cond 
				((not (setq Parent (pop params))) (return-from get-parent-name nil))
				((member P (get-parameter-attribut Parent 'VALUES)) (return-from get-parent-name (get-name-parameter Parent)))
			)	
		)
	)
)

(defun is-type-LISTE (P)
	(let ((name P) (name-parent  (get-parent-name P)))
		(cond 
			((assoc name *PARAMETERS*) (equal 'LISTE (get-parameter-attribut (assoc name *PARAMETERS*) 'TYPE))) ; 
			((assoc name-parent *PARAMETERS*) (equal 'LISTE (get-parameter-attribut (assoc name-parent *PARAMETERS*) 'TYPE))) ;
			(t nil)
		)
	)
)

(defun stared-name (P)
	(concat-syms '* P '*)
)

(defun concat-syms (&rest syms)
  (intern (apply #'concatenate 'string (mapcar #'symbol-name syms)))
)

(defun add-rule(premisses conclusion)
	(let
		((id (gentemp "R"))(rule NIL))
		(setq rule
			(list 
				id
				premisses
				conclusion
			)
		)
		(pushnew rule *BR*)
		rule
	)
)


(defun initBR ()
	
	(setq *BR_blacklist* nil)
	(setq *BR* nil)
	
	; Ajout des règles dans la base

	(load (concatenate 'string *chemin* "Donnees/regles.lisp"))
)


