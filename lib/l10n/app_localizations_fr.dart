// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get commonError => 'Erreur';

  @override
  String get commonEmail => 'Email';

  @override
  String get commonEmailHint => 'ex: nom@domaine.com';

  @override
  String get commonEmailRequired => 'Email requis';

  @override
  String get commonEmailInvalid => 'Email invalide';

  @override
  String get commonPassword => 'Mot de passe';

  @override
  String get commonPasswordHint => '••••••••';

  @override
  String get commonPasswordRequired => 'Mot de passe requis';

  @override
  String commonPasswordMinChars(int min) {
    return 'Minimum $min caractères';
  }

  @override
  String get authLoginTitle => 'Connexion';

  @override
  String get authLoginSubtitle =>
      'Accédez à vos rendez-vous, messages et documents.';

  @override
  String get authLoginButton => 'Se connecter';

  @override
  String get authForgotPasswordCta => 'Mot de passe oublié ?';

  @override
  String get authCreateAccountCta => 'Créer un compte';

  @override
  String get authContinueWithGoogle => 'Continuer avec Google';

  @override
  String get authContinueWithoutAccount => 'Continuer sans compte';

  @override
  String get authRegisterTitle => 'Créer un compte';

  @override
  String get authRegisterSubtitle => 'Tous les champs sont obligatoires.';

  @override
  String get authFirstName => 'Prénom';

  @override
  String get authLastName => 'Nom';

  @override
  String get profileCompletionTitle => 'Complétez votre profil';

  @override
  String get profileCompletionSubtitle =>
      'Ces informations sont obligatoires pour continuer.';

  @override
  String profileCompletionStepLabel(int current, int total) {
    return '$current/$total';
  }

  @override
  String get profileCompletionStepIdentityTitle => 'Identité';

  @override
  String get profileCompletionStepIdentitySubtitle =>
      'Dites-nous qui vous êtes.';

  @override
  String get profileCompletionDateOfBirth => 'Date de naissance';

  @override
  String get profileCompletionCity => 'Ville (optionnel)';

  @override
  String get profileCompletionSex => 'Sexe (optionnel)';

  @override
  String get profileCompletionSexMale => 'Homme';

  @override
  String get profileCompletionSexFemale => 'Femme';

  @override
  String get profileCompletionSexOther => 'Autre';

  @override
  String get profileCompletionAvatar => 'Photo de profil (optionnel)';

  @override
  String get profileCompletionStepContactTitle => 'Contact';

  @override
  String get profileCompletionStepContactSubtitle =>
      'Comment peut-on vous joindre ?';

  @override
  String get profileCompletionEmailLockedHint =>
      'Votre email est lié à votre compte et ne peut pas être modifié ici.';

  @override
  String get profileCompletionPhone => 'Numéro de téléphone';

  @override
  String get profileCompletionPhoneHint => 'ex. +972 50 123 4567';

  @override
  String get profileCompletionPhoneInvalid => 'Numéro de téléphone invalide';

  @override
  String get profileCompletionStepIsraelTitle => 'Israël';

  @override
  String get profileCompletionStepIsraelSubtitle =>
      'Informations requises pour les soins en Israël.';

  @override
  String get profileCompletionTeudatHint => '9 chiffres';

  @override
  String get profileCompletionTeudatInvalid => 'Numéro d\'identité invalide';

  @override
  String get profileCompletionStepInsuranceTitle => 'Assurance';

  @override
  String get profileCompletionStepInsuranceSubtitle =>
      'Optionnel (vous pouvez passer).';

  @override
  String get profileCompletionInsurance => 'Assurance';

  @override
  String get profileCompletionInsuranceNone => 'Aucune / passer';

  @override
  String get profileCompletionInsuranceOptionalHint =>
      'L’assurance est optionnelle. Vous pourrez l’ajouter plus tard dans les paramètres.';

  @override
  String get profileCompletionFinish => 'Terminer';

  @override
  String get commonRequired => 'Requis';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get authAlreadyHaveAccount => 'J\'ai déjà un compte';

  @override
  String get authForgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get authForgotPasswordSubtitle =>
      'Nous vous enverrons un code à 6 chiffres par email.';

  @override
  String get authForgotPasswordSendLink => 'Envoyer le code';

  @override
  String get authBackToLogin => 'Retour à la connexion';

  @override
  String get authForgotPasswordEmailSent =>
      'Code envoyé. Vérifiez votre boîte mail.';

  @override
  String get authResetPasswordVerifyTitle => 'Saisissez le code';

  @override
  String authResetPasswordVerifyDescription(Object email) {
    return 'Nous avons envoyé un code à 6 chiffres à $email. Saisissez-le pour continuer.';
  }

  @override
  String get authResetPasswordNewTitle => 'Nouveau mot de passe';

  @override
  String get authResetPasswordNewSubtitle =>
      'Choisissez un nouveau mot de passe.';

  @override
  String get authResetPasswordConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authResetPasswordPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get authResetPasswordUpdateButton => 'Mettre à jour le mot de passe';

  @override
  String get authResetPasswordUpdatedSnack =>
      'Mot de passe mis à jour. Vous pouvez vous reconnecter.';

  @override
  String get authVerifyEmailTitle => 'Vérifiez votre email';

  @override
  String authVerifyEmailDescription(Object email) {
    return 'Nous avons envoyé un code à 6 chiffres à $email. Saisissez-le ci-dessous.';
  }

  @override
  String get authVerifyEmailOtpHint => '000000';

  @override
  String get authVerifyEmailVerify => 'Vérifier';

  @override
  String get authVerifyEmailCheckedBackToLogin =>
      'J\'ai vérifié, retourner à la connexion';

  @override
  String get authVerifyEmailResend => 'Renvoyer le code';

  @override
  String get authVerifyEmailResentSnack => 'Code de confirmation renvoyé.';

  @override
  String get commonBack => 'Retour';

  @override
  String get homeMyPractitioners => 'Mes praticiens';

  @override
  String get homeHistory => 'Historique';

  @override
  String homeGreeting(Object name) {
    return 'Bonjour $name';
  }

  @override
  String get homeGreetingGuest => 'Bonjour !';

  @override
  String get homeSearchHint => 'Praticien, spécialité...';

  @override
  String get homeHealthTip1 => 'Cette année, adoptez les bons réflexes santé.';

  @override
  String get homeHealthTip2 => 'Il est encore temps de vous faire vacciner.';

  @override
  String get homeCompleteHealthProfile => 'Compléter votre profil santé';

  @override
  String get homeCompleteHealthProfileSubtitle =>
      'Recevez des rappels personnalisés et préparez vos RDV';

  @override
  String get homeStart => 'Commencer';

  @override
  String get homeNoRecentPractitioner => 'Aucun praticien récent';

  @override
  String get homeHistoryDescription =>
      'Vous pouvez afficher la liste des praticiens que vous avez consultés';

  @override
  String get homeHistoryEnabledSnack => 'Historique activé';

  @override
  String get homeHistoryEnabled => 'Historique activé';

  @override
  String get homeActivateHistory => 'Activer l\'historique';

  @override
  String homeNewMessageTitle(Object name) {
    return 'Vous avez un nouveau message du Dr $name';
  }

  @override
  String get homeNewMessageNoAppointment => 'Aucun rendez-vous associé';

  @override
  String get homeUpcomingAppointmentsTitle => 'Rendez-vous à venir';

  @override
  String get homeNoUpcomingAppointments =>
      'Aucun rendez-vous à venir pour le moment';

  @override
  String get homeFindAppointmentCta => 'Trouvez un rendez-vous';

  @override
  String get homeNoAppointmentsEmptyDescription =>
      'Pour le moment, vous n’avez pas de rendez-vous. Cherchez un praticien et réservez votre premier créneau.';

  @override
  String get homeLast3AppointmentsTitle => '3 derniers rendez-vous';

  @override
  String get homeSeeAllPastAppointments => 'Voir';

  @override
  String get homeAppointmentHistoryTitle => 'Historique de rendez-vous';

  @override
  String get homeNoAppointmentHistory => 'Aucun rendez-vous passé';

  @override
  String get commonTryAgainLater => 'Réessayez plus tard.';

  @override
  String get commonTryAgain => 'Réessayer';

  @override
  String get commonUnableToLoad => 'Impossible de charger';

  @override
  String get commonAvailableSoon => 'Disponible bientôt';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonActionIsFinal => 'Cette action est définitive.';

  @override
  String get commonTodo => 'À faire';

  @override
  String get commonToRead => 'À lire';

  @override
  String get commonSettings => 'Paramètres';

  @override
  String get commonTryAgainInAMoment => 'Réessayez dans un instant.';

  @override
  String commonMinChars(int min) {
    return 'Minimum $min caractères';
  }

  @override
  String get commonOnline => 'En ligne';

  @override
  String get appointmentsTitle => 'Mes rendez-vous';

  @override
  String get appointmentsTabUpcoming => 'À venir';

  @override
  String get appointmentsTabPast => 'Passés';

  @override
  String get appointmentsNoUpcomingTitle => 'Aucun rendez-vous à venir';

  @override
  String get appointmentsNoUpcomingSubtitle =>
      'Vos prochains RDV apparaîtront ici.';

  @override
  String get appointmentsNoPastTitle => 'Aucun rendez-vous passé';

  @override
  String get appointmentsNoPastSubtitle => 'Vos RDV terminés apparaîtront ici.';

  @override
  String get searchTitle => 'Rechercher';

  @override
  String get searchHint => 'Praticien, spécialité...';

  @override
  String get searchUnavailableTitle => 'Recherche indisponible';

  @override
  String get searchNoResultsTitle => 'Aucun résultat';

  @override
  String get searchNoResultsSubtitle => 'Essayez avec un autre terme.';

  @override
  String get searchFilterTitle => 'Filtrer les résultats';

  @override
  String get searchFilterDate => 'Date de disponibilité';

  @override
  String get searchFilterDateToday => 'Aujourd\'hui';

  @override
  String get searchFilterDateTomorrow => 'Demain';

  @override
  String get searchFilterDateThisWeek => 'Cette semaine';

  @override
  String get searchFilterDateNextWeek => 'Semaine prochaine';

  @override
  String get searchFilterDateAny => 'Toute date';

  @override
  String get searchFilterSpecialty => 'Spécialité';

  @override
  String get searchFilterSpecialtyAll => 'Toutes les spécialités';

  @override
  String get searchFilterKupatHolim => 'Caisse d\'assurance';

  @override
  String get searchFilterKupatHolimAll => 'Toutes les caisses';

  @override
  String get searchFilterDistance => 'Distance maximale';

  @override
  String get searchFilterDistanceAny => 'Sans limite';

  @override
  String get searchFilterApply => 'Appliquer les filtres';

  @override
  String get searchFilterReset => 'Tout effacer';

  @override
  String searchFilterActiveCount(int count) {
    return '$count filtre(s) actif(s)';
  }

  @override
  String get searchSortTitle => 'Trier par';

  @override
  String get searchSortAvailability => 'Disponibilité';

  @override
  String get searchSortAvailabilitySubtitle =>
      'Du plus disponible au moins disponible';

  @override
  String get searchSortDistance => 'Distance';

  @override
  String get searchSortDistanceSubtitle => 'Du plus proche au plus éloigné';

  @override
  String get searchSortName => 'Nom';

  @override
  String get searchSortNameSubtitle => 'Par ordre alphabétique';

  @override
  String get searchSortRating => 'Évaluation';

  @override
  String get searchSortRatingSubtitle => 'Du mieux noté au moins bien noté';

  @override
  String get searchSortPrice => 'Prix';

  @override
  String get searchSortPriceSubtitle => 'Du plus cher au moins cher';

  @override
  String get searchFilterPrice => 'Fourchette de prix';

  @override
  String get searchFilterPriceAll => 'Tous les prix';

  @override
  String get searchFilterPriceUnder200 => 'Moins de 200₪';

  @override
  String get searchFilterPrice200_300 => '200-300₪';

  @override
  String get searchFilterPrice300_500 => '300-500₪';

  @override
  String get searchFilterPriceOver500 => 'Plus de 500₪';

  @override
  String get searchFilterLanguage => 'Langue parlée';

  @override
  String get searchFilterLanguageAll => 'Toutes les langues';

  @override
  String get searchFeesLabel => 'Honoraires';

  @override
  String get searchBookNow => 'Réserver';

  @override
  String searchNextToday(String time) {
    return 'Prochain: aujourd\'hui à $time';
  }

  @override
  String searchNextTomorrow(String time) {
    return 'Prochain: demain à $time';
  }

  @override
  String searchNextInDays(int count) {
    return 'Prochain: dans $count jours';
  }

  @override
  String get onboardingStep1Title =>
      'Trouvez et réservez vos rendez-vous médicaux facilement';

  @override
  String get onboardingStep2Title => 'Échangez facilement avec vos praticiens';

  @override
  String get onboardingStep2Subtitle =>
      'Un échange simple, rapide et sécurisé.';

  @override
  String get onboardingStep3Title =>
      'Rappels et résumé de vos dernières consultations';

  @override
  String get onboardingStep3Subtitle =>
      'Recevez des rappels et retrouvez l’essentiel en un coup d’œil.';

  @override
  String get onboardingContinueButton => 'Continuer';

  @override
  String get onboardingStartButton => 'Commencer';

  @override
  String get healthTitle => 'Ma Santé';

  @override
  String get healthSubtitle => 'Gérez votre profil santé';

  @override
  String get healthProfileTitle => 'Profil santé';

  @override
  String get healthProfileSubtitle =>
      'Renseignez les informations clés (Israël)';

  @override
  String get healthProfileIntro =>
      'Ces informations nous aident à préparer vos soins en Israël (koupot holim, médecin traitant, allergies, etc.).';

  @override
  String get healthProfileSave => 'Enregistrer';

  @override
  String get healthProfileSavedSnack => 'Profil enregistré';

  @override
  String get healthProfileStepIdentity => 'Identité';

  @override
  String get healthProfileStepKupatHolim => 'Koupot holim';

  @override
  String get healthProfileStepMedical => 'Informations médicales';

  @override
  String get healthProfileStepEmergency => 'Contact d’urgence';

  @override
  String get healthProfileTeudatZehut => 'Teoudat zehout';

  @override
  String get healthProfileDateOfBirth => 'Date de naissance';

  @override
  String get healthProfileSex => 'Sexe';

  @override
  String get healthProfileSexFemale => 'Femme';

  @override
  String get healthProfileSexMale => 'Homme';

  @override
  String get healthProfileSexOther => 'Autre';

  @override
  String get healthProfileKupatHolim => 'Kupat holim';

  @override
  String get healthProfileKupatMemberId => 'N° adhérent';

  @override
  String get healthProfileFamilyDoctor => 'Médecin traitant';

  @override
  String get healthProfileEmergencyContactName => 'Nom du contact d’urgence';

  @override
  String get healthProfileEmergencyContactPhone =>
      'Téléphone du contact d’urgence';

  @override
  String get kupatClalit => 'Clalit';

  @override
  String get kupatMaccabi => 'Maccabi';

  @override
  String get kupatMeuhedet => 'Meuhedet';

  @override
  String get kupatLeumit => 'Leumit';

  @override
  String get kupatOther => 'Autre';

  @override
  String get healthMyFileSectionTitle => 'Mon dossier';

  @override
  String get healthDocumentsTitle => 'Documents';

  @override
  String get healthDocumentsSubtitle => 'Ordonnances, analyses, comptes-rendus';

  @override
  String get healthConditionsTitle => 'Conditions médicales';

  @override
  String get healthConditionsSubtitle => 'Antécédents et pathologies';

  @override
  String get healthMedicationsTitle => 'Médicaments';

  @override
  String get healthMedicationsSubtitle => 'Traitements en cours';

  @override
  String get healthAllergiesTitle => 'Allergies';

  @override
  String get healthAllergiesSubtitle => 'Allergies connues';

  @override
  String get healthVaccinationsTitle => 'Vaccinations';

  @override
  String get healthVaccinationsSubtitle => 'Historique vaccinal';

  @override
  String get healthUpToDateTitle => 'Vous êtes à jour';

  @override
  String get healthUpToDateSubtitle =>
      'Nous vous notifierons quand vous aurez de nouveaux rappels santé.';

  @override
  String get appointmentDetailTitle => 'Détails du rendez-vous';

  @override
  String get appointmentDetailCancelledSnack => 'Rendez-vous annulé';

  @override
  String get appointmentDetailNotFoundTitle => 'Rendez-vous introuvable';

  @override
  String get appointmentDetailNotFoundSubtitle =>
      'Ce RDV est indisponible ou annulé.';

  @override
  String get appointmentDetailReschedule => 'Replanifier';

  @override
  String get appointmentRescheduleTitle => 'Choisir une nouvelle date';

  @override
  String appointmentRescheduleSubtitle(String practitionerName) {
    return 'Sélectionnez un créneau disponible pour votre rendez-vous avec $practitionerName.';
  }

  @override
  String appointmentRescheduleCurrent(String date, String time) {
    return 'Actuellement : $date à $time';
  }

  @override
  String get appointmentRescheduleConfirm => 'Confirmer le changement';

  @override
  String get appointmentRescheduleSuccessSnack =>
      'Rendez-vous replanifié avec succès';

  @override
  String get appointmentDetailCancelQuestion => 'Annuler le rendez-vous ?';

  @override
  String get appointmentDetailPreparationTitle => 'Préparation requise';

  @override
  String get appointmentDetailPreparationSubtitle =>
      'Préparez votre consultation en avance.';

  @override
  String get appointmentDetailPrepQuestionnaire =>
      'Remplir le questionnaire santé';

  @override
  String get appointmentDetailPrepInstructions => 'Voir les instructions';

  @override
  String get appointmentPrepQuestionnaireSubtitle =>
      'Questionnaire standardisé (prêt backend)';

  @override
  String get appointmentPrepInstructionsSubtitle =>
      'Informations importantes avant la consultation';

  @override
  String get appointmentPrepQuestionSymptoms =>
      'Motif / symptômes (décrivez en quelques mots)';

  @override
  String get appointmentPrepQuestionAllergies => 'Allergies (optionnel)';

  @override
  String get appointmentPrepQuestionMedications =>
      'Traitements en cours (optionnel)';

  @override
  String get appointmentPrepQuestionOther =>
      'Informations complémentaires (optionnel)';

  @override
  String get appointmentPrepConsentLabel =>
      'J’accepte de partager ces informations avec le praticien';

  @override
  String get appointmentPrepConsentRequired =>
      'Veuillez accepter pour continuer.';

  @override
  String get appointmentPrepSavedSnack => 'Préparation enregistrée';

  @override
  String get appointmentPrepSubmit => 'Envoyer';

  @override
  String get appointmentPrepInstruction1 =>
      'Apportez une pièce d’identité et votre carte d’assurance.';

  @override
  String get appointmentPrepInstruction2 => 'Arrivez 10 minutes en avance.';

  @override
  String get appointmentPrepInstruction3 =>
      'Préparez vos documents médicaux importants.';

  @override
  String get appointmentPrepInstructionsAccept =>
      'J’ai lu et j’accepte ces instructions';

  @override
  String get appointmentDetailSendDocsTitle => 'Envoyer des documents';

  @override
  String get appointmentDetailSendDocsSubtitle =>
      'Envoyez des documents au praticien avant la consultation.';

  @override
  String get appointmentDetailAddDocs => 'Ajouter des documents';

  @override
  String get appointmentDetailEarlierSlotTitle =>
      'Vous voulez un créneau plus tôt ?';

  @override
  String get appointmentDetailEarlierSlotSubtitle =>
      'Recevez une alerte si un créneau plus tôt est disponible.';

  @override
  String get appointmentDetailEnableAlerts => 'Activer les alertes';

  @override
  String get appointmentDetailContactOffice => 'Contacter le cabinet';

  @override
  String get appointmentDetailVisitSummaryTitle => 'Résumé de la visite';

  @override
  String get appointmentDetailVisitSummarySubtitle =>
      'Ce qu’il faut retenir et la suite';

  @override
  String get appointmentDetailVisitSummaryDemo =>
      'Examen clinique réalisé. Suivi recommandé dans 3 mois et poursuite du traitement si nécessaire.';

  @override
  String get appointmentDetailDoctorReportTitle => 'Compte rendu du médecin';

  @override
  String get appointmentDetailDoctorReportSubtitle =>
      'Note médicale rédigée après la consultation';

  @override
  String get appointmentDetailDoctorReportDemo =>
      'Le patient s’est présenté pour une consultation. Aucun signe inquiétant. Suivi recommandé, et apport de documents pertinents au prochain rendez-vous.';

  @override
  String get appointmentDetailDocumentsAndRxTitle => 'Documents & ordonnance';

  @override
  String get appointmentDetailDocumentsAndRxSubtitle =>
      'Retrouvez les documents remis après la visite';

  @override
  String get appointmentDetailOpenVisitReport => 'Ouvrir le compte rendu';

  @override
  String get appointmentDetailOpenPrescription => 'Ouvrir l’ordonnance';

  @override
  String get appointmentDetailSendMessageCta => 'Envoyer un message au cabinet';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesMarkAllRead => 'Marquer tout comme lu';

  @override
  String get messagesEmptyTitle => 'Vos messages';

  @override
  String get messagesEmptySubtitle =>
      'Démarrez une conversation avec vos praticiens pour demander un document, poser une question ou suivre vos résultats.';

  @override
  String get messagesNewMessageTitle => 'Nouveau message';

  @override
  String get messagesWriteToOfficeTitle => 'Écrire au cabinet';

  @override
  String get messagesResponseTime => 'Réponse sous 24–48h.';

  @override
  String get messagesSubjectLabel => 'Objet';

  @override
  String get messagesSubjectHint => 'ex: Résultats, question…';

  @override
  String get messagesSubjectRequired => 'Objet requis';

  @override
  String get messagesMessageLabel => 'Message';

  @override
  String get messagesMessageHint => 'Écrivez votre message…';

  @override
  String get messagesSendButton => 'Envoyer';

  @override
  String get conversationTitle => 'Conversation';

  @override
  String get conversationNewMessageTooltip => 'Nouveau message';

  @override
  String get conversationWriteMessageHint => 'Écrire un message…';

  @override
  String get practitionerTitle => 'Praticien';

  @override
  String get practitionerUnavailableTitle => 'Praticien indisponible';

  @override
  String get practitionerNotFoundTitle => 'Praticien introuvable';

  @override
  String get practitionerNotFoundSubtitle => 'Ce profil est indisponible.';

  @override
  String get practitionerBookAppointment => 'Prendre rendez-vous';

  @override
  String get practitionerSendMessage => 'Envoyer un message';

  @override
  String get practitionerAvailabilities => 'Disponibilités';

  @override
  String get practitionerAddress => 'Adresse';

  @override
  String get practitionerProfileSection => 'Profil';

  @override
  String get practitionerTabAvailability => 'Disponibilité';

  @override
  String get practitionerTabReviews => 'Avis';

  @override
  String get practitionerMyAppointmentsWithDoctor =>
      'Mes rendez-vous avec ce docteur';

  @override
  String get practitionerNoAppointmentsWithDoctor =>
      'Aucun rendez-vous avec ce docteur';

  @override
  String get practitionerLoginToSeeHistory =>
      'Connectez-vous pour voir votre historique';

  @override
  String get practitionerNoReviews => 'Aucun avis pour le moment';

  @override
  String get practitionerCalendarLegendAvailable => 'Disponible';

  @override
  String get practitionerCalendarLegendSelected => 'Sélectionné';

  @override
  String get practitionerNoSlotsForDate =>
      'Aucun créneau disponible ce jour-là';

  @override
  String get practitionerYourAppointment => 'Votre rendez-vous';

  @override
  String get practitionerAddressAndContact => 'Adresse et contact';

  @override
  String get practitionerAppointmentStatusCompleted => 'Terminé';

  @override
  String get practitionerAppointmentStatusConfirmed => 'Confirmé';

  @override
  String get practitionerAppointmentStatusPending => 'En attente';

  @override
  String get practitionerAppointmentStatusCancelled => 'Annulé';

  @override
  String get practitionerAppointmentStatusNoShow => 'Absent';

  @override
  String get practitionerReviewAnonymous => 'Anonyme';

  @override
  String get practitionerLanguageHebrew => 'Hébreu';

  @override
  String get practitionerLanguageFrench => 'Français';

  @override
  String get practitionerLanguageEnglish => 'Anglais';

  @override
  String get practitionerLanguageRussian => 'Russe';

  @override
  String get practitionerLanguageSpanish => 'Espagnol';

  @override
  String get practitionerLanguageAmharic => 'Amharique';

  @override
  String get practitionerLanguageArabic => 'Arabe';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get documentsEmptyTitle => 'Aucun document';

  @override
  String get documentsEmptySubtitle =>
      'Vos ordonnances et résultats apparaîtront ici.';

  @override
  String get documentsOpen => 'Ouvrir';

  @override
  String get documentsShare => 'Partager';

  @override
  String get authLogout => 'Se déconnecter';

  @override
  String get authLoggingOut => 'Déconnexion…';

  @override
  String get authLogoutConfirmTitle => 'Déconnexion';

  @override
  String get authLogoutConfirmMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get authLogoutSuccess => 'Vous avez été déconnecté';

  @override
  String get authLoginSuccess => 'Bienvenue !';

  @override
  String get securityTitle => 'Sécurité';

  @override
  String get securitySecureAccountTitle => 'Sécurisez votre compte';

  @override
  String get securitySecureAccountSubtitle => 'Mettez à jour vos informations';

  @override
  String get securityChangePassword => 'Changer le mot de passe';

  @override
  String get securityChangePasswordSuccess =>
      'Mot de passe mis à jour. Connectez-vous avec votre nouveau mot de passe.';

  @override
  String get securityChangePasswordSendingCode =>
      'Envoi du code de vérification…';

  @override
  String get securityChangePasswordSendCodeHint =>
      'Un code à 6 chiffres sera envoyé à votre adresse email pour sécuriser le changement de mot de passe.';

  @override
  String get securityChangePasswordOtpLabel => 'Code à 6 chiffres';

  @override
  String get securityCurrentPassword => 'Mot de passe actuel';

  @override
  String get securityNewPassword => 'Nouveau mot de passe';

  @override
  String get accountTitle => 'Mon compte';

  @override
  String get accountTaglineTitle => 'Votre santé. Vos données.';

  @override
  String get accountTaglineSubtitle =>
      'Votre confidentialité est notre priorité.';

  @override
  String get accountPersonalInfoSection => 'Informations personnelles';

  @override
  String get accountMyProfile => 'Mon profil';

  @override
  String get accountMyRelatives => 'Mes proches';

  @override
  String get accountSectionTitle => 'Compte';

  @override
  String get privacyTitle => 'Confidentialité';

  @override
  String get privacyYourDataTitle => 'Vos données';

  @override
  String get privacyYourDataSubtitle =>
      'Nous protégeons vos informations et limitons leur accès.';

  @override
  String get privacySharingTitle => 'Partage';

  @override
  String get privacySharingSubtitle =>
      'Contrôlez les documents partagés avec vos praticiens.';

  @override
  String get privacyExportTitle => 'Export';

  @override
  String get privacyExportSubtitle => 'Exportez vos données à tout moment.';

  @override
  String get paymentTitle => 'Paiement';

  @override
  String get paymentEmptyTitle => 'Aucun moyen de paiement';

  @override
  String get paymentEmptySubtitle =>
      'Ajoutez une carte pour simplifier la facturation.';

  @override
  String paymentExpires(Object expiry) {
    return 'Expire $expiry';
  }

  @override
  String get relativesTitle => 'Mes proches';

  @override
  String get relativesEmptyTitle => 'Aucun proche';

  @override
  String get relativesEmptySubtitle =>
      'Ajoutez vos proches pour prendre RDV en leur nom.';

  @override
  String get settingsUnavailableTitle => 'Paramètres indisponibles';

  @override
  String get settingsUnavailableSubtitle =>
      'Impossible de charger vos préférences.';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsSubtitle =>
      'Recevoir des messages et mises à jour';

  @override
  String get settingsRemindersTitle => 'Rappels de rendez-vous';

  @override
  String get settingsRemindersSubtitle => 'Recevoir des rappels avant vos RDV';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsLanguageCurrentLabel => 'Français (actuel)';

  @override
  String get settingsLanguageShortLabel => 'Français';

  @override
  String get profileTitle => 'Mon profil';

  @override
  String get profileUnavailableTitle => 'Profil indisponible';

  @override
  String get profileUnavailableSubtitle =>
      'Vos informations sont indisponibles.';

  @override
  String get profileIdentitySection => 'Identité';

  @override
  String get commonName => 'Nom';

  @override
  String get commonAddress => 'Adresse';

  @override
  String get commonCity => 'Ville';

  @override
  String get profileMedicalInfoSection => 'Informations médicales';

  @override
  String get profileBloodType => 'Groupe sanguin';

  @override
  String get profileHeight => 'Taille';

  @override
  String get profileWeight => 'Poids';

  @override
  String get profileDangerZoneTitle => 'Zone dangereuse';

  @override
  String get profileDeleteAccountHint =>
      'Supprimez définitivement votre compte et toutes vos données.';

  @override
  String get profileDeleteAccountButton => 'Supprimer le compte';

  @override
  String get profileDeleteAccountDialogTitle => 'Supprimer le compte ?';

  @override
  String get profileDeleteAccountDialogBody =>
      'Votre compte et toutes les données associées seront supprimés définitivement. Cette action est irréversible.';

  @override
  String get profileDeleteAccountConfirm => 'Supprimer';

  @override
  String get profileDeleteAccountLoading => 'Suppression du compte…';

  @override
  String get profileAccountDeletedSnack =>
      'Compte supprimé. Vous avez été déconnecté.';

  @override
  String get errorUnableToDeleteAccount => 'Impossible de supprimer le compte.';

  @override
  String get bookingSelectPatientTitle => 'Pour qui est ce rendez-vous ?';

  @override
  String get bookingPatientsUnavailableTitle => 'Patients indisponibles';

  @override
  String get bookingAddRelative => 'Ajouter un proche';

  @override
  String get commonMe => 'moi';

  @override
  String get bookingSelectSlotTitle => 'Choisir une date';

  @override
  String get bookingSelectSlotSubtitle =>
      'Sélectionnez une date et un horaire disponibles.';

  @override
  String get bookingSeeMoreDates => 'Voir plus de dates';

  @override
  String get commonSelected => 'Sélectionné';

  @override
  String get bookingInstructionsTitle => 'Instructions';

  @override
  String get bookingInstructionsSubtitle =>
      'Avant le rendez-vous, merci de vérifier ces points.';

  @override
  String get bookingInstructionsBullet1 =>
      'Apportez votre carte vitale et votre ordonnance si besoin.';

  @override
  String get bookingInstructionsBullet2 =>
      'Arrivez 10 minutes en avance pour les formalités.';

  @override
  String get bookingInstructionsBullet3 =>
      'En cas d’annulation, prévenez dès que possible.';

  @override
  String get bookingInstructionsAccept =>
      'J’ai lu et j’accepte ces instructions.';

  @override
  String get bookingConfirmTitle => 'Confirmer le rendez-vous';

  @override
  String get bookingConfirmSubtitle =>
      'Vérifiez les informations avant de valider.';

  @override
  String get bookingReasonLabel => 'Motif';

  @override
  String get bookingPatientLabel => 'Patient';

  @override
  String get bookingSlotLabel => 'Créneau';

  @override
  String get bookingMissingInfoTitle => 'Informations manquantes';

  @override
  String get bookingZipCodeLabel => 'Code postal';

  @override
  String get bookingVisitedBeforeQuestion =>
      'Avez-vous déjà consulté ce praticien ?';

  @override
  String get commonYes => 'Oui';

  @override
  String get commonNo => 'Non';

  @override
  String get bookingConfirmButton => 'Confirmer le rendez-vous';

  @override
  String get bookingChangeSlotButton => 'Modifier le créneau';

  @override
  String get bookingQuickPatientSubtitle =>
      'Choisissez qui consultera le praticien.';

  @override
  String get bookingQuickConfirmSubtitle =>
      'Vérifiez les informations et confirmez.';

  @override
  String get bookingChangePatient => 'Changer de patient';

  @override
  String get commonLoading => 'Chargement…';

  @override
  String get bookingSuccessTitle => 'Rendez-vous confirmé';

  @override
  String get bookingSuccessSubtitle =>
      'Nous avons envoyé une confirmation à votre email.';

  @override
  String get bookingAddToCalendar => 'Ajouter à mon calendrier';

  @override
  String get bookingBookAnotherAppointment => 'Reprendre un rendez-vous';

  @override
  String get bookingSendDocsSubtitle =>
      'Envoyez des documents à votre praticien pour la consultation.';

  @override
  String get bookingViewMyAppointments => 'Voir mes rendez-vous';

  @override
  String get bookingBackToHome => 'Retour à l’accueil';

  @override
  String get vaccinationsEmptyTitle => 'Aucun vaccin enregistré';

  @override
  String get vaccinationsEmptySubtitle => 'Suivez vos vaccins et rappels.';

  @override
  String get allergiesEmptyTitle => 'Aucune allergie';

  @override
  String get allergiesEmptySubtitle =>
      'Déclarez vos allergies pour votre sécurité.';

  @override
  String get medicationsEmptyTitle => 'Aucun médicament';

  @override
  String get medicationsEmptySubtitle => 'Ajoutez vos traitements en cours.';

  @override
  String get conditionsEmptyTitle => 'Aucune condition';

  @override
  String get conditionsEmptySubtitle => 'Ajoutez vos antécédents pour vos RDV.';

  @override
  String get languageHebrew => 'עברית';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageAmharic => 'አማርኛ';

  @override
  String get errorGenericTryAgain => 'Une erreur est survenue. Réessayez.';

  @override
  String get authSignInFailedTryAgain => 'Connexion échouée. Réessayez.';

  @override
  String get authSignUpFailedTryAgain => 'Inscription échouée. Réessayez.';

  @override
  String get authOnlyPatientsAllowed =>
      'Seuls les patients sont autorisés à se connecter pour le moment.';

  @override
  String get errorUnableToConfirmAppointment =>
      'Impossible de confirmer le rendez-vous.';

  @override
  String get errorUnableToLoadProfile => 'Impossible de charger le profil.';

  @override
  String get errorUnableToRetrieveEmail =>
      'Impossible de récupérer votre adresse email.';

  @override
  String get errorUnableToReadHistoryState =>
      'Impossible de lire l\'état de l\'historique.';

  @override
  String get errorUnableToEnableHistory =>
      'Impossible d\'activer l\'historique.';

  @override
  String get errorUnableToLoadRelatives => 'Impossible de charger les proches.';

  @override
  String get errorUnableToAddRelative => 'Impossible d’ajouter un proche.';

  @override
  String get errorUnableToLoadPayments =>
      'Impossible de charger les paiements.';

  @override
  String get errorUnableToAddPaymentMethod =>
      'Impossible d’ajouter un moyen de paiement.';

  @override
  String get errorUnableToLoadHealthData =>
      'Impossible de charger les données santé.';

  @override
  String get errorUnableToAddHealthItem => 'Impossible d’ajouter un élément.';

  @override
  String get errorUnableToLoadHealthProfile =>
      'Impossible de charger le profil santé.';

  @override
  String get errorUnableToSaveHealthProfile =>
      'Impossible d’enregistrer le profil santé.';

  @override
  String get errorUnableToLoadPractitioner =>
      'Impossible de charger le praticien.';

  @override
  String get errorUnableToLoadSearch => 'Impossible de charger la recherche.';

  @override
  String get errorUnableToLoadDocuments =>
      'Impossible de charger les documents.';

  @override
  String get errorUnableToAddDocument => 'Impossible d’ajouter le document.';

  @override
  String get errorUnableToReadSettings => 'Impossible de lire les paramètres.';

  @override
  String get errorUnableToSaveSettings =>
      'Impossible de sauvegarder les paramètres.';

  @override
  String get errorUnableToLoadUpcomingAppointments =>
      'Impossible de charger les rendez-vous à venir.';

  @override
  String get errorUnableToLoadHistory => 'Impossible de charger l\'historique.';

  @override
  String get errorUnableToLoadAppointment =>
      'Impossible de charger le rendez-vous.';

  @override
  String get errorUnableToCancelAppointment =>
      'Impossible d\'annuler le rendez-vous.';

  @override
  String get errorUnableToRescheduleAppointment =>
      'Impossible de replanifier le rendez-vous.';

  @override
  String get errorUnableToLoadConversations =>
      'Impossible de charger les conversations.';

  @override
  String get errorUnableToLoadConversation =>
      'Impossible de charger la conversation.';

  @override
  String get errorUnableToSendMessage => 'Impossible d\'envoyer le message.';

  @override
  String get errorUnableToReadOnboardingState =>
      'Impossible de lire l\'état d\'onboarding.';

  @override
  String get errorUnableToSaveOnboarding =>
      'Impossible d\'enregistrer l\'onboarding.';

  @override
  String timeMinutesAgo(int minutes) {
    return 'il y a $minutes min';
  }

  @override
  String timeHoursAgo(int hours) {
    return 'il y a $hours h';
  }

  @override
  String timeDaysAgo(int days) {
    return 'il y a $days j';
  }

  @override
  String get demoDentalOfficeName => 'Cabinet dentaire';

  @override
  String get demoConversation1LastMessage =>
      'Bonjour, vos résultats sont disponibles...';

  @override
  String get demoConversation2LastMessage =>
      'Parfait, je vous envoie le document !';

  @override
  String get demoConversation3LastMessage => 'Merci pour votre visite !';

  @override
  String get demoAppointmentConsultation => 'Consultation';

  @override
  String get demoAppointmentFollowUp => 'Suivi médical';

  @override
  String get demoShortDateThu19Feb => 'Jeu 19 Fév';

  @override
  String get demoShortDateMon15Feb => 'Lun 15 Fév';

  @override
  String get demoMessage1_1 => 'Bonjour, comment pouvons-nous vous aider ?';

  @override
  String get demoMessage1_2 => 'Bonjour, je souhaite obtenir mon compte-rendu.';

  @override
  String get demoMessage1_3 =>
      'Bien sûr, pouvez-vous préciser la date du rendez-vous ?';

  @override
  String get demoMessage2_1 => 'Bonjour, votre dossier est à jour.';

  @override
  String get demoMessage3_1 => 'Bonjour !';

  @override
  String get demoMessage3_2 => 'Merci docteur.';

  @override
  String get relativeRelation => 'Proche';

  @override
  String get relativeChild => 'Enfant';

  @override
  String get relativeParent => 'Parent';

  @override
  String relativeDemoName(int index) {
    return 'Proche $index';
  }

  @override
  String relativeLabel(Object relation, int year) {
    return '$relation • $year';
  }

  @override
  String documentsDemoTitle(int index) {
    return 'Document $index';
  }

  @override
  String get documentsDemoTypeLabel => 'Compte-rendu';

  @override
  String get documentsDemoDateLabelToday => 'Aujourd’hui';

  @override
  String get demoSpecialtyOphthalmologist => 'Ophtalmologiste';

  @override
  String get demoSpecialtyGeneralPractitioner => 'Médecin généraliste';

  @override
  String get demoPractitionerAbout =>
      'L’ophtalmologue traite les maladies de l’œil, et prend en charge la réfraction, le strabisme, et les troubles de la vision.\n\nCe profil est prêt à être branché au backend.';

  @override
  String demoAvailabilityTodayAt(Object time) {
    return 'Aujourd’hui • $time';
  }

  @override
  String demoAvailabilityTomorrowAt(Object time) {
    return 'Demain • $time';
  }

  @override
  String demoAvailabilityThisWeekAt(Object time) {
    return 'Cette semaine • $time';
  }

  @override
  String demoSearchPractitionerName(int index) {
    return 'Dr Practicien $index';
  }

  @override
  String get demoSearchAddress => '75019 Paris • Avenue Secrétan';

  @override
  String get demoSearchSector1 => 'Secteur 1';

  @override
  String get demoAvailabilityToday => 'Aujourd’hui';

  @override
  String get demoAvailabilityThisWeek => 'Cette semaine';

  @override
  String get demoDistance12km => '1,2 km';

  @override
  String get demoAppointmentDateThu19Feb => 'Jeudi 19 Février';

  @override
  String get demoAppointmentReasonNewPatientConsultation =>
      'Consultation (nouveau patient)';

  @override
  String get demoPractitionerNameMarc => 'Dr Marc BENHAMOU';

  @override
  String get demoPractitionerNameSarah => 'Dr Sarah COHEN';

  @override
  String get demoPractitionerNameNoam => 'Dr Noam LEVI';

  @override
  String get demoPractitionerNameMarcShort => 'Dr Marc B.';

  @override
  String get demoPractitionerNameSophie => 'Dr Sophie L.';

  @override
  String get demoPatientNameTom => 'Tom';

  @override
  String get demoAddressParis => '28, avenue Secrétan, 75019 Paris';

  @override
  String get demoProfileFullName => 'Tom Jami';

  @override
  String get demoProfileEmail => 'tom@domaine.com';

  @override
  String get demoProfileCity => '75019 Paris';

  @override
  String get demoPaymentBrandVisa => 'Visa';

  @override
  String get commonInitialsFallback => 'MO';

  @override
  String get navHome => 'Accueil';

  @override
  String get navAppointments => 'Rendez-vous';

  @override
  String get navHealth => 'Santé';

  @override
  String get navMessages => 'Messages';

  @override
  String get navAccount => 'Compte';
}
