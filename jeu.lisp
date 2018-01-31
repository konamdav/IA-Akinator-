(defvar *chemin*)
(setq *chemin* "C:/Users/Davy/Documents/UTC/IA01/HAKINATOR_V2/")
;A CHANGER

(format t "________________________________________________________________________________~%~%")
(format t "Chargement des fichiers du logiciel...~%")

; Charge les variables globales
(format t "Fichier de fonctions...~%")

(load (concatenate 'string *chemin* "Ressources/constantes.lisp"))

; Charge les fonctions de service
(format t "Fichier de fonctions...~%")

(load (concatenate 'string *chemin* "Ressources/fonctions.lisp"))

; Charge le module de sauvegarde
(format t "Fichier de sauvegarde...~%")

(load (concatenate 'string *chemin* "Ressources/gestionParametres.lisp"))

; Charge le module de sauvegarde
(format t "Fichier de sauvegarde...~%")

(load (concatenate 'string *chemin* "Ressources/sauvegarde.lisp"))

; Charge la base de règles
(format t "Fichier de regles...~%")

(load (concatenate 'string *chemin* "Ressources/moteurRegles.lisp"))

; Charge la base de faits
(format t "Fichier de faits...~%")

(load (concatenate 'string *chemin* "Ressources/moteurFaits.lisp"))



; Chargement des paramètres
(format t "Fichier de parametres...~%")

(load (concatenate 'string *chemin* "Donnees/parametres.lisp"))

(format t "Chargement termine.~%")

(defun gameMenu (&aux input)
	(format t "~%~%Menu principal:~%")
	(format t "	1-Devine le logiciel auquel tu penses~%")
	(format t "	2-Devine les informations d'un logiciel~%")
	(format t "	3-Recherche simple en largeur [base pre-remplie]~%")
	(format t "	4-Recherche simple en profondeur [base pre-remplie]~%")
	(format t "	5-Aide~%")
	(format t "	6-Quitter~%")
	(loop
		(format t "Entrez votre choix: ")
		(setq input (read))
		(if (and (> input 0) (<= input 6))
			(return-from nil T)
			(format t "Erreur: Choix impossible~%")
			
		)
	)
	input
)

(defun start_game()
	 (format t "~%Chargement des donnees de jeu...~%")
	 (initBR)
	 (initBF)
	 (init_parameters)
	 (setq *SOFT_FOUND* NIL)
	 (reset-not-found)	 
	  (format t "Chargement termine !~%")
	 
	 (loop 
		
		(when (is-answer-found)
			 (if (software-found)
				(return-from start_game)
			 )
		)
		(when (not (is-parameters-not-asked))
					(return-from start_game (not-found))
		)
	
		(format t "~%")
	~	(if (explore);en tapant 4 on stoppe explore pour quitter le mode jeu
			(progn (format t  "Vous avez interrompu le jeu en tapant 4~%")(return-from start_game))
		)
	)
)


(defun start_explore_se_largeur()
	(format t "~%Chargement des donnees de jeu...~%")
	(initBR)
	(initBF_for_explore_se)
	(init_parameters)
	(setq *SOFT_FOUND* NIL)
	(reset-not-found)
	(format t "Chargement termine !~%")
	(format t "~%~%BF avant explore : ~%")
	(dolist (f *BF*)
		(format t "~S ~%" f)
	)
	(format t "explore...~%")
	
	;on lance le moteur d'inférence
	(exploreLargeur)
	(format t "~%~%BF apres explore :  ~%")
	(dolist (f *BF*)
		(format t "~S ~%" f)
	)
	(format t "~%Nombre de regles candidates restantes ~S !~%" (length (regles-candidates)))
	(format t "~%Nombre de regles executes ~S !~%" *NB_REGLES*)
	(if (is-answer-found)
		(format t "~%Les informations de la BF m'ont permit de reconnaitre le logiciel ~S !~%" *SOFT_FOUND*)
		(format t "~%Les informations de la BF ne sont pas suffisante pour que je puisse determiner le logiciel~%")
	)
	(separate)
)

(defun start_explore_arr()
	(format t "~%Chargement des donnees de jeu...~%")
	(initBR)
	(initBF)
	(init_parameters)
	(setq *SOFT_FOUND* NIL)
	(reset-not-found)
	(format t "Chargement termine !~%")
	(let 
		((nom NIL))
		(setq *INCOHERENCE* nil)
		(loop
			(format t "~%Entrez un logiciel parmis  ~S :~%" (get-parameter-attribut (assoc 'NOM *PARAMETERS*)  'VALUES))
			(setq nom (read))
			(when (is-value-to-parameter 'NOM nom)
				(return-from nil)
			)
		)
		(update-BF (create-container (list nom '= 'OUI)))
		(explore_arr)
		(format t "~%Voila ce que je peux supposer sur ~S~%" nom)
		(format t "~%Affichage de la BF~%")
		(dolist (f *BF*)
			(format t "~S ~%" f)
		)
		
		(when *INCOHERENCE*
			(format t "~%Je ne suis pas sur des informations suivantes:~%")
			(dolist (f *INCOHERENCE*)
				(format t "~S ~%" f)
			)
			(setq *INCOHERENCE* nil)
		)
		(separate)
	)
	
)

(defun start_explore_se_profondeur()
	(format t "~%Chargement des donnees de jeu...~%")
	(initBR)
	(initBF_for_explore_se)
	(init_parameters)
	(setq *SOFT_FOUND* NIL)
	(reset-not-found)
	(format t "Chargement termine !~%")
	(format t "~%~%BF avant explore : ~%")
	(dolist (f *BF*)
		(format t "~S ~%" f)
	)
	(format t "explore...~%")
	
	;on lance le moteur d'inférence
	(exploreProfondeur)
	(format t "~%~%BF apres explore : ~%")
	(dolist (f *BF*)
		(format t "~S ~%" f)
	)
	(format t "~%Nombre de regles candidates restantes ~S !~%" (length (regles-candidates)))
	(format t "~%Nombre de regles executes ~S !~%" *NB_REGLES*)
	(if (is-answer-found)
		(format t "~%Les informations de la BF m'ont permit de reconnaitre le logiciel ~S !~%" *SOFT_FOUND*)
		(format t "~%Les informations de la BF ne sont pas suffisante pour que je puisse determiner le logiciel~%")
	)
	(separate)
)


(defun not-found()
	(let ((input NIL))
		(format t "Je suis arrive au bout de mes questions et je n'ai rien trouve.~%")
		(format t "Veux tu me dire le logiciel auquel tu pensais ?~%")
		(format t "1 - OUI~%")
		(format t "2 - NON~%")
		(format t "Entrez votre choix: ")
		
		(loop
			(setq input (read))
			(if (and (> input 0) (< input 3))
				(if (= input 1)
					(return-from not-found (saisie-answer))
					(return-from not-found t)
				)
				(format t "Erreur: Choix impossible~%")
				
			)
		)
	)

)
(defun main (&aux choix)
	(printLogo)
	(loop
		(setq choix (gameMenu))
		(case choix
			(1 (start_game))
			(4 (start_explore_se_profondeur))
			(3 (start_explore_se_largeur))
			(2 (start_explore_arr))
			(5 (printAide))
			(6 (format t "~%Fin du jeu Hackinator.~%" )(return-from main t))
			
		)	
	)
)

(defun printAide ()
	(separate)
	(format t "Bienvenue sur Hackinator, le programme qui devinne le logiciel auquel tu penses~%~%")
	(format t "Lancer le programme et reponder aux questions en indiquant 1 (Oui), 2 (Non) ou 3 (Je ne sais pas)~%")
	(format t "Si Hackinator ne trouve pas ton logiciel, ne te rejouit pas trop vite car Hackinator apprend vite...~%")
	(format t "Bonne partie !~%~%")
	(format t "Ce jeu est realise dans le cadre de l'UV IA01 par JEANNOT Paul et KONAM David~%")
)

(defun printLogo ()
	(separate)
	(format t "ooooo ooooo      o       oooooooo8 oooo   oooo ooooo oooo   oooo     o   ooooooooooo   ooooooo  oooooooooo  
 888   888      888    o888     88  888  o88    888   8888o  88     888  88  888  88 o888   888o 888    888 
 888ooo888     8  88   888          888888      888   88 888o88    8  88     888     888     888 888oooo88  
 888   888    8oooo88  888o     oo  888  88o    888   88   8888   8oooo88    888     888o   o888 888  88o   
o888o o888o o88o  o888o 888oooo88  o888o o888o o888o o88o    88 o88o  o888o o888o      88ooo88  o888o  88o8 
~%")
)

;##################################################################################################
;## Lancement du programme ########################################################################
(main)
