import 'package:flutter/material.dart';

translate(name,lang){

  Map<String, Object>? data;

  if(lang=='English'){

    data = {
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
      "submit_login": "Log in",
      "label_first_name": "First name",
      "error_first_name": "Please enter your name",
      "label_last_name": "Last name",
      "error_last_name": "Please enter your first name",
      "label_birthday": "Date of birth",
      "error_birthday": "Please enter your date of birth",
      "label_location": "Address",
      "error_location": "Please enter your address",
      "label_phone": "Phone",
      "error_phone": "Please enter your phone",
      "label_man": "Man",
      "label_woman": "Woman",
      "print": "Print",
      "search":"Search",
      "share": "Share",
      "empty_exam":"No exam found",
      "or":"Or",
      "login_text":"Hi! Log in for a personalized experience or sign up now",
      "info":"""The diagnosis, management, and estimated mortality risk in patients with hypertension have been historically based on clinic or office blood pressure readings. Current evidence indicates that 24-hour ambulatory blood pressure monitoring should be an integral part of hypertension care.
        
After 24 hours, the patient returns, and the data are downloaded, including any information requested by the physician in a diary. 

The most useful information includes the 24-hour average blood pressure, the average daytime blood pressure, the average nighttime blood pressure, and the calculated percentage drop in blood pressure at night.   
      """,
      "validate":"I agree with this terms of use",
      "welcome_dash":"Welcome to",
      "text_dash":"User space",
      "my_exam":"My exams",
      "my_exam_text":"List of all your exams",
      "calendar_exam":"Schedule the ABPM exam",
      "calendar_exam_text":"Done all exams",
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
      "situations":['Situation','Single','Divorced','Widower'],
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


"""
    };

  }else if(lang=='Français'){

    data = {
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
      "error_phone": 'Veuillez saisir votre téléphone',
      "label_man": "Homme",
      "label_woman": "Femme",
      "print": "Imprimer",
      "share": "Partager",
      "new_exam":'Nouveau examen',
      "empty_exam":"Aucune examen trouvée",
      "empty_exam_center":"Aucun centre d'examen trouvée",
      "login_text":"Salut ! Connectez-vous pour une expérience personnalisée ou inscrivez-vous dès maintenant",
      "or":"Ou",
      "info":"""Le diagnostic, la prise en charge et le risque de mortalité estimé chez les patients souffrant d'hypertension ont toujours été basés sur les lectures de tension artérielle en clinique ou en cabinet. Les preuves actuelles indiquent que la surveillance ambulatoire de la pression artérielle 24 heures sur 24 devrait faire partie intégrante des soins de l'hypertension.
        
Après 24 heures, le patient revient et les données sont téléchargées, y compris toute information demandée par le médecin dans un journal.

Les informations les plus utiles comprennent la tension artérielle moyenne sur 24 heures, la tension artérielle moyenne diurne, la tension artérielle nocturne moyenne et le pourcentage calculé de baisse de la tension artérielle la nuit.
       """,
      "validate": "J'accepte ces conditions d'utilisation",
      "welcome_dash":"Bienvenue sur",
      "text_dash":"Espace utilisateur",
      "my_exam":"Mes examens",
      "my_exam_text":"Liste de tous vos examens",
      "calendar_exam":"Planifier l'examen ABPM",
      "calendar_exam_text":"Faite de tous les examens",
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
      "situations":['Situation','Célibataire','Divorcé','Veuf'],
      "origins" : ['Origine', 'Asiatique','Européenne','Africaine','Nord-Américaine','Sud-Américaine'],
      "confirm_data":"Confirmer vos infornmations",
      "center_exam_data":"Informatiuon du centre",
      "data_center": "Nom du Doctot / Hôpital",
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


"""
    };

  }

  return data![name];

}