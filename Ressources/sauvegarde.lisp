;saisie du logiciel
(defun saisie-answer()
	(let
		((nom NIL))
		(format t "~%Nom du logiciel ?~%")
		(setq nom (read))
		(save-parameters nom)
	)
)


;générer dynamiquement les règles via la saisie et le contenu déja présent dans BF
(defun generate-rule-via-BF(software)
	(let
		((rules NIL)(premisses NIL)(premisses2 NIL)(input NIL)(tmp NIL)(parameter NIL) (variable NIL)(conclusion NIL)(licence (cadr (is-name-parameter-in-BF 'LICENCE)))
		(droits (cadr (is-name-parameter-in-BF 'DROITS))) (suite (cadr (is-name-parameter-in-BF 'SUITE_LOGICIELLE)))
		(editeur (cadr (is-name-parameter-in-BF 'EDITEUR)))(type (cadr (is-name-parameter-in-BF 'TYPE)))(theme (cadr (is-name-parameter-in-BF 'THEME)))(fonction (cadr (is-name-parameter-in-BF 'FONCTION)))
		(name-licence NIL)(name-suite NIL)(utilisateur (cadr (is-name-parameter-in-BF 'UTILISATEUR)))(annee (cadr (is-name-parameter-in-BF 'ANNEE)))
		)
		
		;création de la regle licence
		(cond
			((null licence)
				(format t "~%Nom de la licence ?~%")
				(setq tmp (read))
				(setq conclusion (list (list 'LICENCE '= tmp)))
				(dolist (d droits)
					(push d premisses)
				)
				(push (add-rule premisses conclusion) rules)
				(setq name-licence tmp)
			)
			(T 
				(dolist (l  licence)
					(when (eq (caddr l) 'OUI)
						(setq name-licence(car l))
					)
				)
			
			)
		)
		(setq premisses NIL)
		;creation de la regle suite logicielle
		(cond
			((null suite)
				(format t "~%Nom de la suite ?~%")
				(format t "(Entrer AUCUN si le logiciel ne possede pas de suite)~%")
				(setq tmp (read))
				(setq name-suite tmp)
				(when (not (eq name-suite 'AUCUN))
					(setq conclusion (list (list 'SUITE_LOGICIELLE '= tmp)))
				)
				
				;suite populaire ?
				(format t "~%Populaire ?~%")
				(format t "1 - OUI~%")
				(format t "2 - NON~%")
				(format t "Entrez votre choix : ")
				(setq tmp (read))
				(if (= tmp 1)
					(push (list 'POPULARITE '= 'FORTE) premisses2)
				)
				
				;possede editeur ?
				(dolist (e editeur)
					(when (eq (caddr e) 'OUI)
						(push  (list 'EDITEUR '= (car e)) premisses)
						(setq editeur NIL)
					)
				)
				(when editeur
					(format t "~%Nom de l'editeur ?~%")
					(setq tmp (read))
					(push  (list 'EDITEUR '= tmp) premisses)
				)
				
				;possede theme ?
				(dolist (th theme)
					(when (eq (caddr th) 'OUI)
						(push  (list 'THEME '= (car th)) premisses)
						(push  (list 'THEME '= (car th)) premisses2)
						
						(setq theme NIL)
					)
				)
				(when theme
					(format t "~%Theme du logiciel ?~%")
					(setq tmp (read))
					(push  (list 'THEME '= tmp) premisses)
					(push  (list 'THEME '= tmp) premisses2)
				)
				
				;possede type ?
				(dolist (ty type)
					(when (eq (caddr ty) 'OUI)
						(push  (list 'TYPE '= (car ty)) premisses)
						(push  (list 'TYPE '= (car ty)) premisses2)
						(setq type NIL)
					)
				)
				(when type
					(format t "Type du logiciel ?~%")
					(setq tmp (read))
					(push  (list 'TYPE '= tmp) premisses)
					(push  (list 'TYPE '= tmp) premisses2)
				)
				
				;annee
				(format t "~%Annee de parution du logiciel ?~%")
				(setq tmp (read))
				(push  (list 'ANNEE '>= tmp) premisses)
				
				
				;possede utilisateur ?
				(dolist (u utilisateur)
					(when (eq (caddr u) 'OUI)
						(push  (list 'UTILISATEUR '= (car u)) premisses)
						(setq utilisateur NIL)
					)
				)
				(when utilisateur
					(format t "~%Catégorie d'utilisateur  ?~%")
					(setq tmp (read))
					(push  (list 'UTILISATEUR '= tmp) premisses)
				)
				
				
				(push (list 'LICENCE '= name-licence) premisses)
				(push (list 'LICENCE '= name-licence) premisses2)
				(when (not (eq name-suite 'AUCUN))
					(push (add-rule premisses conclusion) rules)
					(when (not (null premisses2))
						(push (add-rule premisses2 conclusion) rules)
					)
				)
			)
			(T 
				(dolist (s  suite)
					(when (eq (caddr s) 'OUI)
						(setq name-suite(car s))
					)
				)
			
			)
		)
		
		;création de la règle nom logiciel
		(when (not (eq name-suite 'AUCUN))
			(setq premisses NIL)
			(setq premisses2 NIL)
			(push (list 'SUITE_LOGICIELLE '= name-suite) premisses)
		)
		
		(setq conclusion (list (list 'NOM '= software)))
		
		
		;possede fonction ?
		(dolist (f fonction)
			(when (eq (caddr f) 'OUI)
				(push  (list 'FONCTION '= (car f)) premisses)
				(setq fonction NIL)
			)
		)
		(when fonction
			(format t "~%Fonction du logiciel ?~%")
			(setq tmp (read))
			(push  (list 'FONCTION '= tmp) premisses)
		)
		
		
		
		(push (add-rule premisses conclusion) rules)
		(when (not (null premisses2))
			(push (add-rule premisses2 conclusion) rules)
		)
		rules
	)
)

;ecriture dans les fichiers parameter et regles
(defun save-parameters (software)
	(let 
		(
			(rules (generate-rule-via-BF software))(flot_regles (open "C:/Users/Davy/Documents/UTC/IA01/HAKINATOR_V2/Donnees/regles.lisp" :direction :output :if-exists ::append :if-does-not-exist :create))
			(flot_parameters (open "C:/Users/Davy/Documents/UTC/IA01/HAKINATOR_V2/Donnees/parametres.lisp" :direction :output :if-exists ::append :if-does-not-exist :create))
		)
		
		(format t "Sauvegarde des informations...~%")
		(format flot_regles ";ajout regle dynamique~%")
		(dolist (r rules)
			(format flot_regles "(add-rule '~S '~S)~%" (premisses r)(conclusion r))
		)
		(format flot_regles ";fin de l'ajout ~%")
		(close flot_regles)
		
		(format flot_parameters ";ajout dynamique de valeurs dans les parametres~%")
		(dolist (r rules)		
			(dolist (c (conclusion r))
				(when (not (is-value-to-parameter (car c) (caddr c)))
					(format flot_parameters "(add-value-to-parameter '~S '~S)~%" (car c) (caddr c))
				)
			)
			(dolist (p (premisses r))
				(when (not (is-value-to-parameter (car p) (caddr p)))
					(format flot_parameters "(add-value-to-parameter '~S '~S)~%" (car p) (caddr p))
				)
			)
		)
		(format flot_parameters ";fin de l'ajout ~%")
		(close flot_parameters)
	)
	(format t "Terminé.~%")
)
