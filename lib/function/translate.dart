import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:flutter/material.dart';

translate(name,lang){

  Map<String, Object>? data;

  if(lang=='English'){

    data = {
      "add_patient":'Add patient',
      "mesure":"Measurement record",
      "history_mesure":"Measure history",
      "user":"Patient",
      "registration":"Registration",
      "title_center":"Exam center area",
      "users":"Patients",
      "agenda":"Agenda",
      "us_examinations":"Our exams",
      "profile":"Profile",
      "label_text":"Explore our space dedicated to exam centers",
      "consult":"Consult",
      "text_user":"Patient",
      "text_center":"Professional",
      "home":"Home",
      "to_plan":"To plan",
      "diagnostics":"Diagnostics",
      "title":"Analysis of blood\npressure",
      "description":"The diagnosis, management, and estimated mortality risk in patients with hypertension have been historically based on clinic or office blood pressure readings.",
      "text_sign":"Sign In",
      "text_login":"Login",
      "submit_sign_in":"Sign In",
      "done":"Done",
      "error_email": "Please enter your email",
      "error_password": "Please enter your password",
      "label_email": "Email",
      "label_password": "Password",
      "submit_login": "Login",
      "label_first_name": "First name",
      "error_first_name": "Please enter your name",
      "label_last_name": "Last name",
      "error_last_name": "Please enter your first name",
      "label_birthday": "Date of birth",
      "error_birthday": "Please enter your date of birth",
      "label_location": "Address",
      "error_location": "Please enter your address",
      "label_phone": "Phone",
      "error_phone": "Please enter your phone valid",
      "label_man": "Man",
      "label_woman": "Woman",
      "print": "Print",
      "search":"Search",
      "share": "Share",
      "empty_exam":"No exam found",
      "empty_mesure":"No measure found",
      "empty_archive":"No archive found",
      "or":"Or",
      "inquiry":"Medical inquiries",
      "date_title" : "All exams start at 8:30am and must be take before the wish day and hour.",
      "date_picker" : "Choose a consultation date",
      "date_day" : "Choose the meeting day",
      "date_time" : "Choose the meeting time",
      "date_day_error" : "Please choose a valid date",
      "date_time_error" : "Please choose a valid time",
      "date_confirm" : "Confirm date",
      "scanPDF": "Scan document to PDF",
      "send_doc":"Download Document(s)",
      "login_text":"Hi! Log in for a personalized experience or sign up now",
      "center_text":"Hi! Log in for a personalized experience",
      "info":"""The diagnosis, management, and estimated mortality risk in patients with hypertension have been historically based on clinic or office blood pressure readings. Current evidence indicates that 24-hour ambulatory blood pressure monitoring should be an integral part of hypertension care.
        
After 24 hours, the patient returns, and the data are downloaded, including any information requested by the physician in a diary. 

The most useful information includes the 24-hour average blood pressure, the average daytime blood pressure, the average nighttime blood pressure, and the calculated percentage drop in blood pressure at night.   
      """,
      "validate":"I agree with this terms of use",
      "welcome_dash":"Welcome",
      "text_dash":"Patient space",
      "my_exam":"My exams",
      "my_exam_text":"List of all your exams",
      "calendar_exam":"Schedule the ABPM exam",
      "calendar_exam_text":"Consult the list of medical centers where you can schedule your exams",
      "edit_exam":"Edit an exam",
      "new_exam":'New exam',
      "edit_exam_text":"List of all your exams",
      "have_address":"Have address",
      "search_address":"Search for closer center exam",
      "have_text": "Find an exam center",
      "search_text": "Nearest exam center",
      "empty_exam_center":"No exam center found",
      "search_center":"Search exam center",
      "find_center":"Find exam center",
      "confirm":"Confirm",
      "confirm_center":"Confirm center",
      "personal_data": "Personal information",
      "weight": "Weight",
      "size": "Size",
      "medics": "Medics",
      "situation": "Situation",
      "activity": "Activity",
      "diseases": "Diseases",
      "error_size": "Please enter your size",
      "error_weight": "Please enter your weight",
      "error_medics": "Please enter the doctor",
      "error_situation": "Please enter your situation",
      "error_activity": "Please enter your activity",
      "error_diseases": "Please enter your diseases",
      "activities":['Activity','Student','Worker','Manager','Unemployed','Retir'],
      "situations":['Situation','Married','Single','Divorced','Widower'],
      "origins" : ['Origin', 'Asian','European','African','North American','South American'],
      "confirm_data":"Confirm personnal data",
      "center_exam_data":"Center exam data",
      "data_center":"Name of Doctot / Hospital",
      "error_data": "Please enter name of Doctot / Hospital",
      "address":"Adresse",
      "error_address": "Please enter address",
      "city":"City",
      "error_city": "Please enter city",
      "zip_code":"ZIP Code",
      "error_zip_code": "Please enter zip code",
      "email":"E-mail",
      "data":"Data",
      "payment":"Payment",
      "query":"Medical request from Doctor / Hospital",
      "error query":"Please enter the medical request from the doctor/hospital",
      "upload" : Image.asset('assets/images/upload-en.png',height: 170),
      "info_validate":"""The equipment may only be used and operated with care and for its intended use. The use of the equipment must comply with all applicable laws and regulations.
The Device shall maintain, at the Lessee’s cost, the Equipment in good repair and operating condition, allowing for reasonable wear and tear. 

At the end of the Lease term, the Lessee shall be obligated to return the Equipment to the Exam Center at the Lessee's expense within [24 hours.

In cas of none return in the exact time a penalty of XXX USD will be apply. Until payment any result will be returned.


""",
  "labels_config": {
        ScannerLabelsConfig.PDF_GALLERY_EMPTY_TITLE: 'Documents',
        ScannerLabelsConfig.PDF_GALLERY_EMPTY_MESSAGE: 'PDF gallery is empty',
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_SINGLE: 'PDF Document',
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_MULTIPLE: 'PDF Documents',
        ScannerLabelsConfig.PDF_GALLERY_DONE_LABEL: 'Done',
        ScannerLabelsConfig.PDF_GALLERY_ADD_IMAGE_LABEL: 'Scan',
        ScannerLabelsConfig.PICKER_CAMERA_LABEL: 'Devices Photo',
        ScannerLabelsConfig.PICKER_GALLERY_LABEL: 'Gallery',
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: 'Next',
        ScannerLabelsConfig.ANDROID_SAVE_BUTTON_LABEL: 'Save',
        ScannerLabelsConfig.ANDROID_ROTATE_LEFT_LABEL: 'Rotate left',
        ScannerLabelsConfig.ANDROID_ROTATE_RIGHT_LABEL: 'Rotate right',
        ScannerLabelsConfig.ANDROID_ORIGINAL_LABEL: 'Original',
        ScannerLabelsConfig.ANDROID_BMW_LABEL: 'BMW',
        ScannerLabelsConfig.ANDROID_SCANNING_MESSAGE: 'Scanning...',
        ScannerLabelsConfig.ANDROID_LOADING_MESSAGE: 'Loading...',
        ScannerLabelsConfig.ANDROID_APPLYING_FILTER_MESSAGE: 'Applying filter...',
        ScannerLabelsConfig.ANDROID_CANT_CROP_ERROR_TITLE: 'Unable to crop',
        ScannerLabelsConfig.ANDROID_CANT_CROP_ERROR_MESSAGE: 'Unable to crop image. Try Again.',
        ScannerLabelsConfig.ANDROID_OK_LABEL: 'OK',
      },
      "no_document":"No document",
      "text_otp":"Please enter your confirmation code to send by mail",
      "verify":"Verification",
      "retry":"Re-drown the code",
      "file_exam": "My file",
      "file_exam_text": "Registering your information",
      "calling": "Call",
      "geolocation": "Location",
      "empty_exam_center_action":"Currently this center does not offer exam services",
      "do_exam":"Take the exam",
      "open_library":'Open gallery',
      "open_camera": "Open camera",
      "required_file":"Please select the necessary documents",
      "wait":"Please wait...",
      "confirmation": "Confirmation code",
      "code_message":"""This registration number must be given to your examination center for loading information onto the analysis device

This code will be available in your 'My exams' section """,
      "end":"Finish",
      "text_card": """To confirm your identity please scan/download the document below

 (Passport / Identity card / Unknown)""",
      "result":'See\nesults\nAvailable',
      "pending":"Pending",
      "archive_exam": "My archives",
      "archive_text": "List of your medical archives",
      "register_date":"Registration date",
      "exam_date":"Exam date",
      "exam":'Exam',
      "add":'Add',
      "save":'Save',
      "exam_date_placeholder":"DD/MM/YYYY",
      "add_archive":"Add archive",
      "file diagnostic":"Carry out a diagnosis",
      "file_diagnostic_text":"List of diagnostics available",
      "empty_diagnostic":"No diagnostics available",
      "empty_users":"No patients available",
      "result_diagnostic":"Result",
      "measure": "Measurement record",
      "tension":'Blood pressure Sys',
      "tension_art":"Blood pressure Dias",
      "oxygen":"Oxygemetry",
      "frequence":"Heart rate",
      "rythme":"Heart rate",
      "rythme_label": ['Regular', 'Irregular']
    };

  }else if(lang=='Français'){

    data = {
      "text_user":"Patient",
      "text_center":"Professionnel",
      "home":"Accueil",
      "to_plan":"Planifier",
      "diagnostics":"Diagnostiques",
      "title":"Analyse de la tension\nartérielle",
      "description" : "Le diagnostic, la prise en charge et le risque de mortalité estimé chez les patients souffrant d'hypertension ont toujours été basés sur les mesures de tension artérielle en clinique ou en cabinet.",
      "text_sign": "S'inscire",
      "text_login": "Se connecter",
      "done":"C'est compris",
      "error_email":"Veuillez saisir votre email",
      "error_password":"Veuillez saisir votre mot de passe",
      "label_email":"E-mail",
      "label_password":"Mot de passe",
      "submit_login":"Se connecter",
      "submit_sign_in":"S'inscrire",
      "label_first_name": "Nom",
      "error_first_name": "Veuillez saisir votre nom",
      "label_last_name": "Prénom",
      "error_last_name": "Veuillez saisir votre prénom",
      "label_birthday": "Date de naissance",
      "error_birthday": "Veuillez saisir votre date de naissance",
      "label_location": "Adresse",
      "error_location": "Veuillez saisir votre adresse",
      "label_phone": "Téléphone",
      "error_phone": 'Saisir un téléphone valide',
      "label_man": "Homme",
      "label_woman": "Femme",
      "print": "Imprimer",
      "share": "Partager",
      "new_exam":'Nouveau examen',
      "empty_exam":"Aucune examen trouvée",
      "empty_mesure":"Aucun relevé trouvée",
      "empty_exam_center":"Aucun centre d'examen trouvée",
      "login_text":"Salut ! Connectez-vous pour une expérience personnalisée ou inscrivez-vous dès maintenant",
      "center_text":"Salut ! Connectez-vous pour une expérience personnalisée",
      "or":"Ou",
      "inquiry":"Compléments de dossier médical",
      "date_title" : "Les examens commencent à 8:30 et doivent etre prise avant la date et l'heure désirées.",
      "date_picker" : "Choisir une date de consultation",
      "date_day" : "Choisir le jour de consultation",
      "date_time" : "Choisir l'heure de consultation",
      "date_day_error" : "Veuillez choisir un jour valide",
      "date_time_error" : "Veuillez choisir une heure valide",
      "date_confirm" : "Confirmer le rendez-vous",
      "scanPDF": "Scanner un document en PDF",
      "send_doc":"Transmettre le(les) document(s)",
      "info":"""Le diagnostic, la prise en charge et le risque de mortalité estimé chez les patients souffrant d'hypertension ont toujours été basés sur les lectures de tension artérielle en clinique ou en cabinet. Les preuves actuelles indiquent que la surveillance ambulatoire de la pression artérielle 24 heures sur 24 devrait faire partie intégrante des soins de l'hypertension.
        
Après 24 heures, le patient revient et les données sont téléchargées, y compris toute information demandée par le médecin dans un journal.

Les informations les plus utiles comprennent la tension artérielle moyenne sur 24 heures, la tension artérielle moyenne diurne, la tension artérielle nocturne moyenne et le pourcentage calculé de baisse de la tension artérielle la nuit.
       """,
      "validate": "J'accepte ces conditions d'utilisation",
      "welcome_dash":"Bienvenue",
      "text_dash":"Espace patient",
      "my_exam":"Mes examens",
      "my_exam_text":"Liste de tous vos examens",
      "calendar_exam":"Planifier l'examen ABPM",
      "calendar_exam_text":"Consultez la liste des centres médicaux où vous pouvez planifier vos examens",
      "edit_exam":"Modifier un examen",
      "edit_exam_text":"Liste de tous vos examens",
      "have_address":"Avoir une adresse",
      "have_text":"Retrouvez un centre d'examen",
      "search_address":"Rechercher le centre le plus proche",
      "search_text":"Centre d'examen le plus proche",
      "search_center":"Recherche de centre d'examen",
      "search":"Recherche",
      "find_center":"Trouver un centre d'examen",
      "confirm":"Confirmer",
      "confirm_center":"Confirmer le centre",
      "personal_data":"Information personnel",
      "weight":"Poids",
      "size": "Taille",
      "medics": "Médecins",
      "situation": "Situation",
      "activity": "Activité",
      "diseases": "Maladies",
      "error_size": "Veuillez saisir votre taille",
      "error_weight": "Veuillez saisir votre poids",
      "error_medics": "Veuillez saisir le médecins",
      "error_situation": "Veuillez saisir votre situation",
      "error_activity": "Veuillez saisir votre activité",
      "error_diseases": "Veuillez saisir vos maladies",
      "activities":['Activité','Étudiant','Travailleur','Manager','Chômeur','Retraite'],
      "situations":['Situation','Marié','Célibataire','Divorcé','Veuf'],
      "origins" : ['Origine', 'Asiatique','Européenne','Africaine','Nord-Américaine','Sud-Américaine'],
      "confirm_data":"Confirmer vos informations",
      "center_exam_data":"Information du centre",
      "data_center": "Nom du Docteur / Hôpital",
      "error_data": "Veuillez entrer le nom du médecin/hôpital",
      "address": "Adresse",
      "error_address": "Veuillez saisir votre adresse",
      "city": "Ville",
      "error_city": "Veuillez entrer la ville",
      "zip_code": "Code postal",
      "error_zip_code": "Veuillez saisir le code postal",
      "email": "E-mail",
      "data":"Données",
      "payment":"Paiement",
      "query":"Demande médicale du médecin/hôpital",
      "error_query":"Veuillez saisire la demande médicale du médecin / hôpital",
      "upload" : Image.asset('assets/images/upload.png',height: 170),
      "info_validate":"""L'équipement ne peut être utilisé et utilisé qu'avec soin et pour l'usage auquel il est destiné. L'utilisation de l'équipement doit être conforme à toutes les lois et réglementations applicables.
L’Appareil devra maintenir, aux frais du Locataire, l’Équipement en bon état de réparation et de fonctionnement, tenant compte d’une usure raisonnable.

À la fin de la durée du bail, le locataire sera tenu de restituer l'équipement au centre d'examen aux frais du locataire dans un délai de [24 heures.

En cas de non-retour dans les délais, une pénalité de XXX USD sera appliquée. Jusqu'au paiement, tout résultat sera restitué.


""",
  "labels_config": {
      ScannerLabelsConfig.PDF_GALLERY_EMPTY_TITLE: 'Documents',
      ScannerLabelsConfig.PDF_GALLERY_EMPTY_MESSAGE: 'La galerie de PDF est vide',
      ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_SINGLE: 'Document PDF',
      ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_MULTIPLE: 'Documents PDF',
      ScannerLabelsConfig.PDF_GALLERY_DONE_LABEL: 'Terminé',
      ScannerLabelsConfig.PDF_GALLERY_ADD_IMAGE_LABEL: 'Scanner',
      ScannerLabelsConfig.PICKER_CAMERA_LABEL: 'Appareil photo',
      ScannerLabelsConfig.PICKER_GALLERY_LABEL: 'Galerie',
      ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: 'Suivant',
      ScannerLabelsConfig.ANDROID_SAVE_BUTTON_LABEL: 'Enregistrer',
      ScannerLabelsConfig.ANDROID_ROTATE_LEFT_LABEL: 'Rotation gauche',
      ScannerLabelsConfig.ANDROID_ROTATE_RIGHT_LABEL: 'Rotation droite',
      ScannerLabelsConfig.ANDROID_ORIGINAL_LABEL: 'Original',
      ScannerLabelsConfig.ANDROID_BMW_LABEL: 'BMW',
      ScannerLabelsConfig.ANDROID_SCANNING_MESSAGE: 'Numérisation en cours...',
      ScannerLabelsConfig.ANDROID_LOADING_MESSAGE: 'Chargement...',
      ScannerLabelsConfig.ANDROID_APPLYING_FILTER_MESSAGE: 'Application du filtre en cours...',
      ScannerLabelsConfig.ANDROID_CANT_CROP_ERROR_TITLE: 'Impossible de rogner',
      ScannerLabelsConfig.ANDROID_CANT_CROP_ERROR_MESSAGE: 'Impossible de rogner l\'image. Veuillez réessayer.',
      ScannerLabelsConfig.ANDROID_OK_LABEL: 'OK',
      },
      "no_document":"Pas de document",
      "text_otp":"Veuillez saisir votre code de confirmation envoyer par mail",
      "verify":"Vérificaton",
      "retry":"Renoyer le code",
      "file_exam": "Ma fiche",
      "file_exam_text": "Enregistrement de vos infromations",
      "calling": "Appelez",
      "geolocalisation": "Localisation",
      "empty_exam_center_action":"Actuellement, ce centre ne propose pas de services d'examen",
      "do_exam":"Faire l'examen",
      "open_library":'Ouvrir la galerie',
      "open_camera": "Ouvrir l'appareil photo",
      "required_file":"Veuillez sélectionner les documents nécessaires",
      "wait":"Veuillez patienter ...",
      "confirmation": "Code de confirmation",
      "code_message":"""Ce numéro d'enregistrement est à donner à votre centre d'examen pour le chargement des informations sur l'appareil d'analyse

Ce code sera disponible dans votre section 'Mes examens' """,
      "end":"Terminer",
      "text_card": """Pour confirmer votre identité veuillez scanner/télécharger le document ci-dessous

 (Passeport / Carte d'identité / Insu)""",
      "result":'Voir\nResultats\nDisponible',
      "pending":"En attente",
      "archive_exam":"Mes archives",
      "archive_text":"Liste de vos archives médicals",
      "empty_archive":"Aucun archive",
      "register_date":"Date d'enreistrement",
      "exam_date":"Date de l'examen",
      "exam":'Examen',
      "add":'Ajouter',
      "save":'Enregistrer',
      "exam_date_placeholder":"JJ/MM/AAAA",
      "add_archive":"Ajoute une archive",
      "file_diagnostic":"Faire un diagnostique",
      "file_diagnostic_text":"Liste des diagnostiques disponible",
      "empty_diagnostic":"Aucun diagnotique disponible",
      "empty_users":"Aucun patient disponible",
      "result_diagnostic":"Resultat",
      "consult":"Consulter",
      "title_center":"Espace centre d'examen",
      "label_text":"Explorez notre espace dédié aux centres d'examen",
      "users":"Patients",
      "agenda":"Agenda",
      "us_examens":"Nos examens",
      "profil":"Profil",
      "registration":"Inscription",
      "user":"Patient",
      "mesure":"Relevé de mesures",
      "history_mesure":"Historique mesure",
      "tension":'Tension artérielle Sys',
      "tension_art":"Tension artérielle Dias",
      "oxygen":"Oxygémétrie",
      "frequence":"Fréquence cardiaque",
      "rythme":"Rythme cardiaque",
      "rythme_label": ['Régulier', 'Irrégulier'],
      "add_patient":'Nouveau patient'
    };

  }

  return data![name];

}