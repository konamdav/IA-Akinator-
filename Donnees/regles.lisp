;regles


(add-rule 		'((PRISE_EN_MAIN = FACILE))  '((UTILISATEUR = TOUT_PUBLIC)))	
(add-rule 		'((PRISE_EN_MAIN = DIFFICILE))  '((UTILISATEUR = EXPERIMENTE)))		
(add-rule 		'((PRISE_EN_MAIN = FACILE)(COMMUNAUTE_UTILISATEURS = IMPORTANTE))  '((POPULARITE = FORTE)))		
(add-rule 		'((PRISE_EN_MAIN = FACILE)(COMMUNAUTE_DEVELOPPEURS = ACTIVE))  '((POPULARITE = FORTE)))		
(add-rule 		'((PRISE_EN_MAIN = DIFFICILE)(COMMUNAUTE_UTILISATEURS = IMPORTANTE))  '((POPULARITE = FORTE)))		
(add-rule 		'((PRISE_EN_MAIN = DIFFICILE)(COMMUNAUTE_UTILISATEURS = MOYENNE))  '((POPULARITE = FORTE)))
(add-rule 		'((PRISE_EN_MAIN = FACILE)(DOCUMENTATION = EXHAUSTIVE))  '((POPULARITE = FORTE)))


;méta regle pour enlever tout les paramètres servant uniquement à déterminer la popularité car celle-ci est déjà trouvé
(add-rule 		'((POPULARITE = FORTE))  '((DOCUMENTATION ! EXHAUSTIVE) (DOCUMENTATION ! MOYENNE)))	

(add-rule 		'((COMMUNAUTE_DEVELOPPEURS ! ACTIVE)(COMMUNAUTE_DEVELOPPEURS ! INACTIVE))  '((CODE_SOURCE_DISPONIBLE = NON)(COPIE_AUTORISE = NON)(MODIFICATION_AUTORISE = NON)))
(add-rule '((COMMUNAUTE_DEVELOPPEURS = ACTIVE)) '((CODE_SOURCE_DISPONIBLE = OUI)(COPIE_AUTORISE = OUI)(MODIFICATION_AUTORISE = OUI)))
(add-rule '((COMMUNAUTE_DEVELOPPEURS = ACTIVE)(REVENTE_AUTORISE = OUI)) '((LICENCE = LIBRE)))
(add-rule '((COMMUNAUTE_DEVELOPPEURS = ACTIVE)(REVENTE_AUTORISE = NON)) '((LICENCE = OPEN_SOURCE)))

(add-rule 		'((TYPE = OS)) 																																			'((SYSTEME_COMPATIBLE = AUCUN)))
(add-rule 		'((PROTEGE_DROIT_AUTEUR = OUI)(CODE_SOURCE_DISPONIBLE = OUI)(COPIE_AUTORISE = OUI)(MODIFICATION_AUTORISE = OUI)(REVENTE_AUTORISE = OUI)) 				'((LICENCE = LIBRE)))
(add-rule 		'((PROTEGE_DROIT_AUTEUR = OUI)(CODE_SOURCE_DISPONIBLE = NON)(COPIE_AUTORISE = NON)(MODIFICATION_AUTORISE = NON)(REVENTE_AUTORISE = NON)) 	'((LICENCE =  PROPRIETAIRE)))
(add-rule 	 	'((GRATUIT = OUI)(PROTEGE_DROIT_AUTEUR = NON)(CODE_SOURCE_DISPONIBLE = OUI)(COPIE_AUTORISE = OUI)(MODIFICATION_AUTORISE = OUI)(REVENTE_AUTORISE = OUI)) 								'((LICENCE =  DOMAINE_PUBLIC)))
(add-rule 	 	'((GRATUIT = OUI)(PROTEGE_DROIT_AUTEUR = OUI)(COPIE_AUTORISE = NON)(MODIFICATION_AUTORISE = NON)(REVENTE_AUTORISE = NON)) 								'((LICENCE = FREEWARE)))
(add-rule 	 	'((GRATUIT = NON)(PROTEGE_DROIT_AUTEUR = OUI)(CODE_SOURCE_DISPONIBLE = NON)(COPIE_AUTORISE = OUI)(MODIFICATION_AUTORISE = NON)(REVENTE_AUTORISE = NON)) 								'((LICENCE = SHAREWARE)))
(add-rule		'((PROTEGE_DROIT_AUTEUR = OUI)(CODE_SOURCE_DISPONIBLE = OUI)(COPIE_AUTORISE = OUI)(MODIFICATION_AUTORISE = OUI)(REVENTE_AUTORISE = NON)) 				'((LICENCE = OPEN_SOURCE)))																						  
(add-rule  		'((SUITE_LOGICIELLE = MICROSOFT_OFFICE)) 																												'((SYSTEME_COMPATIBLE IN (WINDOWS IOS ANDROID OSX)) (PLATEFORME IN (MOBILE ORDINATEUR)) (EDITEUR = MICROSOFT)))
(add-rule  		'((SYSTEME_COMPATIBLE IN (UNIX LINUX))) 																															'((LICENCE = LIBRE)))																							
(add-rule  	'((SUITE_LOGICIELLE = IWORK)) 																															'((SYSTEME_COMPATIBLE IN (IOS OSX))))
(add-rule		'((PLATEFORME ! MOBILE)) 																																'((PLATEFORME = ORDINATEUR)))
(add-rule		'((PLATEFORME ! ORDINATEUR)) 																															'((PLATEFORME = MOBILE)))
(add-rule			  '((SYSTEME_COMPATIBLE IN (IOS ANDROID WINDOWSPHONE))) 																												'((PLATEFORME = MOBILE)))
(add-rule 		'((SYSTEME_COMPATIBLE IN (WINDOWS LINUX UNIX OSX))) 																												'((PLATEFORME = ORDINATEUR)))
(add-rule  	'((UTILISATEUR ! TOUT_PUBLIC)) 																															'((UTILISATEUR = EXPERIMENTE)))
(add-rule  	'((UTILISATEUR ! EXPERIMENTE)) 																															'((UTILISATEUR = TOUT_PUBLIC)))
(add-rule 		'((PRISE_EN_MAIN = DIFFICILE)(COMMUNAUTE_UTILISATEURS = IMPORTANTE))  '((POPULARITE = FORTE)(UTILISATEUR = TOUT_PUBLIC)))		
;ajout regle dynamique
(add-rule '((FONCTION = TRAITEMENT_TEXTE)
            (SUITE_LOGICIELLE = MICROSOFT_OFFICE)) '((NOM = WORD)))
(add-rule '((LICENCE = PROPRIETAIRE) (TYPE = APPLICATION)
            (THEME = BUREAUTIQUE)
            (POPULARITE = FORTE)) '((SUITE_LOGICIELLE
                                          =
                                          MICROSOFT_OFFICE)))
(add-rule '((LICENCE = PROPRIETAIRE) (UTILISATEUR = TOUT_PUBLIC)
            (ANNEE >= 1989) (TYPE = APPLICATION) (THEME = BUREAUTIQUE)
            (EDITEUR = MICROSOFT)) '((SUITE_LOGICIELLE
                                      =
                                      MICROSOFT_OFFICE)))
									  
									  
									  
;fin de l'ajout
;ajout regle dynamique
(add-rule '((FONCTION = PRESENTATION_MULTIMEDIA)
            (SUITE_LOGICIELLE = MICROSOFT_OFFICE)) '((NOM
                                                      =
                                                      POWERPOINT)))
;fin de l'ajout 
;ajout regle dynamique
(add-rule '((FONCTION = TRAITEMENT_TEXTE)
            (SUITE_LOGICIELLE = LIBRE_OFFICE)) '((NOM = LIBRE_OFFICE_WRITER)))
(add-rule '((LICENCE = LIBRE) (UTILISATEUR = TOUT_PUBLIC)
            (ANNEE >= 2011) (TYPE = APPLICATION) (THEME = BUREAUTIQUE)
            (EDITEUR = DOCUMENT_FOUNDATION)) '((SUITE_LOGICIELLE
                                                =
                                                LIBRE_OFFICE)))
;fin de l'ajout 
;ajout regle dynamique
(add-rule '((FONCTION = TRAITEMENT_TEXTE) (LICENCE = LIBRE)
            (UTILISATEUR = TOUT_PUBLIC) (ANNEE >= 2005)
            (TYPE = APPLICATION) (THEME = BUREAUTIQUE)
            (EDITEUR = NOTEPAD_TEAM)) '((NOM = NOTEPAD)))
;fin de l'ajout 

;ajout regle dynamique
(add-rule '((FONCTION = TRAITEMENT_DONNEES)
            (SUITE_LOGICIELLE = MICROSOFT_OFFICE)) '((NOM = EXCEL)))
;fin de l'ajout 
;ajout regle dynamique
(add-rule '((FONCTION = RETOUCHE_IMAGE)
            (SUITE_LOGICIELLE = ADOBE_CREATIVE_SUITE)) '((NOM
                                                          =
                                                          PHOTOSHOP)))
(add-rule '((LICENCE = PROPRIETAIRE) (TYPE = APPLICATION)
            (THEME = GRAPHISME)
            (POPULARITE = FORTE)) '((SUITE_LOGICIELLE
                                          =
                                          ADOBE_CREATIVE_SUITE)))
(add-rule '((LICENCE = PROPRIETAIRE) (UTILISATEUR = EXPERIMENTE)
            (ANNEE >= 2003) (TYPE = APPLICATION) (THEME = GRAPHISME)
            (EDITEUR = ADOBE)) '((SUITE_LOGICIELLE
                                  =
                                  ADOBE_CREATIVE_SUITE)))
;fin de l'ajout 
;ajout regle dynamique
(add-rule '((FONCTION = TRAITEMENT_VIDEO)
            (SUITE_LOGICIELLE = ADOBE_CREATIVE_SUITE)) '((NOM
                                                          =
                                                          AFTER_EFFECT)))
;fin de l'ajout 

