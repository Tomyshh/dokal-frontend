// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get commonError => 'שגיאה';

  @override
  String get commonEmail => 'אימייל';

  @override
  String get commonEmailHint => 'לדוגמה: name@domain.com';

  @override
  String get commonEmailRequired => 'נדרש אימייל';

  @override
  String get commonEmailInvalid => 'אימייל לא תקין';

  @override
  String get commonPassword => 'סיסמה';

  @override
  String get commonPasswordHint => '••••••••';

  @override
  String get commonPasswordRequired => 'נדרשת סיסמה';

  @override
  String commonPasswordMinChars(int min) {
    return 'מינימום $min תווים';
  }

  @override
  String get authLoginTitle => 'התחברות';

  @override
  String get authLoginSubtitle => 'גישה לפגישות, הודעות ומסמכים שלך.';

  @override
  String get authLoginButton => 'התחבר';

  @override
  String get authForgotPasswordCta => 'שכחת סיסמה?';

  @override
  String get authCreateAccountCta => 'צור חשבון';

  @override
  String get authContinueWithoutAccount => 'המשך ללא חשבון';

  @override
  String get authRegisterTitle => 'צור חשבון';

  @override
  String get authRegisterSubtitle => 'כל השדות חובה.';

  @override
  String get authFirstName => 'שם פרטי';

  @override
  String get authLastName => 'שם משפחה';

  @override
  String get profileCompletionTitle => 'השלמת פרופיל';

  @override
  String get profileCompletionSubtitle => 'הפרטים הבאים נדרשים כדי להמשיך.';

  @override
  String profileCompletionStepLabel(int current, int total) {
    return '$current/$total';
  }

  @override
  String get profileCompletionStepIdentityTitle => 'זהות';

  @override
  String get profileCompletionStepIdentitySubtitle =>
      'בוא/י נתחיל בפרטים האישיים.';

  @override
  String get profileCompletionDateOfBirth => 'תאריך לידה';

  @override
  String get profileCompletionStepContactTitle => 'יצירת קשר';

  @override
  String get profileCompletionStepContactSubtitle => 'איך נוכל ליצור איתך קשר?';

  @override
  String get profileCompletionEmailLockedHint =>
      'כתובת האימייל מקושרת לחשבון ולא ניתן לשנות אותה כאן.';

  @override
  String get profileCompletionPhone => 'מספר טלפון';

  @override
  String get profileCompletionPhoneHint => 'לדוגמה: +972 50 123 4567';

  @override
  String get profileCompletionPhoneInvalid => 'מספר טלפון לא תקין';

  @override
  String get profileCompletionStepIsraelTitle => 'ישראל';

  @override
  String get profileCompletionStepIsraelSubtitle => 'מידע נדרש לטיפול בישראל.';

  @override
  String get profileCompletionTeudatHint => '9 ספרות';

  @override
  String get profileCompletionTeudatInvalid => 'תעודת זהות לא תקינה';

  @override
  String get profileCompletionStepInsuranceTitle => 'ביטוח';

  @override
  String get profileCompletionStepInsuranceSubtitle => 'אופציונלי (אפשר לדלג).';

  @override
  String get profileCompletionInsurance => 'חברת ביטוח';

  @override
  String get profileCompletionInsuranceNone => 'ללא / דלג';

  @override
  String get profileCompletionInsuranceOptionalHint =>
      'הביטוח אופציונלי. אפשר להוסיף אותו מאוחר יותר בהגדרות.';

  @override
  String get profileCompletionFinish => 'סיום';

  @override
  String get commonRequired => 'חובה';

  @override
  String get commonContinue => 'המשך';

  @override
  String get authAlreadyHaveAccount => 'כבר יש לי חשבון';

  @override
  String get authForgotPasswordTitle => 'שכחת סיסמה';

  @override
  String get authForgotPasswordSubtitle => 'נשלח לך קישור לאיפוס.';

  @override
  String get authForgotPasswordSendLink => 'שלח קישור';

  @override
  String get authBackToLogin => 'חזרה להתחברות';

  @override
  String get authForgotPasswordEmailSent =>
      'האימייל נשלח. בדוק את תיבת הדואר שלך.';

  @override
  String get authVerifyEmailTitle => 'אמת את האימייל שלך';

  @override
  String authVerifyEmailDescription(Object email) {
    return 'שלחנו אימייל אימות לכתובת $email. לחץ על הקישור באימייל וחזור לאפליקציה.';
  }

  @override
  String get authVerifyEmailCheckedBackToLogin => 'אישרתי, חזרה להתחברות';

  @override
  String get authVerifyEmailResend => 'שלח שוב את האימייל';

  @override
  String get authVerifyEmailResentSnack => 'אימייל האימות נשלח מחדש.';

  @override
  String get commonBack => 'חזרה';

  @override
  String get homeMyPractitioners => 'הרופאים שלי';

  @override
  String get homeHistory => 'היסטוריה';

  @override
  String homeGreeting(Object name) {
    return 'שלום $name';
  }

  @override
  String get homeSearchHint => 'רופא, התמחות...';

  @override
  String get homeHealthTip1 => 'השנה, מאמצים הרגלי בריאות נכונים.';

  @override
  String get homeHealthTip2 => 'עדיין אפשר להתחסן.';

  @override
  String get homeCompleteHealthProfile => 'השלם את פרופיל הבריאות שלך';

  @override
  String get homeCompleteHealthProfileSubtitle =>
      'קבל תזכורות מותאמות והכן את הביקורים שלך';

  @override
  String get homeStart => 'התחל';

  @override
  String get homeNoRecentPractitioner => 'אין רופא אחרון';

  @override
  String get homeHistoryDescription => 'ניתן להציג את רשימת הרופאים שבהם ביקרת';

  @override
  String get homeHistoryEnabledSnack => 'היסטוריה הופעלה';

  @override
  String get homeHistoryEnabled => 'היסטוריה הופעלה';

  @override
  String get homeActivateHistory => 'הפעל היסטוריה';

  @override
  String homeNewMessageTitle(Object name) {
    return 'מחכה לך הודעה חדשה מ־$name';
  }

  @override
  String get homeNewMessageNoAppointment => 'ללא תור משויך';

  @override
  String get homeUpcomingAppointmentsTitle => 'תורים קרובים';

  @override
  String get homeFindAppointmentCta => 'מצאו תור';

  @override
  String get homeLast3AppointmentsTitle => '3 התורים האחרונים';

  @override
  String get homeSeeAllPastAppointments => 'צפה בכל התורים שעברו';

  @override
  String get homeAppointmentHistoryTitle => 'היסטוריית תורים';

  @override
  String get homeNoAppointmentHistory => 'אין היסטוריית תורים';

  @override
  String get commonTryAgainLater => 'נסה שוב מאוחר יותר.';

  @override
  String get commonTryAgain => 'נסה שוב';

  @override
  String get commonUnableToLoad => 'לא ניתן לטעון';

  @override
  String get commonAvailableSoon => 'זמין בקרוב';

  @override
  String get commonCancel => 'ביטול';

  @override
  String get commonActionIsFinal => 'פעולה זו היא סופית.';

  @override
  String get commonTodo => 'לביצוע';

  @override
  String get commonToRead => 'לקריאה';

  @override
  String get commonSettings => 'הגדרות';

  @override
  String get commonTryAgainInAMoment => 'נסה שוב בעוד רגע.';

  @override
  String commonMinChars(int min) {
    return 'מינימום $min תווים';
  }

  @override
  String get commonOnline => 'מחובר';

  @override
  String get appointmentsTitle => 'התורים שלי';

  @override
  String get appointmentsTabUpcoming => 'בקרוב';

  @override
  String get appointmentsTabPast => 'עבר';

  @override
  String get appointmentsNoUpcomingTitle => 'אין תורים קרובים';

  @override
  String get appointmentsNoUpcomingSubtitle => 'התורים הבאים שלך יופיעו כאן.';

  @override
  String get appointmentsNoPastTitle => 'אין תורים קודמים';

  @override
  String get appointmentsNoPastSubtitle => 'תורים שהסתיימו יופיעו כאן.';

  @override
  String get searchTitle => 'חיפוש';

  @override
  String get searchHint => 'רופא, התמחות...';

  @override
  String get searchUnavailableTitle => 'החיפוש אינו זמין';

  @override
  String get searchNoResultsTitle => 'אין תוצאות';

  @override
  String get searchNoResultsSubtitle => 'נסה מונח אחר.';

  @override
  String get searchFilterTitle => 'סינון תוצאות';

  @override
  String get searchFilterDate => 'תאריך זמינות';

  @override
  String get searchFilterDateToday => 'היום';

  @override
  String get searchFilterDateTomorrow => 'מחר';

  @override
  String get searchFilterDateThisWeek => 'השבוע';

  @override
  String get searchFilterDateNextWeek => 'שבוע הבא';

  @override
  String get searchFilterDateAny => 'כל תאריך';

  @override
  String get searchFilterSpecialty => 'התמחות';

  @override
  String get searchFilterSpecialtyAll => 'כל ההתמחויות';

  @override
  String get searchFilterKupatHolim => 'קופת חולים';

  @override
  String get searchFilterKupatHolimAll => 'כל הקופות';

  @override
  String get searchFilterDistance => 'מרחק מקסימלי';

  @override
  String get searchFilterDistanceAny => 'ללא הגבלה';

  @override
  String get searchFilterApply => 'החל סינון';

  @override
  String get searchFilterReset => 'נקה הכל';

  @override
  String searchFilterActiveCount(int count) {
    return '$count סינונים פעילים';
  }

  @override
  String get searchSortTitle => 'מיין לפי';

  @override
  String get searchSortAvailability => 'זמינות';

  @override
  String get searchSortDistance => 'מרחק';

  @override
  String get searchSortName => 'שם';

  @override
  String get searchSortRating => 'דירוג';

  @override
  String get onboardingStep1Title => 'קבעו תורים בקלות';

  @override
  String get onboardingStep2Title => 'התכתבו בקלות עם הרופאים שלכם';

  @override
  String get onboardingStep3Title => 'גישה לתיק הרפואי בכל זמן';

  @override
  String get onboardingContinueButton => 'המשך';

  @override
  String get onboardingStartButton => 'התחל';

  @override
  String get healthTitle => 'הבריאות שלי';

  @override
  String get healthSubtitle => 'נהל את פרופיל הבריאות שלך';

  @override
  String get healthProfileTitle => 'פרופיל בריאות';

  @override
  String get healthProfileSubtitle => 'מלא מידע חשוב לקראת ביקורים ותורים';

  @override
  String get healthProfileIntro =>
      'מידע זה יעזור לנו להכין את הביקורים שלך בישראל (קופת חולים, רופא משפחה, אלרגיות וכו׳).';

  @override
  String get healthProfileSave => 'שמור';

  @override
  String get healthProfileSavedSnack => 'הפרופיל נשמר';

  @override
  String get healthProfileStepIdentity => 'זהות';

  @override
  String get healthProfileStepKupatHolim => 'קופת חולים';

  @override
  String get healthProfileStepMedical => 'מידע רפואי';

  @override
  String get healthProfileStepEmergency => 'איש קשר לחירום';

  @override
  String get healthProfileTeudatZehut => 'תעודת זהות';

  @override
  String get healthProfileDateOfBirth => 'תאריך לידה';

  @override
  String get healthProfileSex => 'מין';

  @override
  String get healthProfileSexFemale => 'נקבה';

  @override
  String get healthProfileSexMale => 'זכר';

  @override
  String get healthProfileSexOther => 'אחר';

  @override
  String get healthProfileKupatHolim => 'קופת חולים';

  @override
  String get healthProfileKupatMemberId => 'מספר חבר';

  @override
  String get healthProfileFamilyDoctor => 'רופא/ת משפחה';

  @override
  String get healthProfileEmergencyContactName => 'שם איש קשר לחירום';

  @override
  String get healthProfileEmergencyContactPhone => 'טלפון לחירום';

  @override
  String get kupatClalit => 'כללית';

  @override
  String get kupatMaccabi => 'מכבי';

  @override
  String get kupatMeuhedet => 'מאוחדת';

  @override
  String get kupatLeumit => 'לאומית';

  @override
  String get kupatOther => 'אחר';

  @override
  String get healthMyFileSectionTitle => 'התיק שלי';

  @override
  String get healthDocumentsTitle => 'מסמכים';

  @override
  String get healthDocumentsSubtitle => 'מרשמים, בדיקות, סיכומים';

  @override
  String get healthConditionsTitle => 'מצבים רפואיים';

  @override
  String get healthConditionsSubtitle => 'היסטוריה רפואית ומחלות';

  @override
  String get healthMedicationsTitle => 'תרופות';

  @override
  String get healthMedicationsSubtitle => 'טיפולים נוכחיים';

  @override
  String get healthAllergiesTitle => 'אלרגיות';

  @override
  String get healthAllergiesSubtitle => 'אלרגיות ידועות';

  @override
  String get healthVaccinationsTitle => 'חיסונים';

  @override
  String get healthVaccinationsSubtitle => 'היסטוריית חיסונים';

  @override
  String get healthUpToDateTitle => 'הכול מעודכן';

  @override
  String get healthUpToDateSubtitle =>
      'נודיע לך כשיהיו לך תזכורות בריאות חדשות.';

  @override
  String get appointmentDetailTitle => 'פרטי התור';

  @override
  String get appointmentDetailCancelledSnack => 'התור בוטל';

  @override
  String get appointmentDetailNotFoundTitle => 'התור לא נמצא';

  @override
  String get appointmentDetailNotFoundSubtitle => 'התור אינו זמין או בוטל.';

  @override
  String get appointmentDetailReschedule => 'לקבוע מחדש';

  @override
  String get appointmentDetailCancelQuestion => 'לבטל את התור?';

  @override
  String get appointmentDetailPreparationTitle => 'נדרשת הכנה';

  @override
  String get appointmentDetailPreparationSubtitle => 'הכן את הביקור מראש.';

  @override
  String get appointmentDetailPrepQuestionnaire => 'מילוי שאלון בריאות';

  @override
  String get appointmentDetailPrepInstructions => 'צפה בהנחיות';

  @override
  String get appointmentPrepQuestionnaireSubtitle =>
      'שאלון סטנדרטי (מוכן לשרת)';

  @override
  String get appointmentPrepInstructionsSubtitle => 'מידע חשוב לפני הביקור';

  @override
  String get appointmentPrepQuestionSymptoms => 'סיבה / תסמינים (תיאור קצר)';

  @override
  String get appointmentPrepQuestionAllergies => 'אלרגיות (אופציונלי)';

  @override
  String get appointmentPrepQuestionMedications => 'תרופות קבועות (אופציונלי)';

  @override
  String get appointmentPrepQuestionOther => 'מידע נוסף (אופציונלי)';

  @override
  String get appointmentPrepConsentLabel =>
      'אני מסכים/ה לשתף מידע זה עם הרופא/ה';

  @override
  String get appointmentPrepConsentRequired => 'נא לאשר כדי להמשיך.';

  @override
  String get appointmentPrepSavedSnack => 'ההכנה נשמרה';

  @override
  String get appointmentPrepSubmit => 'שלח';

  @override
  String get appointmentPrepInstruction1 => 'הבא תעודה מזהה וכרטיס ביטוח.';

  @override
  String get appointmentPrepInstruction2 => 'הגיעו 10 דקות מוקדם יותר.';

  @override
  String get appointmentPrepInstruction3 => 'הכינו מסמכים רפואיים חשובים.';

  @override
  String get appointmentPrepInstructionsAccept =>
      'קראתי ואני מסכים/ה להנחיות אלו';

  @override
  String get appointmentDetailSendDocsTitle => 'שליחת מסמכים';

  @override
  String get appointmentDetailSendDocsSubtitle =>
      'שלח מסמכים לרופא לפני הביקור.';

  @override
  String get appointmentDetailAddDocs => 'הוסף מסמכים';

  @override
  String get appointmentDetailEarlierSlotTitle => 'רוצה תור מוקדם יותר?';

  @override
  String get appointmentDetailEarlierSlotSubtitle =>
      'קבל התראה אם תתפנה שעה מוקדמת יותר.';

  @override
  String get appointmentDetailEnableAlerts => 'הפעל התראות';

  @override
  String get appointmentDetailContactOffice => 'צור קשר עם המרפאה';

  @override
  String get appointmentDetailVisitSummaryTitle => 'סיכום ביקור';

  @override
  String get appointmentDetailVisitSummarySubtitle =>
      'מה קרה בביקור ומה הצעדים הבאים';

  @override
  String get appointmentDetailVisitSummaryDemo =>
      'בוצעה בדיקה קלינית. הומלץ על מעקב בעוד 3 חודשים, והמשך טיפול לפי הצורך.';

  @override
  String get appointmentDetailDoctorReportTitle => 'סיכום רופא';

  @override
  String get appointmentDetailDoctorReportSubtitle => 'דוח רפואי מהרופא המטפל';

  @override
  String get appointmentDetailDoctorReportDemo =>
      'המטופל/ת הגיע/ה לבדיקה. לא נמצאו ממצאים חריגים. מומלץ להמשיך מעקב ולהביא מסמכים רלוונטיים לביקור הבא.';

  @override
  String get appointmentDetailDocumentsAndRxTitle => 'מסמכים ומרשמים';

  @override
  String get appointmentDetailDocumentsAndRxSubtitle =>
      'מצא את המסמכים שהתקבלו לאחר הביקור';

  @override
  String get appointmentDetailOpenVisitReport => 'פתח את סיכום הביקור';

  @override
  String get appointmentDetailOpenPrescription => 'פתח מרשם';

  @override
  String get appointmentDetailSendMessageCta => 'שלח הודעה למרפאה';

  @override
  String get messagesTitle => 'הודעות';

  @override
  String get messagesMarkAllRead => 'סמן הכול כנקרא';

  @override
  String get messagesEmptyTitle => 'ההודעות שלך';

  @override
  String get messagesEmptySubtitle =>
      'התחל שיחה עם הרופאים שלך כדי לבקש מסמך, לשאול שאלה או לעקוב אחר תוצאות.';

  @override
  String get messagesNewMessageTitle => 'הודעה חדשה';

  @override
  String get messagesWriteToOfficeTitle => 'כתוב למרפאה';

  @override
  String get messagesResponseTime => 'מענה תוך 24–48 שעות.';

  @override
  String get messagesSubjectLabel => 'נושא';

  @override
  String get messagesSubjectHint => 'לדוגמה: תוצאות, שאלה…';

  @override
  String get messagesSubjectRequired => 'נדרש נושא';

  @override
  String get messagesMessageLabel => 'הודעה';

  @override
  String get messagesMessageHint => 'כתוב את ההודעה שלך…';

  @override
  String get messagesSendButton => 'שלח';

  @override
  String get conversationTitle => 'שיחה';

  @override
  String get conversationNewMessageTooltip => 'הודעה חדשה';

  @override
  String get conversationWriteMessageHint => 'כתוב הודעה…';

  @override
  String get practitionerTitle => 'רופא';

  @override
  String get practitionerUnavailableTitle => 'הרופא אינו זמין';

  @override
  String get practitionerNotFoundTitle => 'הרופא לא נמצא';

  @override
  String get practitionerNotFoundSubtitle => 'הפרופיל אינו זמין.';

  @override
  String get practitionerBookAppointment => 'קבע תור';

  @override
  String get practitionerSendMessage => 'שלח הודעה';

  @override
  String get practitionerAvailabilities => 'זמינות';

  @override
  String get practitionerAddress => 'כתובת';

  @override
  String get practitionerProfileSection => 'פרופיל';

  @override
  String get documentsTitle => 'מסמכים';

  @override
  String get documentsEmptyTitle => 'אין מסמך';

  @override
  String get documentsEmptySubtitle => 'המרשמים והתוצאות שלך יופיעו כאן.';

  @override
  String get documentsOpen => 'פתח';

  @override
  String get documentsShare => 'שתף';

  @override
  String get authLogout => 'התנתק';

  @override
  String get securityTitle => 'אבטחה';

  @override
  String get securitySecureAccountTitle => 'אבטח את החשבון שלך';

  @override
  String get securitySecureAccountSubtitle => 'עדכן את הפרטים שלך';

  @override
  String get securityChangePassword => 'שנה סיסמה';

  @override
  String get securityChangePasswordSuccess => 'הבקשה נשמרה';

  @override
  String get securityCurrentPassword => 'סיסמה נוכחית';

  @override
  String get securityNewPassword => 'סיסמה חדשה';

  @override
  String get accountTitle => 'החשבון שלי';

  @override
  String get accountTaglineTitle => 'הבריאות שלך. הנתונים שלך.';

  @override
  String get accountTaglineSubtitle => 'הפרטיות שלך היא העדיפות שלנו.';

  @override
  String get accountPersonalInfoSection => 'פרטים אישיים';

  @override
  String get accountMyProfile => 'הפרופיל שלי';

  @override
  String get accountMyRelatives => 'הקרובים שלי';

  @override
  String get accountSectionTitle => 'חשבון';

  @override
  String get privacyTitle => 'פרטיות';

  @override
  String get privacyYourDataTitle => 'הנתונים שלך';

  @override
  String get privacyYourDataSubtitle =>
      'אנחנו מגנים על המידע שלך ומגבילים את הגישה אליו.';

  @override
  String get privacySharingTitle => 'שיתוף';

  @override
  String get privacySharingSubtitle => 'שלוט במסמכים שמשותפים עם הרופאים שלך.';

  @override
  String get privacyExportTitle => 'ייצוא';

  @override
  String get privacyExportSubtitle => 'ייצא את הנתונים שלך בכל עת.';

  @override
  String get paymentTitle => 'תשלום';

  @override
  String get paymentEmptyTitle => 'אין אמצעי תשלום';

  @override
  String get paymentEmptySubtitle => 'הוסף כרטיס כדי לפשט את החיוב.';

  @override
  String paymentExpires(Object expiry) {
    return 'תוקף $expiry';
  }

  @override
  String get relativesTitle => 'הקרובים שלי';

  @override
  String get relativesEmptyTitle => 'אין קרוב';

  @override
  String get relativesEmptySubtitle => 'הוסף קרובים כדי לקבוע תור בשמם.';

  @override
  String get settingsUnavailableTitle => 'ההגדרות אינן זמינות';

  @override
  String get settingsUnavailableSubtitle => 'לא ניתן לטעון את ההעדפות שלך.';

  @override
  String get settingsNotificationsTitle => 'התראות';

  @override
  String get settingsNotificationsSubtitle => 'קבל הודעות ועדכונים';

  @override
  String get settingsRemindersTitle => 'תזכורות לתורים';

  @override
  String get settingsRemindersSubtitle => 'קבל תזכורות לפני התורים שלך';

  @override
  String get settingsLanguageTitle => 'שפה';

  @override
  String get settingsLanguageCurrentLabel => 'עברית (נוכחי)';

  @override
  String get settingsLanguageShortLabel => 'עברית';

  @override
  String get profileTitle => 'הפרופיל שלי';

  @override
  String get profileUnavailableTitle => 'הפרופיל אינו זמין';

  @override
  String get profileUnavailableSubtitle => 'הפרטים שלך אינם זמינים.';

  @override
  String get profileIdentitySection => 'זהות';

  @override
  String get commonName => 'שם';

  @override
  String get commonAddress => 'כתובת';

  @override
  String get commonCity => 'עיר';

  @override
  String get profileMedicalInfoSection => 'מידע רפואי';

  @override
  String get profileBloodType => 'סוג דם';

  @override
  String get profileHeight => 'גובה';

  @override
  String get profileWeight => 'משקל';

  @override
  String get bookingSelectPatientTitle => 'למי מיועד התור הזה?';

  @override
  String get bookingPatientsUnavailableTitle => 'המטופלים אינם זמינים';

  @override
  String get bookingAddRelative => 'הוסף קרוב';

  @override
  String get commonMe => 'אני';

  @override
  String get bookingSelectSlotTitle => 'בחר תאריך';

  @override
  String get bookingSelectSlotSubtitle => 'בחר תאריך ושעה זמינים.';

  @override
  String get bookingSeeMoreDates => 'ראה עוד תאריכים';

  @override
  String get commonSelected => 'נבחר';

  @override
  String get bookingInstructionsTitle => 'הנחיות';

  @override
  String get bookingInstructionsSubtitle =>
      'לפני התור, אנא בדוק את הנקודות הבאות.';

  @override
  String get bookingInstructionsBullet1 =>
      'הבא את כרטיס הביטוח והמרשם במידת הצורך.';

  @override
  String get bookingInstructionsBullet2 =>
      'הגע 10 דקות מוקדם יותר לצורך סידורים.';

  @override
  String get bookingInstructionsBullet3 => 'במקרה של ביטול, הודע בהקדם האפשרי.';

  @override
  String get bookingInstructionsAccept => 'קראתי ואני מסכים להנחיות אלו.';

  @override
  String get bookingConfirmTitle => 'אשר את התור';

  @override
  String get bookingConfirmSubtitle => 'בדוק את המידע לפני האישור.';

  @override
  String get bookingReasonLabel => 'סיבה';

  @override
  String get bookingPatientLabel => 'מטופל';

  @override
  String get bookingSlotLabel => 'מועד';

  @override
  String get bookingMissingInfoTitle => 'מידע חסר';

  @override
  String get bookingZipCodeLabel => 'מיקוד';

  @override
  String get bookingVisitedBeforeQuestion => 'האם ביקרת אצל רופא זה בעבר?';

  @override
  String get commonYes => 'כן';

  @override
  String get commonNo => 'לא';

  @override
  String get bookingConfirmButton => 'אשר את התור';

  @override
  String get bookingChangeSlotButton => 'שנה את המועד';

  @override
  String get bookingSuccessTitle => 'התור אושר';

  @override
  String get bookingSuccessSubtitle => 'שלחנו אישור לאימייל שלך.';

  @override
  String get bookingAddToCalendar => 'הוסף ללוח השנה שלי';

  @override
  String get bookingBookAnotherAppointment => 'קבע תור נוסף';

  @override
  String get bookingSendDocsSubtitle => 'שלח מסמכים לרופא עבור הביקור.';

  @override
  String get bookingViewMyAppointments => 'ראה את התורים שלי';

  @override
  String get bookingBackToHome => 'חזרה לדף הבית';

  @override
  String get vaccinationsEmptyTitle => 'אין חיסונים רשומים';

  @override
  String get vaccinationsEmptySubtitle => 'עקוב אחר החיסונים והתזכורות שלך.';

  @override
  String get allergiesEmptyTitle => 'אין אלרגיות';

  @override
  String get allergiesEmptySubtitle => 'דווח על האלרגיות שלך למען בטיחותך.';

  @override
  String get medicationsEmptyTitle => 'אין תרופות';

  @override
  String get medicationsEmptySubtitle => 'הוסף את הטיפולים הנוכחיים שלך.';

  @override
  String get conditionsEmptyTitle => 'אין מצב רפואי';

  @override
  String get conditionsEmptySubtitle => 'הוסף היסטוריה רפואית עבור התורים שלך.';

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
  String get errorGenericTryAgain => 'אירעה שגיאה. נסה שוב.';

  @override
  String get authSignInFailedTryAgain => 'ההתחברות נכשלה. נסה שוב.';

  @override
  String get authSignUpFailedTryAgain => 'ההרשמה נכשלה. נסה שוב.';

  @override
  String get errorUnableToConfirmAppointment => 'לא ניתן לאשר את התור.';

  @override
  String get errorUnableToLoadProfile => 'לא ניתן לטעון את הפרופיל.';

  @override
  String get errorUnableToReadHistoryState => 'לא ניתן לקרוא את מצב ההיסטוריה.';

  @override
  String get errorUnableToEnableHistory => 'לא ניתן להפעיל את ההיסטוריה.';

  @override
  String get errorUnableToLoadRelatives => 'לא ניתן לטעון את הקרובים.';

  @override
  String get errorUnableToAddRelative => 'לא ניתן להוסיף קרוב.';

  @override
  String get errorUnableToLoadPayments => 'לא ניתן לטעון תשלומים.';

  @override
  String get errorUnableToAddPaymentMethod => 'לא ניתן להוסיף אמצעי תשלום.';

  @override
  String get errorUnableToLoadHealthData => 'לא ניתן לטעון נתוני בריאות.';

  @override
  String get errorUnableToAddHealthItem => 'לא ניתן להוסיף פריט.';

  @override
  String get errorUnableToLoadHealthProfile =>
      'לא ניתן לטעון את פרופיל הבריאות.';

  @override
  String get errorUnableToSaveHealthProfile =>
      'לא ניתן לשמור את פרופיל הבריאות.';

  @override
  String get errorUnableToLoadPractitioner => 'לא ניתן לטעון את הרופא.';

  @override
  String get errorUnableToLoadSearch => 'לא ניתן לטעון את החיפוש.';

  @override
  String get errorUnableToLoadDocuments => 'לא ניתן לטעון מסמכים.';

  @override
  String get errorUnableToAddDocument => 'לא ניתן להוסיף מסמך.';

  @override
  String get errorUnableToReadSettings => 'לא ניתן לקרוא את ההגדרות.';

  @override
  String get errorUnableToSaveSettings => 'לא ניתן לשמור את ההגדרות.';

  @override
  String get errorUnableToLoadUpcomingAppointments =>
      'לא ניתן לטעון תורים קרובים.';

  @override
  String get errorUnableToLoadHistory => 'לא ניתן לטעון היסטוריה.';

  @override
  String get errorUnableToLoadAppointment => 'לא ניתן לטעון את התור.';

  @override
  String get errorUnableToCancelAppointment => 'לא ניתן לבטל את התור.';

  @override
  String get errorUnableToLoadConversations => 'לא ניתן לטעון שיחות.';

  @override
  String get errorUnableToLoadConversation => 'לא ניתן לטעון את השיחה.';

  @override
  String get errorUnableToSendMessage => 'לא ניתן לשלוח את ההודעה.';

  @override
  String get errorUnableToReadOnboardingState => 'לא ניתן לקרוא את מצב ההדרכה.';

  @override
  String get errorUnableToSaveOnboarding => 'לא ניתן לשמור את ההדרכה.';

  @override
  String timeMinutesAgo(int minutes) {
    return 'לפני $minutes דק׳';
  }

  @override
  String timeHoursAgo(int hours) {
    return 'לפני $hours ש׳';
  }

  @override
  String timeDaysAgo(int days) {
    return 'לפני $days י׳';
  }

  @override
  String get demoDentalOfficeName => 'מרפאת שיניים';

  @override
  String get demoConversation1LastMessage => 'שלום, התוצאות שלך זמינות...';

  @override
  String get demoConversation2LastMessage => 'מצוין, אני שולח לך את המסמך!';

  @override
  String get demoConversation3LastMessage => 'תודה על הביקור!';

  @override
  String get demoAppointmentConsultation => 'ייעוץ';

  @override
  String get demoAppointmentFollowUp => 'מעקב רפואי';

  @override
  String get demoShortDateThu19Feb => 'ה׳ 19 בפבר׳';

  @override
  String get demoShortDateMon15Feb => 'ב׳ 15 בפבר׳';

  @override
  String get demoMessage1_1 => 'שלום, איך אפשר לעזור?';

  @override
  String get demoMessage1_2 => 'שלום, אני רוצה לקבל את הסיכום שלי.';

  @override
  String get demoMessage1_3 => 'בוודאי, האם תוכל לציין את תאריך התור?';

  @override
  String get demoMessage2_1 => 'שלום, התיק שלך מעודכן.';

  @override
  String get demoMessage3_1 => 'שלום!';

  @override
  String get demoMessage3_2 => 'תודה דוקטור.';

  @override
  String get relativeRelation => 'קרוב';

  @override
  String get relativeChild => 'ילד';

  @override
  String get relativeParent => 'הורה';

  @override
  String relativeDemoName(int index) {
    return 'קרוב $index';
  }

  @override
  String relativeLabel(Object relation, int year) {
    return '$relation • $year';
  }

  @override
  String documentsDemoTitle(int index) {
    return 'מסמך $index';
  }

  @override
  String get documentsDemoTypeLabel => 'סיכום';

  @override
  String get documentsDemoDateLabelToday => 'היום';

  @override
  String get demoSpecialtyOphthalmologist => 'רופא עיניים';

  @override
  String get demoSpecialtyGeneralPractitioner => 'רופא משפחה';

  @override
  String get demoPractitionerAbout =>
      'רופא העיניים מטפל במחלות העין, ומתמחה ברפרקציה, פזילה והפרעות ראייה.\n\nפרופיל זה מוכן להתחבר לשרת.';

  @override
  String demoAvailabilityTodayAt(Object time) {
    return 'היום • $time';
  }

  @override
  String demoAvailabilityTomorrowAt(Object time) {
    return 'מחר • $time';
  }

  @override
  String demoAvailabilityThisWeekAt(Object time) {
    return 'השבוע • $time';
  }

  @override
  String demoSearchPractitionerName(int index) {
    return 'ד\"ר מטפל $index';
  }

  @override
  String get demoSearchAddress => '75019 פריז • Avenue Secrétan';

  @override
  String get demoSearchSector1 => 'סקטור 1';

  @override
  String get demoAvailabilityToday => 'היום';

  @override
  String get demoAvailabilityThisWeek => 'השבוע';

  @override
  String get demoDistance12km => '1.2 ק\"מ';

  @override
  String get demoAppointmentDateThu19Feb => 'יום ה׳ 19 בפברואר';

  @override
  String get demoAppointmentReasonNewPatientConsultation => 'ייעוץ (מטופל חדש)';

  @override
  String get demoPractitionerNameMarc => 'ד\"ר מרק בן-חמו';

  @override
  String get demoPractitionerNameSarah => 'ד\"ר שרה כהן';

  @override
  String get demoPractitionerNameNoam => 'ד\"ר נעם לוי';

  @override
  String get demoPractitionerNameMarcShort => 'ד\"ר מרק ב׳';

  @override
  String get demoPractitionerNameSophie => 'ד\"ר סופי ל׳';

  @override
  String get demoPatientNameTom => 'תום';

  @override
  String get demoAddressParis => '28, שדרות סרטא, 75019 פריז';

  @override
  String get demoProfileFullName => 'תום ג׳מי';

  @override
  String get demoProfileEmail => 'tom@domaine.com';

  @override
  String get demoProfileCity => '75019 פריז';

  @override
  String get demoPaymentBrandVisa => 'ויזה';

  @override
  String get commonInitialsFallback => 'אני';

  @override
  String get navHome => 'בית';

  @override
  String get navAppointments => 'תורים';

  @override
  String get navHealth => 'בריאות';

  @override
  String get navMessages => 'הודעות';

  @override
  String get navAccount => 'חשבון';
}
