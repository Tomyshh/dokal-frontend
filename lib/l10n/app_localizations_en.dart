// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonError => 'Error';

  @override
  String get commonEmail => 'Email';

  @override
  String get commonEmailHint => 'e.g. name@domain.com';

  @override
  String get commonEmailRequired => 'Email required';

  @override
  String get commonEmailInvalid => 'Invalid email';

  @override
  String get commonPassword => 'Password';

  @override
  String get commonPasswordHint => '••••••••';

  @override
  String get commonPasswordRequired => 'Password required';

  @override
  String commonPasswordMinChars(int min) {
    return 'Minimum $min characters';
  }

  @override
  String get authLoginTitle => 'Sign in';

  @override
  String get authLoginSubtitle =>
      'Access your appointments, messages and documents.';

  @override
  String get authLoginButton => 'Sign in';

  @override
  String get authForgotPasswordCta => 'Forgot password?';

  @override
  String get authCreateAccountCta => 'Create an account';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithoutAccount => 'Continue without an account';

  @override
  String get authRegisterTitle => 'Create an account';

  @override
  String get authRegisterSubtitle => 'All fields are required.';

  @override
  String get authFirstName => 'First name';

  @override
  String get authLastName => 'Last name';

  @override
  String get profileCompletionTitle => 'Complete your profile';

  @override
  String get profileCompletionSubtitle =>
      'These details are required to continue.';

  @override
  String profileCompletionStepLabel(int current, int total) {
    return '$current/$total';
  }

  @override
  String get profileCompletionStepIdentityTitle => 'Identity';

  @override
  String get profileCompletionStepIdentitySubtitle => 'Tell us who you are.';

  @override
  String get profileCompletionDateOfBirth => 'Date of birth';

  @override
  String get profileCompletionCity => 'City (optional)';

  @override
  String get profileCompletionSex => 'Sex (optional)';

  @override
  String get profileCompletionSexMale => 'Male';

  @override
  String get profileCompletionSexFemale => 'Female';

  @override
  String get profileCompletionSexOther => 'Other';

  @override
  String get profileCompletionAvatar => 'Profile photo (optional)';

  @override
  String get profileCompletionStepContactTitle => 'Contact';

  @override
  String get profileCompletionStepContactSubtitle => 'How can we reach you?';

  @override
  String get profileCompletionEmailLockedHint =>
      'Your email is linked to your account and cannot be changed here.';

  @override
  String get profileCompletionPhone => 'Phone number';

  @override
  String get profileCompletionPhoneHint => 'e.g. +972 50 123 4567';

  @override
  String get profileCompletionPhoneInvalid => 'Invalid phone number';

  @override
  String get profileCompletionStepIsraelTitle => 'Israel';

  @override
  String get profileCompletionStepIsraelSubtitle =>
      'Required info for care in Israel.';

  @override
  String get profileCompletionTeudatHint => '9 digits';

  @override
  String get profileCompletionTeudatInvalid => 'Invalid ID number';

  @override
  String get profileCompletionStepInsuranceTitle => 'Insurance';

  @override
  String get profileCompletionStepInsuranceSubtitle =>
      'Optional (you can skip).';

  @override
  String get profileCompletionInsurance => 'Insurance provider';

  @override
  String get profileCompletionInsuranceNone => 'No insurance / skip';

  @override
  String get profileCompletionInsuranceOptionalHint =>
      'Insurance is optional. You can add it later in your settings.';

  @override
  String get profileCompletionFinish => 'Finish';

  @override
  String get commonRequired => 'Required';

  @override
  String get commonContinue => 'Continue';

  @override
  String get authAlreadyHaveAccount => 'I already have an account';

  @override
  String get authForgotPasswordTitle => 'Forgot password';

  @override
  String get authForgotPasswordSubtitle =>
      'We\'ll send you a 6-digit code by email.';

  @override
  String get authForgotPasswordSendLink => 'Send code';

  @override
  String get authBackToLogin => 'Back to sign in';

  @override
  String get authForgotPasswordEmailSent => 'Code sent. Check your inbox.';

  @override
  String get authResetPasswordVerifyTitle => 'Enter the code';

  @override
  String authResetPasswordVerifyDescription(Object email) {
    return 'We sent a 6-digit code to $email. Enter it to continue.';
  }

  @override
  String get authResetPasswordNewTitle => 'New password';

  @override
  String get authResetPasswordNewSubtitle => 'Choose a new password.';

  @override
  String get authResetPasswordConfirmPassword => 'Confirm password';

  @override
  String get authResetPasswordPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authResetPasswordUpdateButton => 'Update password';

  @override
  String get authResetPasswordUpdatedSnack =>
      'Password updated. You can sign in again.';

  @override
  String get authVerifyEmailTitle => 'Verify your email';

  @override
  String authVerifyEmailDescription(Object email) {
    return 'We sent a 6-digit code to $email. Enter it below.';
  }

  @override
  String get authVerifyEmailOtpHint => '000000';

  @override
  String get authVerifyEmailVerify => 'Verify';

  @override
  String get authVerifyEmailCheckedBackToLogin =>
      'I\'ve verified it, back to sign in';

  @override
  String get authVerifyEmailResend => 'Resend code';

  @override
  String get authVerifyEmailResentSnack => 'Confirmation code resent.';

  @override
  String get commonBack => 'Back';

  @override
  String get homeMyPractitioners => 'My practitioners';

  @override
  String get homeHistory => 'History';

  @override
  String homeGreeting(Object name) {
    return 'Hello $name';
  }

  @override
  String get homeGreetingGuest => 'Hello!';

  @override
  String get homeSearchHint => 'Practitioner, specialty...';

  @override
  String get homeHealthTip1 => 'This year, adopt healthy habits.';

  @override
  String get homeHealthTip2 => 'It\'s not too late to get vaccinated.';

  @override
  String get homeCompleteHealthProfile => 'Complete your health profile';

  @override
  String get homeCompleteHealthProfileSubtitle =>
      'Get personalized reminders and prepare your appointments';

  @override
  String get homeStart => 'Get started';

  @override
  String get homeNoRecentPractitioner => 'No recent practitioner';

  @override
  String get homeHistoryDescription =>
      'You can view the list of practitioners you have consulted';

  @override
  String get homeHistoryEnabledSnack => 'History enabled';

  @override
  String get homeHistoryEnabled => 'History enabled';

  @override
  String get homeActivateHistory => 'Enable history';

  @override
  String homeNewMessageTitle(Object name) {
    return 'You have a new message from Dr $name';
  }

  @override
  String get homeNewMessageNoAppointment => 'No related appointment';

  @override
  String get homeUpcomingAppointmentsTitle => 'Upcoming appointments';

  @override
  String get homeNoUpcomingAppointments =>
      'No upcoming appointments at the moment';

  @override
  String get homeFindAppointmentCta => 'Find an appointment';

  @override
  String get homeNoAppointmentsEmptyDescription =>
      'You don’t have any appointments yet. Search for a practitioner and book your first slot.';

  @override
  String get homeLast3AppointmentsTitle => 'Last 3 appointments';

  @override
  String get homeSeeAllPastAppointments => 'See';

  @override
  String get homeAppointmentHistoryTitle => 'Appointment history';

  @override
  String get homeNoAppointmentHistory => 'No past appointments';

  @override
  String get commonTryAgainLater => 'Try again later.';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonUnableToLoad => 'Unable to load';

  @override
  String get commonAvailableSoon => 'Available soon';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonActionIsFinal => 'This action is final.';

  @override
  String get commonTodo => 'To do';

  @override
  String get commonToRead => 'To read';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonTryAgainInAMoment => 'Try again in a moment.';

  @override
  String commonMinChars(int min) {
    return 'Minimum $min characters';
  }

  @override
  String get commonOnline => 'Online';

  @override
  String get appointmentsTitle => 'My appointments';

  @override
  String get appointmentsTabUpcoming => 'Upcoming';

  @override
  String get appointmentsTabPast => 'Past';

  @override
  String get appointmentsNoUpcomingTitle => 'No upcoming appointments';

  @override
  String get appointmentsNoUpcomingSubtitle =>
      'Your next appointments will appear here.';

  @override
  String get appointmentsNoPastTitle => 'No past appointments';

  @override
  String get appointmentsNoPastSubtitle =>
      'Your completed appointments will appear here.';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Practitioner, specialty...';

  @override
  String get searchUnavailableTitle => 'Search unavailable';

  @override
  String get searchNoResultsTitle => 'No results';

  @override
  String get searchNoResultsSubtitle => 'Try a different term.';

  @override
  String get searchFilterTitle => 'Filter results';

  @override
  String get searchFilterDate => 'Availability date';

  @override
  String get searchFilterDateToday => 'Today';

  @override
  String get searchFilterDateTomorrow => 'Tomorrow';

  @override
  String get searchFilterDateThisWeek => 'This week';

  @override
  String get searchFilterDateNextWeek => 'Next week';

  @override
  String get searchFilterDateAny => 'Any date';

  @override
  String get searchFilterSpecialty => 'Specialty';

  @override
  String get searchFilterSpecialtyAll => 'All specialties';

  @override
  String get searchFilterKupatHolim => 'Health fund';

  @override
  String get searchFilterKupatHolimAll => 'All funds';

  @override
  String get searchFilterDistance => 'Maximum distance';

  @override
  String get searchFilterDistanceAny => 'No limit';

  @override
  String get searchFilterApply => 'Apply filters';

  @override
  String get searchFilterReset => 'Clear all';

  @override
  String searchFilterActiveCount(int count) {
    return '$count active filters';
  }

  @override
  String get searchSortTitle => 'Sort by';

  @override
  String get searchSortAvailability => 'Availability';

  @override
  String get searchSortAvailabilitySubtitle => 'Most available first';

  @override
  String get searchSortDistance => 'Distance';

  @override
  String get searchSortDistanceSubtitle => 'Nearest first';

  @override
  String get searchSortName => 'Name';

  @override
  String get searchSortNameSubtitle => 'Alphabetical order';

  @override
  String get searchSortRating => 'Rating';

  @override
  String get searchSortRatingSubtitle => 'Highest rated first';

  @override
  String get searchSortPrice => 'Price';

  @override
  String get searchSortPriceSubtitle => 'Most expensive first';

  @override
  String get searchFilterPrice => 'Price range';

  @override
  String get searchFilterPriceAll => 'All prices';

  @override
  String get searchFilterPriceUnder200 => 'Under 200₪';

  @override
  String get searchFilterPrice200_300 => '200-300₪';

  @override
  String get searchFilterPrice300_500 => '300-500₪';

  @override
  String get searchFilterPriceOver500 => 'Over 500₪';

  @override
  String get searchFilterLanguage => 'Spoken language';

  @override
  String get searchFilterLanguageAll => 'All languages';

  @override
  String get searchFeesLabel => 'Fees';

  @override
  String get searchBookNow => 'Book Now';

  @override
  String searchNextToday(String time) {
    return 'Next: today at $time';
  }

  @override
  String searchNextTomorrow(String time) {
    return 'Next: tomorrow at $time';
  }

  @override
  String searchNextInDays(int count) {
    return 'Next: in $count days';
  }

  @override
  String get onboardingStep1Title =>
      'Find and book medical appointments easily';

  @override
  String get onboardingStep2Title => 'Chat easily with your practitioners';

  @override
  String get onboardingStep2Subtitle =>
      'Secure, fast messaging with your doctors.';

  @override
  String get onboardingStep3Title =>
      'Reminders and summary of your recent consultations';

  @override
  String get onboardingStep3Subtitle =>
      'Never miss a visit—get reminders and quick summaries.';

  @override
  String get onboardingContinueButton => 'Continue';

  @override
  String get onboardingStartButton => 'Get started';

  @override
  String get healthTitle => 'My health';

  @override
  String get healthSubtitle => 'Manage your health profile';

  @override
  String get healthProfileTitle => 'Health profile';

  @override
  String get healthProfileSubtitle => 'Fill in key info (Israel)';

  @override
  String get healthProfileIntro =>
      'This information helps us prepare your care in Israel (HMO, family doctor, allergies, etc.).';

  @override
  String get healthProfileSave => 'Save';

  @override
  String get healthProfileSavedSnack => 'Profile saved';

  @override
  String get healthProfileStepIdentity => 'Identity';

  @override
  String get healthProfileStepKupatHolim => 'HMO';

  @override
  String get healthProfileStepMedical => 'Medical info';

  @override
  String get healthProfileStepEmergency => 'Emergency contact';

  @override
  String get healthProfileTeudatZehut => 'ID number';

  @override
  String get healthProfileDateOfBirth => 'Date of birth';

  @override
  String get healthProfileSex => 'Sex';

  @override
  String get healthProfileSexFemale => 'Female';

  @override
  String get healthProfileSexMale => 'Male';

  @override
  String get healthProfileSexOther => 'Other';

  @override
  String get healthProfileKupatHolim => 'HMO';

  @override
  String get healthProfileKupatMemberId => 'Member ID';

  @override
  String get healthProfileFamilyDoctor => 'Family doctor';

  @override
  String get healthProfileEmergencyContactName => 'Emergency contact name';

  @override
  String get healthProfileEmergencyContactPhone => 'Emergency contact phone';

  @override
  String get kupatClalit => 'Clalit';

  @override
  String get kupatMaccabi => 'Maccabi';

  @override
  String get kupatMeuhedet => 'Meuhedet';

  @override
  String get kupatLeumit => 'Leumit';

  @override
  String get kupatOther => 'Other';

  @override
  String get healthMyFileSectionTitle => 'My file';

  @override
  String get healthDocumentsTitle => 'Documents';

  @override
  String get healthDocumentsSubtitle => 'Prescriptions, tests, reports';

  @override
  String get healthConditionsTitle => 'Medical conditions';

  @override
  String get healthConditionsSubtitle => 'History and conditions';

  @override
  String get healthMedicationsTitle => 'Medications';

  @override
  String get healthMedicationsSubtitle => 'Current treatments';

  @override
  String get healthAllergiesTitle => 'Allergies';

  @override
  String get healthAllergiesSubtitle => 'Known allergies';

  @override
  String get healthVaccinationsTitle => 'Vaccinations';

  @override
  String get healthVaccinationsSubtitle => 'Vaccination history';

  @override
  String get healthUpToDateTitle => 'You\'re up to date';

  @override
  String get healthUpToDateSubtitle =>
      'We\'ll notify you when you have new health reminders.';

  @override
  String get appointmentDetailTitle => 'Appointment details';

  @override
  String get appointmentDetailCancelledSnack => 'Appointment cancelled';

  @override
  String get appointmentDetailNotFoundTitle => 'Appointment not found';

  @override
  String get appointmentDetailNotFoundSubtitle =>
      'This appointment is unavailable or cancelled.';

  @override
  String get appointmentDetailReschedule => 'Reschedule';

  @override
  String get appointmentRescheduleTitle => 'Choose a new date';

  @override
  String appointmentRescheduleSubtitle(String practitionerName) {
    return 'Select an available slot for your appointment with $practitionerName.';
  }

  @override
  String appointmentRescheduleCurrent(String date, String time) {
    return 'Currently: $date at $time';
  }

  @override
  String get appointmentRescheduleConfirm => 'Confirm change';

  @override
  String get appointmentRescheduleSuccessSnack =>
      'Appointment rescheduled successfully';

  @override
  String get appointmentDetailCancelQuestion => 'Cancel the appointment?';

  @override
  String get appointmentDetailPreparationTitle => 'Preparation required';

  @override
  String get appointmentDetailPreparationSubtitle =>
      'Prepare your visit in advance.';

  @override
  String get appointmentDetailPrepQuestionnaire =>
      'Fill out the health questionnaire';

  @override
  String get appointmentDetailPrepInstructions => 'View instructions';

  @override
  String get appointmentPrepQuestionnaireSubtitle =>
      'Standardized questionnaire (backend-ready)';

  @override
  String get appointmentPrepInstructionsSubtitle =>
      'Important information before the visit';

  @override
  String get appointmentPrepQuestionSymptoms =>
      'Reason / symptoms (briefly describe)';

  @override
  String get appointmentPrepQuestionAllergies => 'Allergies (optional)';

  @override
  String get appointmentPrepQuestionMedications =>
      'Current medications (optional)';

  @override
  String get appointmentPrepQuestionOther =>
      'Additional information (optional)';

  @override
  String get appointmentPrepConsentLabel =>
      'I agree to share this information with the practitioner';

  @override
  String get appointmentPrepConsentRequired => 'Please accept to continue.';

  @override
  String get appointmentPrepSavedSnack => 'Preparation saved';

  @override
  String get appointmentPrepSubmit => 'Submit';

  @override
  String get appointmentPrepInstruction1 =>
      'Bring an ID and your insurance card.';

  @override
  String get appointmentPrepInstruction2 => 'Arrive 10 minutes early.';

  @override
  String get appointmentPrepInstruction3 =>
      'Prepare your important medical documents.';

  @override
  String get appointmentPrepInstructionsAccept =>
      'I have read and accept these instructions';

  @override
  String get appointmentDetailSendDocsTitle => 'Send documents';

  @override
  String get appointmentDetailSendDocsSubtitle =>
      'Send documents to the practitioner before the appointment.';

  @override
  String get appointmentDetailAddDocs => 'Add documents';

  @override
  String get appointmentDetailEarlierSlotTitle => 'Want an earlier slot?';

  @override
  String get appointmentDetailEarlierSlotSubtitle =>
      'Get an alert if an earlier slot becomes available.';

  @override
  String get appointmentDetailEnableAlerts => 'Enable alerts';

  @override
  String get appointmentDetailContactOffice => 'Contact the office';

  @override
  String get appointmentDetailVisitSummaryTitle => 'Visit summary';

  @override
  String get appointmentDetailVisitSummarySubtitle =>
      'Key takeaways and next steps';

  @override
  String get appointmentDetailVisitSummaryDemo =>
      'Clinical exam completed. Follow-up recommended in 3 months and continue treatment as needed.';

  @override
  String get appointmentDetailDoctorReportTitle => 'Doctor\'s report';

  @override
  String get appointmentDetailDoctorReportSubtitle =>
      'Medical note written after the visit';

  @override
  String get appointmentDetailDoctorReportDemo =>
      'The patient came for a consultation. No concerning findings. Follow-up recommended and bring relevant documents to the next appointment.';

  @override
  String get appointmentDetailDocumentsAndRxTitle => 'Documents & prescription';

  @override
  String get appointmentDetailDocumentsAndRxSubtitle =>
      'Find the documents shared after your visit';

  @override
  String get appointmentDetailOpenVisitReport => 'Open visit report';

  @override
  String get appointmentDetailOpenPrescription => 'Open prescription';

  @override
  String get appointmentDetailSendMessageCta => 'Message the office';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesMarkAllRead => 'Mark all as read';

  @override
  String get messagesEmptyTitle => 'Your messages';

  @override
  String get messagesEmptySubtitle =>
      'Start a conversation with your practitioners to request a document, ask a question, or follow your results.';

  @override
  String get messagesNewMessageTitle => 'New message';

  @override
  String get messagesWriteToOfficeTitle => 'Write to the office';

  @override
  String get messagesResponseTime => 'Reply within 24–48h.';

  @override
  String get messagesSubjectLabel => 'Subject';

  @override
  String get messagesSubjectHint => 'e.g. Results, question…';

  @override
  String get messagesSubjectRequired => 'Subject required';

  @override
  String get messagesMessageLabel => 'Message';

  @override
  String get messagesMessageHint => 'Write your message…';

  @override
  String get messagesSendButton => 'Send';

  @override
  String get conversationTitle => 'Conversation';

  @override
  String get conversationNewMessageTooltip => 'New message';

  @override
  String get conversationWriteMessageHint => 'Write a message…';

  @override
  String get practitionerTitle => 'Practitioner';

  @override
  String get practitionerUnavailableTitle => 'Practitioner unavailable';

  @override
  String get practitionerNotFoundTitle => 'Practitioner not found';

  @override
  String get practitionerNotFoundSubtitle => 'This profile is unavailable.';

  @override
  String get practitionerBookAppointment => 'Book an appointment';

  @override
  String get practitionerSendMessage => 'Send a message';

  @override
  String get practitionerAvailabilities => 'Availability';

  @override
  String get practitionerAddress => 'Address';

  @override
  String get practitionerProfileSection => 'Profile';

  @override
  String get practitionerTabAvailability => 'Availability';

  @override
  String get practitionerTabReviews => 'Reviews';

  @override
  String get practitionerMyAppointmentsWithDoctor =>
      'My appointments with this doctor';

  @override
  String get practitionerNoAppointmentsWithDoctor =>
      'No appointments with this doctor';

  @override
  String get practitionerLoginToSeeHistory => 'Log in to see your history';

  @override
  String get practitionerNoReviews => 'No reviews yet';

  @override
  String get practitionerCalendarLegendAvailable => 'Available';

  @override
  String get practitionerCalendarLegendSelected => 'Selected';

  @override
  String get practitionerNoSlotsForDate => 'No slots available for this date';

  @override
  String get practitionerYourAppointment => 'Your appointment';

  @override
  String get practitionerAddressAndContact => 'Address & contact';

  @override
  String get practitionerAppointmentStatusCompleted => 'Completed';

  @override
  String get practitionerAppointmentStatusConfirmed => 'Confirmed';

  @override
  String get practitionerAppointmentStatusPending => 'Pending';

  @override
  String get practitionerAppointmentStatusCancelled => 'Cancelled';

  @override
  String get practitionerAppointmentStatusNoShow => 'No show';

  @override
  String get practitionerReviewAnonymous => 'Anonymous';

  @override
  String get practitionerLanguageHebrew => 'Hebrew';

  @override
  String get practitionerLanguageFrench => 'French';

  @override
  String get practitionerLanguageEnglish => 'English';

  @override
  String get practitionerLanguageRussian => 'Russian';

  @override
  String get practitionerLanguageSpanish => 'Spanish';

  @override
  String get practitionerLanguageAmharic => 'Amharic';

  @override
  String get practitionerLanguageArabic => 'Arabic';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get documentsEmptyTitle => 'No documents';

  @override
  String get documentsEmptySubtitle =>
      'Your prescriptions and results will appear here.';

  @override
  String get documentsOpen => 'Open';

  @override
  String get documentsShare => 'Share';

  @override
  String get authLogout => 'Log out';

  @override
  String get authLoggingOut => 'Logging out…';

  @override
  String get authLogoutConfirmTitle => 'Log out';

  @override
  String get authLogoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get authLogoutSuccess => 'You\'ve been logged out';

  @override
  String get authLoginSuccess => 'Welcome back!';

  @override
  String get securityTitle => 'Security';

  @override
  String get securitySecureAccountTitle => 'Secure your account';

  @override
  String get securitySecureAccountSubtitle => 'Update your information';

  @override
  String get securityChangePassword => 'Change password';

  @override
  String get securityChangePasswordSuccess => 'Password updated.';

  @override
  String get securityChangePasswordSendingCode => 'Sending verification code…';

  @override
  String get securityChangePasswordSendCodeHint =>
      'A 6-digit code will be sent to your email address to secure the password change.';

  @override
  String get securityChangePasswordOtpLabel => '6-digit code';

  @override
  String get securityCurrentPassword => 'Current password';

  @override
  String get securityNewPassword => 'New password';

  @override
  String get accountTitle => 'My account';

  @override
  String get accountTaglineTitle => 'Your health. Your data.';

  @override
  String get accountTaglineSubtitle => 'Your privacy is our priority.';

  @override
  String get accountPersonalInfoSection => 'Personal information';

  @override
  String get accountMyProfile => 'My profile';

  @override
  String get accountMyRelatives => 'My relatives';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacyYourDataTitle => 'Your data';

  @override
  String get privacyYourDataSubtitle =>
      'We protect your information and limit access to it.';

  @override
  String get privacySharingTitle => 'Sharing';

  @override
  String get privacySharingSubtitle =>
      'Control the documents shared with your practitioners.';

  @override
  String get privacyExportTitle => 'Export';

  @override
  String get privacyExportSubtitle => 'Export your data at any time.';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentEmptyTitle => 'No payment method';

  @override
  String get paymentEmptySubtitle => 'Add a card to simplify billing.';

  @override
  String paymentExpires(Object expiry) {
    return 'Expires $expiry';
  }

  @override
  String get relativesTitle => 'My relatives';

  @override
  String get relativesEmptyTitle => 'No relative';

  @override
  String get relativesEmptySubtitle =>
      'Add your relatives to book appointments on their behalf.';

  @override
  String get addRelativeTitle => 'Add a relative';

  @override
  String get addRelativeSubtitle =>
      'Enter the information of the person you are booking for.';

  @override
  String get addRelativeFirstNameHint => 'First name';

  @override
  String get addRelativeLastNameHint => 'Last name';

  @override
  String get addRelativeTeudatHint => '9 digits';

  @override
  String get addRelativeKupatOptional => 'Optional';

  @override
  String get addRelativeInsuranceLabel => 'Insurance';

  @override
  String get addRelativeInsuranceHint => 'Supplementary insurance (optional)';

  @override
  String get addRelativeOptionalSection => 'Optional information';

  @override
  String get addRelativeSubmitButton => 'Add';

  @override
  String get addRelativeSuccess => 'Relative added successfully.';

  @override
  String get editRelativeTitle => 'Edit relative';

  @override
  String get editRelativeSaveButton => 'Save';

  @override
  String get editRelativeDeleteButton => 'Delete';

  @override
  String get editRelativeDeleteTitle => 'Delete this relative?';

  @override
  String get editRelativeDeleteMessage => 'This action cannot be undone.';

  @override
  String get editRelativeDeleteConfirm => 'Delete';

  @override
  String get editRelativeUpdateSuccess => 'Relative updated.';

  @override
  String get editRelativeDeleteSuccess => 'Relative deleted.';

  @override
  String get relativesMeCardLabel => 'Me';

  @override
  String get settingsUnavailableTitle => 'Settings unavailable';

  @override
  String get settingsUnavailableSubtitle => 'Unable to load your preferences.';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsSubtitle => 'Receive messages and updates';

  @override
  String get settingsRemindersTitle => 'Appointment reminders';

  @override
  String get settingsRemindersSubtitle =>
      'Receive reminders before your appointments';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageCurrentLabel => 'English (current)';

  @override
  String get settingsLanguageShortLabel => 'English';

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileUnavailableTitle => 'Profile unavailable';

  @override
  String get profileUnavailableSubtitle => 'Your information is unavailable.';

  @override
  String get profileIdentitySection => 'Identity';

  @override
  String get commonName => 'Name';

  @override
  String get commonAddress => 'Address';

  @override
  String get commonCity => 'City';

  @override
  String get profileMedicalInfoSection => 'Medical information';

  @override
  String get profileBloodType => 'Blood type';

  @override
  String get profileHeight => 'Height';

  @override
  String get profileWeight => 'Weight';

  @override
  String get profileDangerZoneTitle => 'Danger zone';

  @override
  String get profileDeleteAccountHint =>
      'Permanently delete your account and all your data.';

  @override
  String get profileDeleteAccountButton => 'Delete account';

  @override
  String get profileDeleteAccountDialogTitle => 'Delete account?';

  @override
  String get profileDeleteAccountDialogBody =>
      'Your account and all associated data will be permanently deleted. This action cannot be undone.';

  @override
  String get profileDeleteAccountConfirm => 'Delete';

  @override
  String get profileDeleteAccountLoading => 'Deleting account…';

  @override
  String get profileAccountDeletedSnack =>
      'Account deleted. You have been logged out.';

  @override
  String get profileNameUpdatedSuccess => 'Name updated.';

  @override
  String get errorUnableToDeleteAccount => 'Unable to delete the account.';

  @override
  String get bookingSelectPatientTitle => 'Who is this appointment for?';

  @override
  String get bookingPatientsUnavailableTitle => 'Patients unavailable';

  @override
  String get bookingAddRelative => 'Add a relative';

  @override
  String get commonMe => 'me';

  @override
  String get bookingSelectSlotTitle => 'Choose a date';

  @override
  String get bookingSelectSlotSubtitle => 'Select an available date and time.';

  @override
  String get bookingSeeMoreDates => 'See more dates';

  @override
  String get commonSelected => 'Selected';

  @override
  String get bookingInstructionsTitle => 'Instructions';

  @override
  String get bookingInstructionsSubtitle =>
      'Before the appointment, please check these points.';

  @override
  String get bookingInstructionsBullet1 =>
      'Bring your insurance card and prescription if needed.';

  @override
  String get bookingInstructionsBullet2 =>
      'Arrive 10 minutes early for administrative formalities.';

  @override
  String get bookingInstructionsBullet3 =>
      'In case of cancellation, please inform us as soon as possible.';

  @override
  String get bookingInstructionsAccept =>
      'I have read and accept these instructions.';

  @override
  String get bookingConfirmTitle => 'Confirm the appointment';

  @override
  String get bookingConfirmSubtitle =>
      'Check the information before confirming.';

  @override
  String get bookingReasonLabel => 'Reason';

  @override
  String get bookingPatientLabel => 'Patient';

  @override
  String get bookingSlotLabel => 'Slot';

  @override
  String get bookingMissingInfoTitle => 'Missing information';

  @override
  String get bookingZipCodeLabel => 'ZIP code';

  @override
  String get bookingVisitedBeforeQuestion =>
      'Have you already seen this practitioner?';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get bookingConfirmButton => 'Confirm appointment';

  @override
  String get bookingChangeSlotButton => 'Change slot';

  @override
  String get bookingQuickPatientSubtitle =>
      'Choose who will see the practitioner.';

  @override
  String get bookingQuickConfirmSubtitle => 'Verify the details and confirm.';

  @override
  String get bookingChangePatient => 'Change patient';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get bookingSuccessTitle => 'Appointment confirmed';

  @override
  String get bookingSuccessSubtitle => 'We sent a confirmation to your email.';

  @override
  String get bookingAddToCalendar => 'Add to my calendar';

  @override
  String get bookingBookAnotherAppointment => 'Book another appointment';

  @override
  String get bookingSendDocsSubtitle =>
      'Send documents to your practitioner for the appointment.';

  @override
  String get bookingViewMyAppointments => 'View my appointments';

  @override
  String get bookingBackToHome => 'Back to home';

  @override
  String get vaccinationsEmptyTitle => 'No vaccines recorded';

  @override
  String get vaccinationsEmptySubtitle => 'Track your vaccines and reminders.';

  @override
  String get allergiesEmptyTitle => 'No allergies';

  @override
  String get allergiesEmptySubtitle =>
      'Declare your allergies for your safety.';

  @override
  String get medicationsEmptyTitle => 'No medications';

  @override
  String get medicationsEmptySubtitle => 'Add your current treatments.';

  @override
  String get conditionsEmptyTitle => 'No condition';

  @override
  String get conditionsEmptySubtitle =>
      'Add your medical history for your appointments.';

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
  String get errorGenericTryAgain => 'An error occurred. Try again.';

  @override
  String get authSignInFailedTryAgain => 'Sign-in failed. Try again.';

  @override
  String get authSignUpFailedTryAgain => 'Sign-up failed. Try again.';

  @override
  String get authOnlyPatientsAllowed =>
      'Only patients are allowed to sign in for now.';

  @override
  String get errorUnableToConfirmAppointment =>
      'Unable to confirm the appointment.';

  @override
  String get errorUnableToLoadProfile => 'Unable to load the profile.';

  @override
  String get errorUnableToRetrieveEmail =>
      'Unable to retrieve your email address.';

  @override
  String get errorUnableToReadHistoryState => 'Unable to read history state.';

  @override
  String get errorUnableToEnableHistory => 'Unable to enable history.';

  @override
  String get errorUnableToLoadRelatives => 'Unable to load relatives.';

  @override
  String get errorUnableToAddRelative => 'Unable to add a relative.';

  @override
  String get errorUnableToLoadPayments => 'Unable to load payments.';

  @override
  String get errorUnableToAddPaymentMethod => 'Unable to add a payment method.';

  @override
  String get errorUnableToLoadHealthData => 'Unable to load health data.';

  @override
  String get errorUnableToAddHealthItem => 'Unable to add an item.';

  @override
  String get errorUnableToLoadHealthProfile =>
      'Unable to load the health profile.';

  @override
  String get errorUnableToSaveHealthProfile =>
      'Unable to save the health profile.';

  @override
  String get errorUnableToLoadPractitioner =>
      'Unable to load the practitioner.';

  @override
  String get errorUnableToLoadSearch => 'Unable to load search.';

  @override
  String get errorUnableToLoadDocuments => 'Unable to load documents.';

  @override
  String get errorUnableToAddDocument => 'Unable to add the document.';

  @override
  String get errorUnableToReadSettings => 'Unable to read settings.';

  @override
  String get errorUnableToSaveSettings => 'Unable to save settings.';

  @override
  String get errorUnableToLoadUpcomingAppointments =>
      'Unable to load upcoming appointments.';

  @override
  String get errorUnableToLoadHistory => 'Unable to load history.';

  @override
  String get errorUnableToLoadAppointment => 'Unable to load the appointment.';

  @override
  String get errorUnableToCancelAppointment =>
      'Unable to cancel the appointment.';

  @override
  String get errorUnableToRescheduleAppointment =>
      'Unable to reschedule the appointment.';

  @override
  String get errorUnableToLoadConversations => 'Unable to load conversations.';

  @override
  String get errorUnableToLoadConversation =>
      'Unable to load the conversation.';

  @override
  String get errorUnableToSendMessage => 'Unable to send the message.';

  @override
  String get errorUnableToReadOnboardingState =>
      'Unable to read onboarding state.';

  @override
  String get errorUnableToSaveOnboarding => 'Unable to save onboarding.';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours h ago';
  }

  @override
  String timeDaysAgo(int days) {
    return '$days d ago';
  }

  @override
  String get demoDentalOfficeName => 'Dental office';

  @override
  String get demoConversation1LastMessage =>
      'Hello, your results are available...';

  @override
  String get demoConversation2LastMessage =>
      'Perfect, I\'m sending you the document!';

  @override
  String get demoConversation3LastMessage => 'Thanks for your visit!';

  @override
  String get demoAppointmentConsultation => 'Consultation';

  @override
  String get demoAppointmentFollowUp => 'Medical follow-up';

  @override
  String get demoShortDateThu19Feb => 'Thu Feb 19';

  @override
  String get demoShortDateMon15Feb => 'Mon Feb 15';

  @override
  String get demoMessage1_1 => 'Hello, how can we help you?';

  @override
  String get demoMessage1_2 => 'Hello, I\'d like to get my report.';

  @override
  String get demoMessage1_3 => 'Sure, could you specify the appointment date?';

  @override
  String get demoMessage2_1 => 'Hello, your file is up to date.';

  @override
  String get demoMessage3_1 => 'Hello!';

  @override
  String get demoMessage3_2 => 'Thank you, doctor.';

  @override
  String get relativeRelation => 'Relative';

  @override
  String get relativeChild => 'Child';

  @override
  String get relativeParent => 'Parent';

  @override
  String get relativeSpouse => 'Spouse';

  @override
  String get relativeSibling => 'Sibling';

  @override
  String get relativeOther => 'Other';

  @override
  String relativeDemoName(int index) {
    return 'Relative $index';
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
  String get documentsDemoTypeLabel => 'Report';

  @override
  String get documentsDemoDateLabelToday => 'Today';

  @override
  String get demoSpecialtyOphthalmologist => 'Ophthalmologist';

  @override
  String get demoSpecialtyGeneralPractitioner => 'General practitioner';

  @override
  String get demoPractitionerAbout =>
      'The ophthalmologist treats eye diseases and manages refraction, strabismus and vision disorders.\n\nThis profile is ready to be connected to the backend.';

  @override
  String demoAvailabilityTodayAt(Object time) {
    return 'Today • $time';
  }

  @override
  String demoAvailabilityTomorrowAt(Object time) {
    return 'Tomorrow • $time';
  }

  @override
  String demoAvailabilityThisWeekAt(Object time) {
    return 'This week • $time';
  }

  @override
  String demoSearchPractitionerName(int index) {
    return 'Dr Practitioner $index';
  }

  @override
  String get demoSearchAddress => '75019 Paris • Avenue Secrétan';

  @override
  String get demoSearchSector1 => 'Sector 1';

  @override
  String get demoAvailabilityToday => 'Today';

  @override
  String get demoAvailabilityThisWeek => 'This week';

  @override
  String get demoDistance12km => '1.2 km';

  @override
  String get demoAppointmentDateThu19Feb => 'Thursday, February 19';

  @override
  String get demoAppointmentReasonNewPatientConsultation =>
      'Consultation (new patient)';

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
  String get commonInitialsFallback => 'ME';

  @override
  String get navHome => 'Home';

  @override
  String get navAppointments => 'Appointments';

  @override
  String get navHealth => 'Health';

  @override
  String get navMessages => 'Messages';

  @override
  String get navAccount => 'Account';
}
