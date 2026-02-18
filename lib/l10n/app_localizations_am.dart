// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get commonError => 'ስህተት';

  @override
  String get commonEmail => 'ኢሜይል';

  @override
  String get commonEmailHint => 'ለምሳሌ፡ name@domain.com';

  @override
  String get commonEmailRequired => 'ኢሜይል ያስፈልጋል';

  @override
  String get commonEmailInvalid => 'የተሳሳተ ኢሜይል';

  @override
  String get commonPassword => 'የይለፍ ቃል';

  @override
  String get commonPasswordHint => '••••••••';

  @override
  String get commonPasswordRequired => 'የይለፍ ቃል ያስፈልጋል';

  @override
  String commonPasswordMinChars(int min) {
    return 'ቢያንስ $min ቁምፊዎች';
  }

  @override
  String get authLoginTitle => 'ግባ';

  @override
  String get authLoginSubtitle => 'ወደ ቀጠሮዎችዎ፣ መልዕክቶችዎ እና ሰነዶችዎ ይግቡ።';

  @override
  String get authLoginButton => 'ግባ';

  @override
  String get authForgotPasswordCta => 'የይለፍ ቃል ረሳህ?';

  @override
  String get authCreateAccountCta => 'መለያ ፍጠር';

  @override
  String get authContinueWithGoogle => 'በGoogle ቀጥል';

  @override
  String get authContinueWithoutAccount => 'ያለ መለያ ቀጥል';

  @override
  String get authRegisterTitle => 'መለያ ፍጠር';

  @override
  String get authRegisterSubtitle => 'ሁሉም መስኮች ግዴታ ናቸው።';

  @override
  String get authFirstName => 'ስም';

  @override
  String get authLastName => 'የአባት ስም';

  @override
  String get profileCompletionTitle => 'መረጃዎን ያጠናቅቁ';

  @override
  String get profileCompletionSubtitle => 'ለመቀጠል እነዚህ መረጃዎች አስፈላጊ ናቸው።';

  @override
  String profileCompletionStepLabel(int current, int total) {
    return '$current/$total';
  }

  @override
  String get profileCompletionStepIdentityTitle => 'ማንነት';

  @override
  String get profileCompletionStepIdentitySubtitle => 'እርስዎን እንወቅ።';

  @override
  String get profileCompletionDateOfBirth => 'የትውልድ ቀን';

  @override
  String get profileCompletionCity => 'ከተማ (አማራጭ)';

  @override
  String get profileCompletionSex => 'ጾታ (አማራጭ)';

  @override
  String get profileCompletionSexMale => 'ወንድ';

  @override
  String get profileCompletionSexFemale => 'ሴት';

  @override
  String get profileCompletionSexOther => 'ሌላ';

  @override
  String get profileCompletionAvatar => 'የመገለጫ ፎቶ (አማራጭ)';

  @override
  String get profileCompletionStepContactTitle => 'እንገናኝ';

  @override
  String get profileCompletionStepContactSubtitle => 'እንዴት እንገናኝብዎት?';

  @override
  String get profileCompletionEmailLockedHint =>
      'ኢሜይሉ ከመለያዎ ጋር ተያይዟል እና እዚህ መቀየር አይቻልም።';

  @override
  String get profileCompletionPhone => 'ስልክ ቁጥር';

  @override
  String get profileCompletionPhoneHint => 'ለምሳሌ +972 50 123 4567';

  @override
  String get profileCompletionPhoneInvalid => 'የስልክ ቁጥር ትክክል አይደለም';

  @override
  String get profileCompletionStepIsraelTitle => 'እስራኤል';

  @override
  String get profileCompletionStepIsraelSubtitle =>
      'በእስራኤል ሕክምና ለመቀበል የሚያስፈልጉ መረጃዎች።';

  @override
  String get profileCompletionTeudatHint => '9 አሃዞች';

  @override
  String get profileCompletionTeudatInvalid => 'የመታወቂያ ቁጥር ትክክል አይደለም';

  @override
  String get profileCompletionStepInsuranceTitle => 'መድን';

  @override
  String get profileCompletionStepInsuranceSubtitle => 'አማራጭ (መዝለል ይችላሉ)።';

  @override
  String get profileCompletionInsurance => 'የመድን ኩባንያ';

  @override
  String get profileCompletionInsuranceNone => 'መድን የለም / ዝለል';

  @override
  String get profileCompletionInsuranceOptionalHint =>
      'መድኑ አማራጭ ነው። በኋላ በቅንብሮች ውስጥ ማከል ይችላሉ።';

  @override
  String get profileCompletionFinish => 'ጨርስ';

  @override
  String get commonRequired => 'ግዴታ';

  @override
  String get commonContinue => 'ቀጥል';

  @override
  String get authAlreadyHaveAccount => 'አስቀድሞ መለያ አለኝ';

  @override
  String get authForgotPasswordTitle => 'የይለፍ ቃል ረሳሁ';

  @override
  String get authForgotPasswordSubtitle => 'የመመለሻ አገናኝ እንልካለን።';

  @override
  String get authForgotPasswordSendLink => 'አገናኝ ላክ';

  @override
  String get authBackToLogin => 'ወደ መግቢያ ተመለስ';

  @override
  String get authForgotPasswordEmailSent => 'ኢሜይል ተልኳል። ገቢ ፖስታዎን ያረጋግጡ።';

  @override
  String get authVerifyEmailTitle => 'ኢሜይልዎን ያረጋግጡ';

  @override
  String authVerifyEmailDescription(Object email) {
    return 'ወደ $email የማረጋገጫ ኢሜይል ላክን። በኢሜይሉ ውስጥ ያለውን አገናኝ ጫን እና ወደ መተግበሪያው ተመለስ።';
  }

  @override
  String get authVerifyEmailCheckedBackToLogin => 'አረጋግጫለሁ፣ ወደ መግቢያ ተመለስ';

  @override
  String get authVerifyEmailResend => 'ኢሜይል ደግመህ ላክ';

  @override
  String get authVerifyEmailResentSnack => 'የማረጋገጫ ኢሜይል ደግመን ላክን።';

  @override
  String get commonBack => 'ተመለስ';

  @override
  String get homeMyPractitioners => 'የእኔ ሐኪሞች';

  @override
  String get homeHistory => 'ታሪክ';

  @override
  String homeGreeting(Object name) {
    return 'ሰላም $name';
  }

  @override
  String get homeSearchHint => 'ሐኪም፣ ስፔሻሊቲ...';

  @override
  String get homeHealthTip1 => 'በዚህ ዓመት ጤናማ ልማዶችን ይማሩ።';

  @override
  String get homeHealthTip2 => 'መከተብ ለማድረግ ገና አልዘገየም።';

  @override
  String get homeCompleteHealthProfile => 'የጤና መገለጫዎን ያሟሉ';

  @override
  String get homeCompleteHealthProfileSubtitle =>
      'ግላዊ ማስታወሻዎችን ተቀበል እና ቀጠሮዎችህን አዘጋጅ';

  @override
  String get homeStart => 'ጀምር';

  @override
  String get homeNoRecentPractitioner => 'የቅርብ ጊዜ ሐኪም የለም';

  @override
  String get homeHistoryDescription => 'ያገናኙትን ሐኪሞች ዝርዝር ማየት ትችላለህ';

  @override
  String get homeHistoryEnabledSnack => 'ታሪክ ተከፍቷል';

  @override
  String get homeHistoryEnabled => 'ታሪክ ተከፍቷል';

  @override
  String get homeActivateHistory => 'ታሪክን አንቃ';

  @override
  String homeNewMessageTitle(Object name) {
    return 'ከዶክተር $name አዲስ መልዕክት አለዎት';
  }

  @override
  String get homeNewMessageNoAppointment => 'የተያያዘ ቀጠሮ የለም';

  @override
  String get homeUpcomingAppointmentsTitle => 'ቀጣይ ቀጠሮዎች';

  @override
  String get homeFindAppointmentCta => 'ቀጠሮ ፈልግ';

  @override
  String get homeNoAppointmentsEmptyDescription =>
      'እስካሁን ቀጠሮ የለዎትም። ሐኪም ፈልጉ እና የመጀመሪያዎን ቀጠሮ ያስይዙ።';

  @override
  String get homeLast3AppointmentsTitle => 'የመጨረሻ 3 ቀጠሮዎች';

  @override
  String get homeSeeAllPastAppointments => 'ሁሉንም ያለፉ ቀጠሮዎች ይመልከቱ';

  @override
  String get homeAppointmentHistoryTitle => 'የቀጠሮ ታሪክ';

  @override
  String get homeNoAppointmentHistory => 'ያለፉ ቀጠሮዎች የሉም';

  @override
  String get commonTryAgainLater => 'ቆይተህ እንደገና ሞክር።';

  @override
  String get commonTryAgain => 'እንደገና ሞክር';

  @override
  String get commonUnableToLoad => 'መጫን አልተቻለም';

  @override
  String get commonAvailableSoon => 'በቅርቡ ይገኛል';

  @override
  String get commonCancel => 'ይቅር';

  @override
  String get commonActionIsFinal => 'ይህ እርምጃ መመለስ አይቻልም።';

  @override
  String get commonTodo => 'ለማድረግ';

  @override
  String get commonToRead => 'ለማንበብ';

  @override
  String get commonSettings => 'ቅንብሮች';

  @override
  String get commonTryAgainInAMoment => 'በትንሹ ጊዜ ውስጥ እንደገና ሞክር።';

  @override
  String commonMinChars(int min) {
    return 'ቢያንስ $min ቁምፊዎች';
  }

  @override
  String get commonOnline => 'በመስመር ላይ';

  @override
  String get appointmentsTitle => 'ቀጠሮዎቼ';

  @override
  String get appointmentsTabUpcoming => 'ቀጣይ';

  @override
  String get appointmentsTabPast => 'ያለፉ';

  @override
  String get appointmentsNoUpcomingTitle => 'ቀጣይ ቀጠሮ የለም';

  @override
  String get appointmentsNoUpcomingSubtitle => 'ቀጣይ ቀጠሮዎችዎ እዚህ ይታያሉ።';

  @override
  String get appointmentsNoPastTitle => 'ያለፉ ቀጠሮ የለም';

  @override
  String get appointmentsNoPastSubtitle => 'የተጠናቀቁ ቀጠሮዎችዎ እዚህ ይታያሉ።';

  @override
  String get searchTitle => 'ፈልግ';

  @override
  String get searchHint => 'ሐኪም፣ ስፔሻሊቲ...';

  @override
  String get searchUnavailableTitle => 'ፍለጋ አይገኝም';

  @override
  String get searchNoResultsTitle => 'ውጤት የለም';

  @override
  String get searchNoResultsSubtitle => 'ሌላ ቃል ሞክር።';

  @override
  String get searchFilterTitle => 'ውጤቶችን አጣራ';

  @override
  String get searchFilterDate => 'የመገኘት ቀን';

  @override
  String get searchFilterDateToday => 'ዛሬ';

  @override
  String get searchFilterDateTomorrow => 'ነገ';

  @override
  String get searchFilterDateThisWeek => 'በዚህ ሳምንት';

  @override
  String get searchFilterDateNextWeek => 'በሚቀጥለው ሳምንት';

  @override
  String get searchFilterDateAny => 'ማንኛውም ቀን';

  @override
  String get searchFilterSpecialty => 'ስፔሻሊቲ';

  @override
  String get searchFilterSpecialtyAll => 'ሁሉም ስፔሻሊቲዎች';

  @override
  String get searchFilterKupatHolim => 'የጤና ፈንድ';

  @override
  String get searchFilterKupatHolimAll => 'ሁሉም ፈንዶች';

  @override
  String get searchFilterDistance => 'ከፍተኛ ርቀት';

  @override
  String get searchFilterDistanceAny => 'ያለ ገደብ';

  @override
  String get searchFilterApply => 'ማጣሪያዎችን ተግብር';

  @override
  String get searchFilterReset => 'ሁሉንም አጥፋ';

  @override
  String searchFilterActiveCount(int count) {
    return '$count ንቁ ማጣሪያዎች';
  }

  @override
  String get searchSortTitle => 'በ… ደርድር';

  @override
  String get searchSortAvailability => 'መገኘት';

  @override
  String get searchSortDistance => 'ርቀት';

  @override
  String get searchSortName => 'ስም';

  @override
  String get searchSortRating => 'ደረጃ';

  @override
  String get onboardingStep1Title => 'የሕክምና ቀጠሮ ያግኙ እና በቀላሉ ያስያዙ';

  @override
  String get onboardingStep2Title => 'ከሐኪሞችዎ ጋር በቀላሉ ይወያዩ';

  @override
  String get onboardingStep2Subtitle => 'ፈጣን እና ደህንነቱ የተጠበቀ መልዕክት ልውውጥ።';

  @override
  String get onboardingStep3Title => 'ማስታወሻዎች እና የቅርብ ጊዜ የሕክምና ማጠቃለያ';

  @override
  String get onboardingStep3Subtitle => 'ቀጠሮ እንዳትረሱ፦ ማስታወሻ እና አጭር ማጠቃለያዎች።';

  @override
  String get onboardingContinueButton => 'ቀጥል';

  @override
  String get onboardingStartButton => 'ጀምር';

  @override
  String get healthTitle => 'ጤናዬ';

  @override
  String get healthSubtitle => 'የጤና መገለጫዎን ያስተዳድሩ';

  @override
  String get healthProfileTitle => 'የጤና መገለጫ';

  @override
  String get healthProfileSubtitle => 'አስፈላጊ መረጃ ይሙሉ (እስራኤል)';

  @override
  String get healthProfileIntro =>
      'ይህ መረጃ በእስራኤል ሕክምናዎን ለማዘጋጀት ይረዳናል (ፈንድ፣ የቤተሰብ ሐኪም፣ አለርጂዎች ወዘተ).';

  @override
  String get healthProfileSave => 'አስቀምጥ';

  @override
  String get healthProfileSavedSnack => 'መገለጫ ተቀምጧል';

  @override
  String get healthProfileStepIdentity => 'መለያ';

  @override
  String get healthProfileStepKupatHolim => 'ፈንድ';

  @override
  String get healthProfileStepMedical => 'የሕክምና መረጃ';

  @override
  String get healthProfileStepEmergency => 'የአደጋ እንዲጠራ';

  @override
  String get healthProfileTeudatZehut => 'መታወቂያ ቁጥር';

  @override
  String get healthProfileDateOfBirth => 'የትውልድ ቀን';

  @override
  String get healthProfileSex => 'ፆታ';

  @override
  String get healthProfileSexFemale => 'ሴት';

  @override
  String get healthProfileSexMale => 'ወንድ';

  @override
  String get healthProfileSexOther => 'ሌላ';

  @override
  String get healthProfileKupatHolim => 'የጤና ፈንድ';

  @override
  String get healthProfileKupatMemberId => 'የአባል መለያ';

  @override
  String get healthProfileFamilyDoctor => 'የቤተሰብ ሐኪም';

  @override
  String get healthProfileEmergencyContactName => 'የአደጋ እንዲጠራ ስም';

  @override
  String get healthProfileEmergencyContactPhone => 'የአደጋ ስልክ';

  @override
  String get kupatClalit => 'Clalit';

  @override
  String get kupatMaccabi => 'Maccabi';

  @override
  String get kupatMeuhedet => 'Meuhedet';

  @override
  String get kupatLeumit => 'Leumit';

  @override
  String get kupatOther => 'ሌላ';

  @override
  String get healthMyFileSectionTitle => 'ፋይሌ';

  @override
  String get healthDocumentsTitle => 'ሰነዶች';

  @override
  String get healthDocumentsSubtitle => 'መድሀኒት ማዘዣ፣ ምርመራዎች፣ ሪፖርቶች';

  @override
  String get healthConditionsTitle => 'የሕክምና ሁኔታዎች';

  @override
  String get healthConditionsSubtitle => 'ታሪክ እና ሁኔታዎች';

  @override
  String get healthMedicationsTitle => 'መድሀኒቶች';

  @override
  String get healthMedicationsSubtitle => 'የአሁኑ ሕክምናዎች';

  @override
  String get healthAllergiesTitle => 'አለርጂዎች';

  @override
  String get healthAllergiesSubtitle => 'የታወቁ አለርጂዎች';

  @override
  String get healthVaccinationsTitle => 'ክትባቶች';

  @override
  String get healthVaccinationsSubtitle => 'የክትባት ታሪክ';

  @override
  String get healthUpToDateTitle => 'ሁሉም ዘመናዊ ነው';

  @override
  String get healthUpToDateSubtitle => 'አዲስ የጤና ማስታወሻዎች ሲኖሩ እናሳውቅዎታለን።';

  @override
  String get appointmentDetailTitle => 'የቀጠሮ ዝርዝሮች';

  @override
  String get appointmentDetailCancelledSnack => 'ቀጠሮ ተሰርዟል';

  @override
  String get appointmentDetailNotFoundTitle => 'ቀጠሮ አልተገኘም';

  @override
  String get appointmentDetailNotFoundSubtitle => 'ይህ ቀጠሮ አይገኝም ወይም ተሰርዟል።';

  @override
  String get appointmentDetailReschedule => 'ዳግም ያቅዱ';

  @override
  String get appointmentDetailCancelQuestion => 'ቀጠሮውን ልሰርዝ?';

  @override
  String get appointmentDetailPreparationTitle => 'አስቀድሞ ዝግጅት ያስፈልጋል';

  @override
  String get appointmentDetailPreparationSubtitle => 'ጉብኝትዎን አስቀድሞ ያዘጋጁ።';

  @override
  String get appointmentDetailPrepQuestionnaire => 'የጤና መጠይቅ ሙሉ';

  @override
  String get appointmentDetailPrepInstructions => 'መመሪያዎችን ይመልከቱ';

  @override
  String get appointmentPrepQuestionnaireSubtitle =>
      'መደበኛ መጠይቅ (backend-ready)';

  @override
  String get appointmentPrepInstructionsSubtitle => 'ከጉብኝት በፊት አስፈላጊ መረጃ';

  @override
  String get appointmentPrepQuestionSymptoms => 'ምክንያት / ምልክቶች (በአጭር)';

  @override
  String get appointmentPrepQuestionAllergies => 'አለርጂዎች (አማራጭ)';

  @override
  String get appointmentPrepQuestionMedications => 'የአሁኑ መድሀኒቶች (አማራጭ)';

  @override
  String get appointmentPrepQuestionOther => 'ተጨማሪ መረጃ (አማራጭ)';

  @override
  String get appointmentPrepConsentLabel => 'ይህን መረጃ ከሐኪሙ ጋር ለመጋራት እስማማለሁ';

  @override
  String get appointmentPrepConsentRequired => 'ለመቀጠል እባክዎ ያረጋግጡ።';

  @override
  String get appointmentPrepSavedSnack => 'ዝግጅት ተቀምጧል';

  @override
  String get appointmentPrepSubmit => 'ላክ';

  @override
  String get appointmentPrepInstruction1 => 'መታወቂያ እና የኢንሹራንስ ካርድ ይዘው ይምጡ።';

  @override
  String get appointmentPrepInstruction2 => '10 ደቂቃ ቀድሞ ይድረሱ።';

  @override
  String get appointmentPrepInstruction3 => 'አስፈላጊ የሕክምና ሰነዶችን አዘጋጁ።';

  @override
  String get appointmentPrepInstructionsAccept => 'እነዚህን መመሪያዎች አንብቤ ተቀብያለሁ';

  @override
  String get appointmentDetailSendDocsTitle => 'ሰነዶችን ላክ';

  @override
  String get appointmentDetailSendDocsSubtitle => 'ከቀጠሮው በፊት ሰነዶችን ለሐኪሙ ላክ።';

  @override
  String get appointmentDetailAddDocs => 'ሰነዶች ጨምር';

  @override
  String get appointmentDetailEarlierSlotTitle => 'ቀድሞ ሰዓት ትፈልጋለህ?';

  @override
  String get appointmentDetailEarlierSlotSubtitle =>
      'ቀድሞ ቦታ ቢከፈት ማስጠንቀቂያ ተቀበል።';

  @override
  String get appointmentDetailEnableAlerts => 'ማስጠንቀቂያዎችን አንቃ';

  @override
  String get appointmentDetailContactOffice => 'ቢሮውን አግኝ';

  @override
  String get appointmentDetailVisitSummaryTitle => 'የጉብኝት ማጠቃለያ';

  @override
  String get appointmentDetailVisitSummarySubtitle => 'ዋና ነጥቦች እና ቀጣይ እርምጃዎች';

  @override
  String get appointmentDetailVisitSummaryDemo =>
      'ክሊኒካዊ ምርመራ ተጠናቋል። በ3 ወራት ውስጥ ክትትል ይመከራል እና ሕክምናውን እንደ አስፈላጊነት ይቀጥሉ።';

  @override
  String get appointmentDetailDoctorReportTitle => 'የዶክተር ሪፖርት';

  @override
  String get appointmentDetailDoctorReportSubtitle => 'ከጉብኝት በኋላ የተጻፈ ማስታወሻ';

  @override
  String get appointmentDetailDoctorReportDemo =>
      'ታካሚው/ዋ ለምክክር መጥቷል/ታለች። አሳሳቢ ውጤት አልተገኘም። ክትትል ይመከራል እና በሚቀጥለው ቀጠሮ ተዛማጅ ሰነዶችን ይዘው ይምጡ።';

  @override
  String get appointmentDetailDocumentsAndRxTitle => 'ሰነዶች እና መድሀኒት ማዘዣ';

  @override
  String get appointmentDetailDocumentsAndRxSubtitle =>
      'ከጉብኝት በኋላ የተጋሩ ሰነዶችን ያግኙ';

  @override
  String get appointmentDetailOpenVisitReport => 'የጉብኝት ሪፖርት ክፈት';

  @override
  String get appointmentDetailOpenPrescription => 'መድሀኒት ማዘዣ ክፈት';

  @override
  String get appointmentDetailSendMessageCta => 'ለቢሮው መልዕክት ላክ';

  @override
  String get messagesTitle => 'መልዕክቶች';

  @override
  String get messagesMarkAllRead => 'ሁሉንም እንደተነበበ ምልክት አድርግ';

  @override
  String get messagesEmptyTitle => 'መልዕክቶችዎ';

  @override
  String get messagesEmptySubtitle =>
      'ሰነድ ለመጠየቅ፣ ጥያቄ ለመጠየቅ ወይም ውጤቶችን ለመከታተል ከሐኪሞችዎ ጋር ውይይት ጀምሩ።';

  @override
  String get messagesNewMessageTitle => 'አዲስ መልዕክት';

  @override
  String get messagesWriteToOfficeTitle => 'ለቢሮው ጻፍ';

  @override
  String get messagesResponseTime => 'መልስ በ24–48 ሰዓት ውስጥ።';

  @override
  String get messagesSubjectLabel => 'ርዕስ';

  @override
  String get messagesSubjectHint => 'ለምሳሌ፡ ውጤቶች፣ ጥያቄ…';

  @override
  String get messagesSubjectRequired => 'ርዕስ ያስፈልጋል';

  @override
  String get messagesMessageLabel => 'መልዕክት';

  @override
  String get messagesMessageHint => 'መልዕክትዎን ይጻፉ…';

  @override
  String get messagesSendButton => 'ላክ';

  @override
  String get conversationTitle => 'ውይይት';

  @override
  String get conversationNewMessageTooltip => 'አዲስ መልዕክት';

  @override
  String get conversationWriteMessageHint => 'መልዕክት ጻፍ…';

  @override
  String get practitionerTitle => 'ሐኪም';

  @override
  String get practitionerUnavailableTitle => 'ሐኪሙ አይገኝም';

  @override
  String get practitionerNotFoundTitle => 'ሐኪም አልተገኘም';

  @override
  String get practitionerNotFoundSubtitle => 'ይህ መገለጫ አይገኝም።';

  @override
  String get practitionerBookAppointment => 'ቀጠሮ ያስያዙ';

  @override
  String get practitionerSendMessage => 'መልዕክት ላክ';

  @override
  String get practitionerAvailabilities => 'መገኘት';

  @override
  String get practitionerAddress => 'አድራሻ';

  @override
  String get practitionerProfileSection => 'መገለጫ';

  @override
  String get documentsTitle => 'ሰነዶች';

  @override
  String get documentsEmptyTitle => 'ሰነዶች የሉም';

  @override
  String get documentsEmptySubtitle => 'መድሀኒት ማዘዣዎችዎ እና ውጤቶችዎ እዚህ ይታያሉ።';

  @override
  String get documentsOpen => 'ክፈት';

  @override
  String get documentsShare => 'አጋራ';

  @override
  String get authLogout => 'ውጣ';

  @override
  String get securityTitle => 'ደህንነት';

  @override
  String get securitySecureAccountTitle => 'መለያዎን ያስጠብቁ';

  @override
  String get securitySecureAccountSubtitle => 'መረጃዎን ያዘምኑ';

  @override
  String get securityChangePassword => 'የይለፍ ቃል ቀይር';

  @override
  String get securityChangePasswordSuccess => 'ጥያቄው ተቀምጧል';

  @override
  String get securityCurrentPassword => 'የአሁኑ የይለፍ ቃል';

  @override
  String get securityNewPassword => 'አዲስ የይለፍ ቃል';

  @override
  String get accountTitle => 'መለያዬ';

  @override
  String get accountTaglineTitle => 'ጤናዎ። ውሂብዎ።';

  @override
  String get accountTaglineSubtitle => 'የግላዊነትዎ ጥበቃ ቀዳሚ ነው።';

  @override
  String get accountPersonalInfoSection => 'ግላዊ መረጃ';

  @override
  String get accountMyProfile => 'መገለጫዬ';

  @override
  String get accountMyRelatives => 'ዘመዶቼ';

  @override
  String get accountSectionTitle => 'መለያ';

  @override
  String get privacyTitle => 'ግላዊነት';

  @override
  String get privacyYourDataTitle => 'ውሂብዎ';

  @override
  String get privacyYourDataSubtitle => 'መረጃዎን እንጠብቃለን እና መዳረሻን እንገድባለን።';

  @override
  String get privacySharingTitle => 'ማጋራት';

  @override
  String get privacySharingSubtitle => 'ከሐኪሞችዎ ጋር የሚጋሩትን ሰነዶች ተቆጣጠሩ።';

  @override
  String get privacyExportTitle => 'ወደ ውጭ ላክ';

  @override
  String get privacyExportSubtitle => 'ውሂብዎን በማንኛውም ጊዜ ወደ ውጭ ላክ።';

  @override
  String get paymentTitle => 'ክፍያ';

  @override
  String get paymentEmptyTitle => 'የክፍያ መንገድ የለም';

  @override
  String get paymentEmptySubtitle => 'ክፍያን ለማቀላጠፍ ካርድ ያክሉ።';

  @override
  String paymentExpires(Object expiry) {
    return 'ያበቃው $expiry';
  }

  @override
  String get relativesTitle => 'ዘመዶቼ';

  @override
  String get relativesEmptyTitle => 'ዘመድ የለም';

  @override
  String get relativesEmptySubtitle => 'በስማቸው ቀጠሮ ለማስያዝ ዘመዶችን ያክሉ።';

  @override
  String get settingsUnavailableTitle => 'ቅንብሮች አይገኙም';

  @override
  String get settingsUnavailableSubtitle => 'ምርጫዎችዎን መጫን አልተቻለም።';

  @override
  String get settingsNotificationsTitle => 'ማሳወቂያዎች';

  @override
  String get settingsNotificationsSubtitle => 'መልዕክቶችን እና ዝማኔዎችን ተቀበል';

  @override
  String get settingsRemindersTitle => 'የቀጠሮ ማስታወሻዎች';

  @override
  String get settingsRemindersSubtitle => 'ከቀጠሮዎ በፊት ማስታወሻ ተቀበል';

  @override
  String get settingsLanguageTitle => 'ቋንቋ';

  @override
  String get settingsLanguageCurrentLabel => 'አማርኛ (አሁን)';

  @override
  String get settingsLanguageShortLabel => 'አማርኛ';

  @override
  String get profileTitle => 'መገለጫዬ';

  @override
  String get profileUnavailableTitle => 'መገለጫ አይገኝም';

  @override
  String get profileUnavailableSubtitle => 'መረጃዎ አይገኝም።';

  @override
  String get profileIdentitySection => 'መለያ';

  @override
  String get commonName => 'ስም';

  @override
  String get commonAddress => 'አድራሻ';

  @override
  String get commonCity => 'ከተማ';

  @override
  String get profileMedicalInfoSection => 'የሕክምና መረጃ';

  @override
  String get profileBloodType => 'የደም አይነት';

  @override
  String get profileHeight => 'ቁመት';

  @override
  String get profileWeight => 'ክብደት';

  @override
  String get bookingSelectPatientTitle => 'ይህ ቀጠሮ ለማን ነው?';

  @override
  String get bookingPatientsUnavailableTitle => 'ታካሚዎች አይገኙም';

  @override
  String get bookingAddRelative => 'ዘመድ ጨምር';

  @override
  String get commonMe => 'እኔ';

  @override
  String get bookingSelectSlotTitle => 'ቀን ይምረጡ';

  @override
  String get bookingSelectSlotSubtitle => 'የሚገኝ ቀን እና ሰዓት ይምረጡ።';

  @override
  String get bookingSeeMoreDates => 'ተጨማሪ ቀናት ይመልከቱ';

  @override
  String get commonSelected => 'ተመርጧል';

  @override
  String get bookingInstructionsTitle => 'መመሪያዎች';

  @override
  String get bookingInstructionsSubtitle => 'ከቀጠሮው በፊት እባክዎ እነዚህን ነጥቦች ያረጋግጡ።';

  @override
  String get bookingInstructionsBullet1 =>
      'የኢንሹራንስ ካርድዎን እና ካስፈለገ መድሀኒት ማዘዣ ይዘው ይምጡ።';

  @override
  String get bookingInstructionsBullet2 => 'ለሥነ-ስርዓት 10 ደቂቃ ቀድሞ ይድረሱ።';

  @override
  String get bookingInstructionsBullet3 => 'ለመሰረዝ ከተገደዱ በቶሎ እንዲቻል ያሳውቁን።';

  @override
  String get bookingInstructionsAccept => 'እነዚህን መመሪያዎች አንብቤ ተቀብያለሁ።';

  @override
  String get bookingConfirmTitle => 'ቀጠሮውን ያረጋግጡ';

  @override
  String get bookingConfirmSubtitle => 'ከማረጋገጥ በፊት መረጃውን ያረጋግጡ።';

  @override
  String get bookingReasonLabel => 'ምክንያት';

  @override
  String get bookingPatientLabel => 'ታካሚ';

  @override
  String get bookingSlotLabel => 'ሰዓት';

  @override
  String get bookingMissingInfoTitle => 'መረጃ ጎድሏል';

  @override
  String get bookingZipCodeLabel => 'ፖስታ ኮድ';

  @override
  String get bookingVisitedBeforeQuestion => 'ከዚህ ሐኪም በፊት ተመልከተዋል?';

  @override
  String get commonYes => 'አዎ';

  @override
  String get commonNo => 'አይ';

  @override
  String get bookingConfirmButton => 'ቀጠሮውን አረጋግጥ';

  @override
  String get bookingChangeSlotButton => 'ሰዓት ቀይር';

  @override
  String get bookingSuccessTitle => 'ቀጠሮ ተረጋግጧል';

  @override
  String get bookingSuccessSubtitle => 'ማረጋገጫ ወደ ኢሜይልዎ ላክን።';

  @override
  String get bookingAddToCalendar => 'ወደ ቀን መቁጠሪያዬ ጨምር';

  @override
  String get bookingBookAnotherAppointment => 'ሌላ ቀጠሮ ያስያዙ';

  @override
  String get bookingSendDocsSubtitle => 'ለቀጠሮው ሰነዶችን ለሐኪሙ ላክ።';

  @override
  String get bookingViewMyAppointments => 'ቀጠሮዎቼን ይመልከቱ';

  @override
  String get bookingBackToHome => 'ወደ መነሻ';

  @override
  String get vaccinationsEmptyTitle => 'የተመዘገቡ ክትባቶች የሉም';

  @override
  String get vaccinationsEmptySubtitle => 'ክትባቶችን እና ማስታወሻዎችን ተከታተሉ።';

  @override
  String get allergiesEmptyTitle => 'አለርጂ የለም';

  @override
  String get allergiesEmptySubtitle => 'ለደህንነትዎ አለርጂዎችን ያሳውቁ።';

  @override
  String get medicationsEmptyTitle => 'መድሀኒት የለም';

  @override
  String get medicationsEmptySubtitle => 'የአሁኑን ሕክምናዎች ያክሉ።';

  @override
  String get conditionsEmptyTitle => 'ሁኔታ የለም';

  @override
  String get conditionsEmptySubtitle => 'ለቀጠሮዎችዎ የሕክምና ታሪክ ያክሉ።';

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
  String get errorGenericTryAgain => 'ስህተት ተከስቷል። እንደገና ሞክር።';

  @override
  String get authSignInFailedTryAgain => 'መግባት አልተሳካም። እንደገና ሞክር።';

  @override
  String get authSignUpFailedTryAgain => 'መመዝገብ አልተሳካም። እንደገና ሞክር።';

  @override
  String get errorUnableToConfirmAppointment => 'ቀጠሮውን ማረጋገጥ አልተቻለም።';

  @override
  String get errorUnableToLoadProfile => 'መገለጫውን መጫን አልተቻለም።';

  @override
  String get errorUnableToReadHistoryState => 'የታሪክ ሁኔታን ማንበብ አልተቻለም።';

  @override
  String get errorUnableToEnableHistory => 'ታሪክን ማንቃት አልተቻለም።';

  @override
  String get errorUnableToLoadRelatives => 'ዘመዶችን መጫን አልተቻለም።';

  @override
  String get errorUnableToAddRelative => 'ዘመድ መጨመር አልተቻለም።';

  @override
  String get errorUnableToLoadPayments => 'ክፍያዎችን መጫን አልተቻለም።';

  @override
  String get errorUnableToAddPaymentMethod => 'የክፍያ መንገድ መጨመር አልተቻለም።';

  @override
  String get errorUnableToLoadHealthData => 'የጤና ውሂብን መጫን አልተቻለም።';

  @override
  String get errorUnableToAddHealthItem => 'ንጥል መጨመር አልተቻለም።';

  @override
  String get errorUnableToLoadHealthProfile => 'የጤና መገለጫውን መጫን አልተቻለም።';

  @override
  String get errorUnableToSaveHealthProfile => 'የጤና መገለጫውን ማስቀመጥ አልተቻለም።';

  @override
  String get errorUnableToLoadPractitioner => 'ሐኪሙን መጫን አልተቻለም።';

  @override
  String get errorUnableToLoadSearch => 'ፍለጋን መጫን አልተቻለም።';

  @override
  String get errorUnableToLoadDocuments => 'ሰነዶችን መጫን አልተቻለም።';

  @override
  String get errorUnableToAddDocument => 'ሰነዱን መጨመር አልተቻለም።';

  @override
  String get errorUnableToReadSettings => 'ቅንብሮችን ማንበብ አልተቻለም።';

  @override
  String get errorUnableToSaveSettings => 'ቅንብሮችን ማስቀመጥ አልተቻለም።';

  @override
  String get errorUnableToLoadUpcomingAppointments => 'ቀጣይ ቀጠሮዎችን መጫን አልተቻለም።';

  @override
  String get errorUnableToLoadHistory => 'ታሪክን መጫን አልተቻለም።';

  @override
  String get errorUnableToLoadAppointment => 'ቀጠሮውን መጫን አልተቻለም።';

  @override
  String get errorUnableToCancelAppointment => 'ቀጠሮውን መሰረዝ አልተቻለም።';

  @override
  String get errorUnableToLoadConversations => 'ውይይቶችን መጫን አልተቻለም።';

  @override
  String get errorUnableToLoadConversation => 'ውይይቱን መጫን አልተቻለም።';

  @override
  String get errorUnableToSendMessage => 'መልዕክት መላክ አልተቻለም።';

  @override
  String get errorUnableToReadOnboardingState =>
      'የመጀመሪያ መመሪያ ሁኔታን ማንበብ አልተቻለም።';

  @override
  String get errorUnableToSaveOnboarding => 'የመጀመሪያ መመሪያን ማስቀመጥ አልተቻለም።';

  @override
  String timeMinutesAgo(int minutes) {
    return 'ከ$minutes ደቂቃ በፊት';
  }

  @override
  String timeHoursAgo(int hours) {
    return 'ከ$hours ሰዓት በፊት';
  }

  @override
  String timeDaysAgo(int days) {
    return 'ከ$days ቀን በፊት';
  }

  @override
  String get demoDentalOfficeName => 'የጥርስ ክሊኒክ';

  @override
  String get demoConversation1LastMessage => 'ሰላም፣ ውጤቶችዎ ዝግጁ ናቸው...';

  @override
  String get demoConversation2LastMessage => 'በጣም ጥሩ፣ ሰነዱን እልክልዎታለሁ!';

  @override
  String get demoConversation3LastMessage => 'ስለ ጉብኝትዎ እናመሰግናለን!';

  @override
  String get demoAppointmentConsultation => 'ምክክር';

  @override
  String get demoAppointmentFollowUp => 'የሕክምና ክትትል';

  @override
  String get demoShortDateThu19Feb => 'ሐሙስ 19 ፌብ';

  @override
  String get demoShortDateMon15Feb => 'ሰኞ 15 ፌብ';

  @override
  String get demoMessage1_1 => 'ሰላም፣ እንዴት ልንረዳ?';

  @override
  String get demoMessage1_2 => 'ሰላም፣ ሪፖርቴን መቀበል እፈልጋለሁ።';

  @override
  String get demoMessage1_3 => 'እሺ፣ የቀጠሮውን ቀን መግለጽ ትችላለህ?';

  @override
  String get demoMessage2_1 => 'ሰላም፣ ፋይልዎ ዘመናዊ ነው።';

  @override
  String get demoMessage3_1 => 'ሰላም!';

  @override
  String get demoMessage3_2 => 'አመሰግናለሁ ዶክተር።';

  @override
  String get relativeRelation => 'ዘመድ';

  @override
  String get relativeChild => 'ልጅ';

  @override
  String get relativeParent => 'ወላጅ';

  @override
  String relativeDemoName(int index) {
    return 'ዘመድ $index';
  }

  @override
  String relativeLabel(Object relation, int year) {
    return '$relation • $year';
  }

  @override
  String documentsDemoTitle(int index) {
    return 'ሰነድ $index';
  }

  @override
  String get documentsDemoTypeLabel => 'ሪፖርት';

  @override
  String get documentsDemoDateLabelToday => 'ዛሬ';

  @override
  String get demoSpecialtyOphthalmologist => 'የዓይን ሐኪም';

  @override
  String get demoSpecialtyGeneralPractitioner => 'አጠቃላይ ሐኪም';

  @override
  String get demoPractitionerAbout =>
      'የዓይን ሐኪም የዓይን በሽታዎችን ይታከማል እና ሪፍራክሽን፣ ፍታ (strabismus) እና የእይታ ችግኝ ያስተዳድራል።\n\nይህ መገለጫ ከbackend ጋር ለመገናኘት ዝግጁ ነው።';

  @override
  String demoAvailabilityTodayAt(Object time) {
    return 'ዛሬ • $time';
  }

  @override
  String demoAvailabilityTomorrowAt(Object time) {
    return 'ነገ • $time';
  }

  @override
  String demoAvailabilityThisWeekAt(Object time) {
    return 'በዚህ ሳምንት • $time';
  }

  @override
  String demoSearchPractitionerName(int index) {
    return 'ዶ/ር ሐኪም $index';
  }

  @override
  String get demoSearchAddress => '75019 ፓሪስ • Avenue Secrétan';

  @override
  String get demoSearchSector1 => 'ሴክተር 1';

  @override
  String get demoAvailabilityToday => 'ዛሬ';

  @override
  String get demoAvailabilityThisWeek => 'በዚህ ሳምንት';

  @override
  String get demoDistance12km => '1.2 ኪሜ';

  @override
  String get demoAppointmentDateThu19Feb => 'ሐሙስ፣ ፌብሩወሪ 19';

  @override
  String get demoAppointmentReasonNewPatientConsultation => 'ምክክር (አዲስ ታካሚ)';

  @override
  String get demoPractitionerNameMarc => 'ዶ/ር ማርክ BENHAMOU';

  @override
  String get demoPractitionerNameSarah => 'ዶ/ር ሳራ COHEN';

  @override
  String get demoPractitionerNameNoam => 'ዶ/ር ኖአም LEVI';

  @override
  String get demoPractitionerNameMarcShort => 'ዶ/ር ማርክ B.';

  @override
  String get demoPractitionerNameSophie => 'ዶ/ር ሶፊ L.';

  @override
  String get demoPatientNameTom => 'ቶም';

  @override
  String get demoAddressParis => '28, avenue Secrétan, 75019 ፓሪስ';

  @override
  String get demoProfileFullName => 'ቶም ጃሚ';

  @override
  String get demoProfileEmail => 'tom@domaine.com';

  @override
  String get demoProfileCity => '75019 ፓሪስ';

  @override
  String get demoPaymentBrandVisa => 'Visa';

  @override
  String get commonInitialsFallback => 'እኔ';

  @override
  String get navHome => 'መነሻ';

  @override
  String get navAppointments => 'ቀጠሮዎች';

  @override
  String get navHealth => 'ጤና';

  @override
  String get navMessages => 'መልዕክቶች';

  @override
  String get navAccount => 'መለያ';
}
