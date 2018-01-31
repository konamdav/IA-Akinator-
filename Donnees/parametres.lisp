(add-parameter 'LICENCE  'UNIQUE 'NON 'NON '(LIBRE PROPRIETAIRE OPEN_SOURCE SHAREWARE FREEWARE) "") 
(add-parameter 'POPULARITE  'UNIQUE 'NON 'NON '(FORTE) "")

(add-parameter 'PRISE_EN_MAIN  'UNIQUE 'OUI 'OUI '(FACILE NORMALE DIFFICILE) "La prise en main (facilite d'utilisation) du logiciel est ~S  ?~%~%") 
(add-parameter 'DOCUMENTATION  'UNIQUE 'OUI 'OUI '(MOYENNE  EXHAUSTIVE) "La documentation ou l'aide que l'on peut trouver est ~S  ?~%~%") 
(add-parameter 'COMMUNAUTE_UTILISATEURS  'UNIQUE 'OUI 'OUI '(MOYENNE IMPORTANTE) "La communaute d'utilisateurs est-elle ~S  ?~%~%") 
(add-parameter 'COMMUNAUTE_DEVELOPPEURS  'UNIQUE 'OUI 'OUI '(INACTIVE ACTIVE) "La communaute de developpeurs (si elle existe) qui travaille dessus est-elle ~S  ?~%~%") 


(add-parameter 'DROITS  'LISTE 'OUI 'OUI '(GRATUIT PROTEGE_DROIT_AUTEUR CODE_SOURCE_DISPONIBLE COPIE_AUTORISE MODIFICATION_AUTORISE REVENTE_AUTORISE) "Une des caracteristiques de la licence est ~S  ?~%~%") 
;(add-parameter 'SYSTEME_COMPATIBLE 'LISTE 'NON 'OUI '(WINDOWS GNU_LINUX WINDOWSPHONE IOS ANDROID OSX) "") 
(add-parameter 'SUITE_LOGICIELLE 'UNIQUE 'NON 'OUI '(LIBRE_OFFICE) "") 
(add-parameter 'NOM 'UNIQUE 'NON 'OUI '() "") 
(add-parameter 'ANNEE 'UNIQUE 'OUI 'NON '(1950 1970 1989 1990 2010 2015) "Le logiciel existait-il deja en  ~S  ?~%~%") 
(add-parameter 'EDITEUR 'UNIQUE  'OUI'OUI '(MICROSOFT) "L'editeur est ~S  ?~%~%") 
(add-parameter 'FONCTION 'UNIQUE 'OUI 'OUI '(TRAITEMENT_TEXTE) "La fonction du logiciel est ~S  ?~%~%") 
;(add-parameter 'PLATEFORME 'LISTE 'NON 'OUI '(ORDINATEUR MOBILE) "") 
(add-parameter 'TYPE 'UNIQUE 'OUI 'OUI '(APPLICATION BIBILIOTHEQUE) "Le logiciel est-il de type ~S  ?~%~%") 
(add-parameter 'UTILISATEUR 'UNIQUE 'OUI 'OUI '(TOUT_PUBLIC EXPERIMENTE) "Le genre d'utilisateur est-il de type ~S  ?~%~%") 
(add-parameter 'THEME 'UNIQUE 'OUI 'OUI '(BUREAUTIQUE) "Le theme du logiciel est-il ~S  ?~%~%") 

;la suite est rajouté dynamiquement

;ajout dynamique de valeurs dans les parametres
(add-value-to-parameter 'NOM 'POWERPOINT)
(add-value-to-parameter 'FONCTION 'PRESENTATION_MULTIMEDIA)
;fin de l'ajout 
;ajout dynamique de valeurs dans les parametres
(add-value-to-parameter 'NOM 'LIBRE_OFFICE_WRITER)
(add-value-to-parameter 'EDITEUR 'DOCUMENT_FOUNDATION)
(add-value-to-parameter 'ANNEE '2011)
;fin de l'ajout 
;ajout dynamique de valeurs dans les parametres
(add-value-to-parameter 'NOM 'NOTEPAD)
(add-value-to-parameter 'ANNEE '2005)
(add-value-to-parameter 'EDITEUR 'NOTEPAD_TEAM)
;fin de l'ajout 
;ajout dynamique de valeurs dans les parametres
(add-value-to-parameter 'NOM 'WORD)
(add-value-to-parameter 'SUITE_LOGICIELLE 'MICROSOFT_OFFICE)
;fin de l'ajout 
;ajout dynamique de valeurs dans les parametres
(add-value-to-parameter 'NOM 'EXCEL)
(add-value-to-parameter 'FONCTION 'TRAITEMENT_DONNEES)
;fin de l'ajout 
;ajout dynamique de valeurs dans les parametres
(add-value-to-parameter 'NOM 'PHOTOSHOP)
(add-value-to-parameter 'FONCTION 'RETOUCHE_IMAGE)
(add-value-to-parameter 'SUITE_LOGICIELLE 'ADOBE_CREATIVE_SUITE)
(add-value-to-parameter 'SUITE_LOGICIELLE 'ADOBE_CREATIVE_SUITE)
(add-value-to-parameter 'THEME 'GRAPHISME)
(add-value-to-parameter 'POPULARITE 'IMPORTANTE)
(add-value-to-parameter 'SUITE_LOGICIELLE 'ADOBE_CREATIVE_SUITE)
(add-value-to-parameter 'ANNEE '2003)
(add-value-to-parameter 'THEME 'GRAPHISME)
(add-value-to-parameter 'EDITEUR 'ADOBE)
;fin de l'ajout 
;ajout dynamique de valeurs dans les parametres
(add-value-to-parameter 'NOM 'AFTER_EFFECT)
(add-value-to-parameter 'FONCTION 'TRAITEMENT_VIDEO)
;fin de l'ajout 
