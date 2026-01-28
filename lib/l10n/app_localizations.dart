import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('he'),
  ];

  /// No description provided for @commonError.
  ///
  /// In he, this message translates to:
  /// **'שגיאה'**
  String get commonError;

  /// No description provided for @commonEmail.
  ///
  /// In he, this message translates to:
  /// **'אימייל'**
  String get commonEmail;

  /// No description provided for @commonEmailHint.
  ///
  /// In he, this message translates to:
  /// **'לדוגמה: name@domain.com'**
  String get commonEmailHint;

  /// No description provided for @commonEmailRequired.
  ///
  /// In he, this message translates to:
  /// **'נדרש אימייל'**
  String get commonEmailRequired;

  /// No description provided for @commonEmailInvalid.
  ///
  /// In he, this message translates to:
  /// **'אימייל לא תקין'**
  String get commonEmailInvalid;

  /// No description provided for @commonPassword.
  ///
  /// In he, this message translates to:
  /// **'סיסמה'**
  String get commonPassword;

  /// No description provided for @commonPasswordHint.
  ///
  /// In he, this message translates to:
  /// **'••••••••'**
  String get commonPasswordHint;

  /// No description provided for @commonPasswordRequired.
  ///
  /// In he, this message translates to:
  /// **'נדרשת סיסמה'**
  String get commonPasswordRequired;

  /// No description provided for @commonPasswordMinChars.
  ///
  /// In he, this message translates to:
  /// **'מינימום {min} תווים'**
  String commonPasswordMinChars(int min);

  /// No description provided for @authLoginTitle.
  ///
  /// In he, this message translates to:
  /// **'התחברות'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In he, this message translates to:
  /// **'גישה לפגישות, הודעות ומסמכים שלך.'**
  String get authLoginSubtitle;

  /// No description provided for @authLoginButton.
  ///
  /// In he, this message translates to:
  /// **'התחבר'**
  String get authLoginButton;

  /// No description provided for @authForgotPasswordCta.
  ///
  /// In he, this message translates to:
  /// **'שכחת סיסמה?'**
  String get authForgotPasswordCta;

  /// No description provided for @authCreateAccountCta.
  ///
  /// In he, this message translates to:
  /// **'צור חשבון'**
  String get authCreateAccountCta;

  /// No description provided for @authContinueWithoutAccount.
  ///
  /// In he, this message translates to:
  /// **'המשך ללא חשבון'**
  String get authContinueWithoutAccount;

  /// No description provided for @authRegisterTitle.
  ///
  /// In he, this message translates to:
  /// **'צור חשבון'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In he, this message translates to:
  /// **'כל השדות חובה.'**
  String get authRegisterSubtitle;

  /// No description provided for @authFirstName.
  ///
  /// In he, this message translates to:
  /// **'שם פרטי'**
  String get authFirstName;

  /// No description provided for @authLastName.
  ///
  /// In he, this message translates to:
  /// **'שם משפחה'**
  String get authLastName;

  /// No description provided for @commonRequired.
  ///
  /// In he, this message translates to:
  /// **'חובה'**
  String get commonRequired;

  /// No description provided for @commonContinue.
  ///
  /// In he, this message translates to:
  /// **'המשך'**
  String get commonContinue;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In he, this message translates to:
  /// **'כבר יש לי חשבון'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In he, this message translates to:
  /// **'שכחת סיסמה'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In he, this message translates to:
  /// **'נשלח לך קישור לאיפוס.'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authForgotPasswordSendLink.
  ///
  /// In he, this message translates to:
  /// **'שלח קישור'**
  String get authForgotPasswordSendLink;

  /// No description provided for @authBackToLogin.
  ///
  /// In he, this message translates to:
  /// **'חזרה להתחברות'**
  String get authBackToLogin;

  /// No description provided for @authForgotPasswordEmailSent.
  ///
  /// In he, this message translates to:
  /// **'האימייל נשלח. בדוק את תיבת הדואר שלך.'**
  String get authForgotPasswordEmailSent;

  /// No description provided for @authVerifyEmailTitle.
  ///
  /// In he, this message translates to:
  /// **'אמת את האימייל שלך'**
  String get authVerifyEmailTitle;

  /// No description provided for @authVerifyEmailDescription.
  ///
  /// In he, this message translates to:
  /// **'שלחנו אימייל אימות לכתובת {email}. לחץ על הקישור באימייל וחזור לאפליקציה.'**
  String authVerifyEmailDescription(Object email);

  /// No description provided for @authVerifyEmailCheckedBackToLogin.
  ///
  /// In he, this message translates to:
  /// **'אישרתי, חזרה להתחברות'**
  String get authVerifyEmailCheckedBackToLogin;

  /// No description provided for @authVerifyEmailResend.
  ///
  /// In he, this message translates to:
  /// **'שלח שוב את האימייל'**
  String get authVerifyEmailResend;

  /// No description provided for @authVerifyEmailResentSnack.
  ///
  /// In he, this message translates to:
  /// **'אימייל האימות נשלח מחדש.'**
  String get authVerifyEmailResentSnack;

  /// No description provided for @commonBack.
  ///
  /// In he, this message translates to:
  /// **'חזרה'**
  String get commonBack;

  /// No description provided for @homeMyPractitioners.
  ///
  /// In he, this message translates to:
  /// **'הרופאים שלי'**
  String get homeMyPractitioners;

  /// No description provided for @homeHistory.
  ///
  /// In he, this message translates to:
  /// **'היסטוריה'**
  String get homeHistory;

  /// No description provided for @homeGreeting.
  ///
  /// In he, this message translates to:
  /// **'שלום {name}'**
  String homeGreeting(Object name);

  /// No description provided for @homeSearchHint.
  ///
  /// In he, this message translates to:
  /// **'רופא, התמחות...'**
  String get homeSearchHint;

  /// No description provided for @homeHealthTip1.
  ///
  /// In he, this message translates to:
  /// **'השנה, מאמצים הרגלי בריאות נכונים.'**
  String get homeHealthTip1;

  /// No description provided for @homeHealthTip2.
  ///
  /// In he, this message translates to:
  /// **'עדיין אפשר להתחסן.'**
  String get homeHealthTip2;

  /// No description provided for @homeCompleteHealthProfile.
  ///
  /// In he, this message translates to:
  /// **'השלם את פרופיל הבריאות שלך'**
  String get homeCompleteHealthProfile;

  /// No description provided for @homeCompleteHealthProfileSubtitle.
  ///
  /// In he, this message translates to:
  /// **'קבל תזכורות מותאמות והכן את הביקורים שלך'**
  String get homeCompleteHealthProfileSubtitle;

  /// No description provided for @homeStart.
  ///
  /// In he, this message translates to:
  /// **'התחל'**
  String get homeStart;

  /// No description provided for @homeNoRecentPractitioner.
  ///
  /// In he, this message translates to:
  /// **'אין רופא אחרון'**
  String get homeNoRecentPractitioner;

  /// No description provided for @homeHistoryDescription.
  ///
  /// In he, this message translates to:
  /// **'ניתן להציג את רשימת הרופאים שבהם ביקרת'**
  String get homeHistoryDescription;

  /// No description provided for @homeHistoryEnabledSnack.
  ///
  /// In he, this message translates to:
  /// **'היסטוריה הופעלה'**
  String get homeHistoryEnabledSnack;

  /// No description provided for @homeHistoryEnabled.
  ///
  /// In he, this message translates to:
  /// **'היסטוריה הופעלה'**
  String get homeHistoryEnabled;

  /// No description provided for @homeActivateHistory.
  ///
  /// In he, this message translates to:
  /// **'הפעל היסטוריה'**
  String get homeActivateHistory;

  /// No description provided for @homeNewMessageTitle.
  ///
  /// In he, this message translates to:
  /// **'מחכה לך הודעה חדשה מ־{name}'**
  String homeNewMessageTitle(Object name);

  /// No description provided for @homeNewMessageNoAppointment.
  ///
  /// In he, this message translates to:
  /// **'ללא תור משויך'**
  String get homeNewMessageNoAppointment;

  /// No description provided for @homeUpcomingAppointmentsTitle.
  ///
  /// In he, this message translates to:
  /// **'תורים קרובים'**
  String get homeUpcomingAppointmentsTitle;

  /// No description provided for @homeLast3AppointmentsTitle.
  ///
  /// In he, this message translates to:
  /// **'3 התורים האחרונים'**
  String get homeLast3AppointmentsTitle;

  /// No description provided for @homeSeeAllPastAppointments.
  ///
  /// In he, this message translates to:
  /// **'צפה בכל התורים שעברו'**
  String get homeSeeAllPastAppointments;

  /// No description provided for @homeAppointmentHistoryTitle.
  ///
  /// In he, this message translates to:
  /// **'היסטוריית תורים'**
  String get homeAppointmentHistoryTitle;

  /// No description provided for @homeNoAppointmentHistory.
  ///
  /// In he, this message translates to:
  /// **'אין היסטוריית תורים'**
  String get homeNoAppointmentHistory;

  /// No description provided for @commonTryAgainLater.
  ///
  /// In he, this message translates to:
  /// **'נסה שוב מאוחר יותר.'**
  String get commonTryAgainLater;

  /// No description provided for @commonUnableToLoad.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון'**
  String get commonUnableToLoad;

  /// No description provided for @commonAvailableSoon.
  ///
  /// In he, this message translates to:
  /// **'זמין בקרוב'**
  String get commonAvailableSoon;

  /// No description provided for @commonCancel.
  ///
  /// In he, this message translates to:
  /// **'ביטול'**
  String get commonCancel;

  /// No description provided for @commonActionIsFinal.
  ///
  /// In he, this message translates to:
  /// **'פעולה זו היא סופית.'**
  String get commonActionIsFinal;

  /// No description provided for @commonTodo.
  ///
  /// In he, this message translates to:
  /// **'לביצוע'**
  String get commonTodo;

  /// No description provided for @commonToRead.
  ///
  /// In he, this message translates to:
  /// **'לקריאה'**
  String get commonToRead;

  /// No description provided for @commonSettings.
  ///
  /// In he, this message translates to:
  /// **'הגדרות'**
  String get commonSettings;

  /// No description provided for @commonTryAgainInAMoment.
  ///
  /// In he, this message translates to:
  /// **'נסה שוב בעוד רגע.'**
  String get commonTryAgainInAMoment;

  /// No description provided for @commonMinChars.
  ///
  /// In he, this message translates to:
  /// **'מינימום {min} תווים'**
  String commonMinChars(int min);

  /// No description provided for @commonOnline.
  ///
  /// In he, this message translates to:
  /// **'מחובר'**
  String get commonOnline;

  /// No description provided for @appointmentsTitle.
  ///
  /// In he, this message translates to:
  /// **'התורים שלי'**
  String get appointmentsTitle;

  /// No description provided for @appointmentsTabUpcoming.
  ///
  /// In he, this message translates to:
  /// **'בקרוב'**
  String get appointmentsTabUpcoming;

  /// No description provided for @appointmentsTabPast.
  ///
  /// In he, this message translates to:
  /// **'עבר'**
  String get appointmentsTabPast;

  /// No description provided for @appointmentsNoUpcomingTitle.
  ///
  /// In he, this message translates to:
  /// **'אין תורים קרובים'**
  String get appointmentsNoUpcomingTitle;

  /// No description provided for @appointmentsNoUpcomingSubtitle.
  ///
  /// In he, this message translates to:
  /// **'התורים הבאים שלך יופיעו כאן.'**
  String get appointmentsNoUpcomingSubtitle;

  /// No description provided for @appointmentsNoPastTitle.
  ///
  /// In he, this message translates to:
  /// **'אין תורים קודמים'**
  String get appointmentsNoPastTitle;

  /// No description provided for @appointmentsNoPastSubtitle.
  ///
  /// In he, this message translates to:
  /// **'תורים שהסתיימו יופיעו כאן.'**
  String get appointmentsNoPastSubtitle;

  /// No description provided for @searchTitle.
  ///
  /// In he, this message translates to:
  /// **'חיפוש'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In he, this message translates to:
  /// **'רופא, התמחות...'**
  String get searchHint;

  /// No description provided for @searchUnavailableTitle.
  ///
  /// In he, this message translates to:
  /// **'החיפוש אינו זמין'**
  String get searchUnavailableTitle;

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In he, this message translates to:
  /// **'אין תוצאות'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsSubtitle.
  ///
  /// In he, this message translates to:
  /// **'נסה מונח אחר.'**
  String get searchNoResultsSubtitle;

  /// No description provided for @searchFilterTitle.
  ///
  /// In he, this message translates to:
  /// **'סינון תוצאות'**
  String get searchFilterTitle;

  /// No description provided for @searchFilterDate.
  ///
  /// In he, this message translates to:
  /// **'תאריך זמינות'**
  String get searchFilterDate;

  /// No description provided for @searchFilterDateToday.
  ///
  /// In he, this message translates to:
  /// **'היום'**
  String get searchFilterDateToday;

  /// No description provided for @searchFilterDateTomorrow.
  ///
  /// In he, this message translates to:
  /// **'מחר'**
  String get searchFilterDateTomorrow;

  /// No description provided for @searchFilterDateThisWeek.
  ///
  /// In he, this message translates to:
  /// **'השבוע'**
  String get searchFilterDateThisWeek;

  /// No description provided for @searchFilterDateNextWeek.
  ///
  /// In he, this message translates to:
  /// **'שבוע הבא'**
  String get searchFilterDateNextWeek;

  /// No description provided for @searchFilterDateAny.
  ///
  /// In he, this message translates to:
  /// **'כל תאריך'**
  String get searchFilterDateAny;

  /// No description provided for @searchFilterSpecialty.
  ///
  /// In he, this message translates to:
  /// **'התמחות'**
  String get searchFilterSpecialty;

  /// No description provided for @searchFilterSpecialtyAll.
  ///
  /// In he, this message translates to:
  /// **'כל ההתמחויות'**
  String get searchFilterSpecialtyAll;

  /// No description provided for @searchFilterKupatHolim.
  ///
  /// In he, this message translates to:
  /// **'קופת חולים'**
  String get searchFilterKupatHolim;

  /// No description provided for @searchFilterKupatHolimAll.
  ///
  /// In he, this message translates to:
  /// **'כל הקופות'**
  String get searchFilterKupatHolimAll;

  /// No description provided for @searchFilterDistance.
  ///
  /// In he, this message translates to:
  /// **'מרחק מקסימלי'**
  String get searchFilterDistance;

  /// No description provided for @searchFilterDistanceAny.
  ///
  /// In he, this message translates to:
  /// **'ללא הגבלה'**
  String get searchFilterDistanceAny;

  /// No description provided for @searchFilterApply.
  ///
  /// In he, this message translates to:
  /// **'החל סינון'**
  String get searchFilterApply;

  /// No description provided for @searchFilterReset.
  ///
  /// In he, this message translates to:
  /// **'נקה הכל'**
  String get searchFilterReset;

  /// No description provided for @searchFilterActiveCount.
  ///
  /// In he, this message translates to:
  /// **'{count} סינונים פעילים'**
  String searchFilterActiveCount(int count);

  /// No description provided for @searchSortTitle.
  ///
  /// In he, this message translates to:
  /// **'מיין לפי'**
  String get searchSortTitle;

  /// No description provided for @searchSortAvailability.
  ///
  /// In he, this message translates to:
  /// **'זמינות'**
  String get searchSortAvailability;

  /// No description provided for @searchSortDistance.
  ///
  /// In he, this message translates to:
  /// **'מרחק'**
  String get searchSortDistance;

  /// No description provided for @searchSortName.
  ///
  /// In he, this message translates to:
  /// **'שם'**
  String get searchSortName;

  /// No description provided for @searchSortRating.
  ///
  /// In he, this message translates to:
  /// **'דירוג'**
  String get searchSortRating;

  /// No description provided for @onboardingStep1Title.
  ///
  /// In he, this message translates to:
  /// **'קבעו תורים בקלות'**
  String get onboardingStep1Title;

  /// No description provided for @onboardingStep2Title.
  ///
  /// In he, this message translates to:
  /// **'התכתבו בקלות עם הרופאים שלכם'**
  String get onboardingStep2Title;

  /// No description provided for @onboardingStep3Title.
  ///
  /// In he, this message translates to:
  /// **'גישה לתיק הרפואי בכל זמן'**
  String get onboardingStep3Title;

  /// No description provided for @onboardingContinueButton.
  ///
  /// In he, this message translates to:
  /// **'המשך'**
  String get onboardingContinueButton;

  /// No description provided for @onboardingStartButton.
  ///
  /// In he, this message translates to:
  /// **'התחל'**
  String get onboardingStartButton;

  /// No description provided for @healthTitle.
  ///
  /// In he, this message translates to:
  /// **'הבריאות שלי'**
  String get healthTitle;

  /// No description provided for @healthSubtitle.
  ///
  /// In he, this message translates to:
  /// **'נהל את פרופיל הבריאות שלך'**
  String get healthSubtitle;

  /// No description provided for @healthProfileTitle.
  ///
  /// In he, this message translates to:
  /// **'פרופיל בריאות'**
  String get healthProfileTitle;

  /// No description provided for @healthProfileSubtitle.
  ///
  /// In he, this message translates to:
  /// **'מלא מידע חשוב לקראת ביקורים ותורים'**
  String get healthProfileSubtitle;

  /// No description provided for @healthProfileIntro.
  ///
  /// In he, this message translates to:
  /// **'מידע זה יעזור לנו להכין את הביקורים שלך בישראל (קופת חולים, רופא משפחה, אלרגיות וכו׳).'**
  String get healthProfileIntro;

  /// No description provided for @healthProfileSave.
  ///
  /// In he, this message translates to:
  /// **'שמור'**
  String get healthProfileSave;

  /// No description provided for @healthProfileSavedSnack.
  ///
  /// In he, this message translates to:
  /// **'הפרופיל נשמר'**
  String get healthProfileSavedSnack;

  /// No description provided for @healthProfileStepIdentity.
  ///
  /// In he, this message translates to:
  /// **'זהות'**
  String get healthProfileStepIdentity;

  /// No description provided for @healthProfileStepKupatHolim.
  ///
  /// In he, this message translates to:
  /// **'קופת חולים'**
  String get healthProfileStepKupatHolim;

  /// No description provided for @healthProfileStepMedical.
  ///
  /// In he, this message translates to:
  /// **'מידע רפואי'**
  String get healthProfileStepMedical;

  /// No description provided for @healthProfileStepEmergency.
  ///
  /// In he, this message translates to:
  /// **'איש קשר לחירום'**
  String get healthProfileStepEmergency;

  /// No description provided for @healthProfileTeudatZehut.
  ///
  /// In he, this message translates to:
  /// **'תעודת זהות'**
  String get healthProfileTeudatZehut;

  /// No description provided for @healthProfileDateOfBirth.
  ///
  /// In he, this message translates to:
  /// **'תאריך לידה'**
  String get healthProfileDateOfBirth;

  /// No description provided for @healthProfileSex.
  ///
  /// In he, this message translates to:
  /// **'מין'**
  String get healthProfileSex;

  /// No description provided for @healthProfileSexFemale.
  ///
  /// In he, this message translates to:
  /// **'נקבה'**
  String get healthProfileSexFemale;

  /// No description provided for @healthProfileSexMale.
  ///
  /// In he, this message translates to:
  /// **'זכר'**
  String get healthProfileSexMale;

  /// No description provided for @healthProfileSexOther.
  ///
  /// In he, this message translates to:
  /// **'אחר'**
  String get healthProfileSexOther;

  /// No description provided for @healthProfileKupatHolim.
  ///
  /// In he, this message translates to:
  /// **'קופת חולים'**
  String get healthProfileKupatHolim;

  /// No description provided for @healthProfileKupatMemberId.
  ///
  /// In he, this message translates to:
  /// **'מספר חבר'**
  String get healthProfileKupatMemberId;

  /// No description provided for @healthProfileFamilyDoctor.
  ///
  /// In he, this message translates to:
  /// **'רופא/ת משפחה'**
  String get healthProfileFamilyDoctor;

  /// No description provided for @healthProfileEmergencyContactName.
  ///
  /// In he, this message translates to:
  /// **'שם איש קשר לחירום'**
  String get healthProfileEmergencyContactName;

  /// No description provided for @healthProfileEmergencyContactPhone.
  ///
  /// In he, this message translates to:
  /// **'טלפון לחירום'**
  String get healthProfileEmergencyContactPhone;

  /// No description provided for @kupatClalit.
  ///
  /// In he, this message translates to:
  /// **'כללית'**
  String get kupatClalit;

  /// No description provided for @kupatMaccabi.
  ///
  /// In he, this message translates to:
  /// **'מכבי'**
  String get kupatMaccabi;

  /// No description provided for @kupatMeuhedet.
  ///
  /// In he, this message translates to:
  /// **'מאוחדת'**
  String get kupatMeuhedet;

  /// No description provided for @kupatLeumit.
  ///
  /// In he, this message translates to:
  /// **'לאומית'**
  String get kupatLeumit;

  /// No description provided for @kupatOther.
  ///
  /// In he, this message translates to:
  /// **'אחר'**
  String get kupatOther;

  /// No description provided for @healthMyFileSectionTitle.
  ///
  /// In he, this message translates to:
  /// **'התיק שלי'**
  String get healthMyFileSectionTitle;

  /// No description provided for @healthDocumentsTitle.
  ///
  /// In he, this message translates to:
  /// **'מסמכים'**
  String get healthDocumentsTitle;

  /// No description provided for @healthDocumentsSubtitle.
  ///
  /// In he, this message translates to:
  /// **'מרשמים, בדיקות, סיכומים'**
  String get healthDocumentsSubtitle;

  /// No description provided for @healthConditionsTitle.
  ///
  /// In he, this message translates to:
  /// **'מצבים רפואיים'**
  String get healthConditionsTitle;

  /// No description provided for @healthConditionsSubtitle.
  ///
  /// In he, this message translates to:
  /// **'היסטוריה רפואית ומחלות'**
  String get healthConditionsSubtitle;

  /// No description provided for @healthMedicationsTitle.
  ///
  /// In he, this message translates to:
  /// **'תרופות'**
  String get healthMedicationsTitle;

  /// No description provided for @healthMedicationsSubtitle.
  ///
  /// In he, this message translates to:
  /// **'טיפולים נוכחיים'**
  String get healthMedicationsSubtitle;

  /// No description provided for @healthAllergiesTitle.
  ///
  /// In he, this message translates to:
  /// **'אלרגיות'**
  String get healthAllergiesTitle;

  /// No description provided for @healthAllergiesSubtitle.
  ///
  /// In he, this message translates to:
  /// **'אלרגיות ידועות'**
  String get healthAllergiesSubtitle;

  /// No description provided for @healthVaccinationsTitle.
  ///
  /// In he, this message translates to:
  /// **'חיסונים'**
  String get healthVaccinationsTitle;

  /// No description provided for @healthVaccinationsSubtitle.
  ///
  /// In he, this message translates to:
  /// **'היסטוריית חיסונים'**
  String get healthVaccinationsSubtitle;

  /// No description provided for @healthUpToDateTitle.
  ///
  /// In he, this message translates to:
  /// **'הכול מעודכן'**
  String get healthUpToDateTitle;

  /// No description provided for @healthUpToDateSubtitle.
  ///
  /// In he, this message translates to:
  /// **'נודיע לך כשיהיו לך תזכורות בריאות חדשות.'**
  String get healthUpToDateSubtitle;

  /// No description provided for @appointmentDetailTitle.
  ///
  /// In he, this message translates to:
  /// **'פרטי התור'**
  String get appointmentDetailTitle;

  /// No description provided for @appointmentDetailCancelledSnack.
  ///
  /// In he, this message translates to:
  /// **'התור בוטל'**
  String get appointmentDetailCancelledSnack;

  /// No description provided for @appointmentDetailNotFoundTitle.
  ///
  /// In he, this message translates to:
  /// **'התור לא נמצא'**
  String get appointmentDetailNotFoundTitle;

  /// No description provided for @appointmentDetailNotFoundSubtitle.
  ///
  /// In he, this message translates to:
  /// **'התור אינו זמין או בוטל.'**
  String get appointmentDetailNotFoundSubtitle;

  /// No description provided for @appointmentDetailReschedule.
  ///
  /// In he, this message translates to:
  /// **'לקבוע מחדש'**
  String get appointmentDetailReschedule;

  /// No description provided for @appointmentDetailCancelQuestion.
  ///
  /// In he, this message translates to:
  /// **'לבטל את התור?'**
  String get appointmentDetailCancelQuestion;

  /// No description provided for @appointmentDetailPreparationTitle.
  ///
  /// In he, this message translates to:
  /// **'נדרשת הכנה'**
  String get appointmentDetailPreparationTitle;

  /// No description provided for @appointmentDetailPreparationSubtitle.
  ///
  /// In he, this message translates to:
  /// **'הכן את הביקור מראש.'**
  String get appointmentDetailPreparationSubtitle;

  /// No description provided for @appointmentDetailPrepQuestionnaire.
  ///
  /// In he, this message translates to:
  /// **'מילוי שאלון בריאות'**
  String get appointmentDetailPrepQuestionnaire;

  /// No description provided for @appointmentDetailPrepInstructions.
  ///
  /// In he, this message translates to:
  /// **'צפה בהנחיות'**
  String get appointmentDetailPrepInstructions;

  /// No description provided for @appointmentPrepQuestionnaireSubtitle.
  ///
  /// In he, this message translates to:
  /// **'שאלון סטנדרטי (מוכן לשרת)'**
  String get appointmentPrepQuestionnaireSubtitle;

  /// No description provided for @appointmentPrepInstructionsSubtitle.
  ///
  /// In he, this message translates to:
  /// **'מידע חשוב לפני הביקור'**
  String get appointmentPrepInstructionsSubtitle;

  /// No description provided for @appointmentPrepQuestionSymptoms.
  ///
  /// In he, this message translates to:
  /// **'סיבה / תסמינים (תיאור קצר)'**
  String get appointmentPrepQuestionSymptoms;

  /// No description provided for @appointmentPrepQuestionAllergies.
  ///
  /// In he, this message translates to:
  /// **'אלרגיות (אופציונלי)'**
  String get appointmentPrepQuestionAllergies;

  /// No description provided for @appointmentPrepQuestionMedications.
  ///
  /// In he, this message translates to:
  /// **'תרופות קבועות (אופציונלי)'**
  String get appointmentPrepQuestionMedications;

  /// No description provided for @appointmentPrepQuestionOther.
  ///
  /// In he, this message translates to:
  /// **'מידע נוסף (אופציונלי)'**
  String get appointmentPrepQuestionOther;

  /// No description provided for @appointmentPrepConsentLabel.
  ///
  /// In he, this message translates to:
  /// **'אני מסכים/ה לשתף מידע זה עם הרופא/ה'**
  String get appointmentPrepConsentLabel;

  /// No description provided for @appointmentPrepConsentRequired.
  ///
  /// In he, this message translates to:
  /// **'נא לאשר כדי להמשיך.'**
  String get appointmentPrepConsentRequired;

  /// No description provided for @appointmentPrepSavedSnack.
  ///
  /// In he, this message translates to:
  /// **'ההכנה נשמרה'**
  String get appointmentPrepSavedSnack;

  /// No description provided for @appointmentPrepSubmit.
  ///
  /// In he, this message translates to:
  /// **'שלח'**
  String get appointmentPrepSubmit;

  /// No description provided for @appointmentPrepInstruction1.
  ///
  /// In he, this message translates to:
  /// **'הבא תעודה מזהה וכרטיס ביטוח.'**
  String get appointmentPrepInstruction1;

  /// No description provided for @appointmentPrepInstruction2.
  ///
  /// In he, this message translates to:
  /// **'הגיעו 10 דקות מוקדם יותר.'**
  String get appointmentPrepInstruction2;

  /// No description provided for @appointmentPrepInstruction3.
  ///
  /// In he, this message translates to:
  /// **'הכינו מסמכים רפואיים חשובים.'**
  String get appointmentPrepInstruction3;

  /// No description provided for @appointmentPrepInstructionsAccept.
  ///
  /// In he, this message translates to:
  /// **'קראתי ואני מסכים/ה להנחיות אלו'**
  String get appointmentPrepInstructionsAccept;

  /// No description provided for @appointmentDetailSendDocsTitle.
  ///
  /// In he, this message translates to:
  /// **'שליחת מסמכים'**
  String get appointmentDetailSendDocsTitle;

  /// No description provided for @appointmentDetailSendDocsSubtitle.
  ///
  /// In he, this message translates to:
  /// **'שלח מסמכים לרופא לפני הביקור.'**
  String get appointmentDetailSendDocsSubtitle;

  /// No description provided for @appointmentDetailAddDocs.
  ///
  /// In he, this message translates to:
  /// **'הוסף מסמכים'**
  String get appointmentDetailAddDocs;

  /// No description provided for @appointmentDetailEarlierSlotTitle.
  ///
  /// In he, this message translates to:
  /// **'רוצה תור מוקדם יותר?'**
  String get appointmentDetailEarlierSlotTitle;

  /// No description provided for @appointmentDetailEarlierSlotSubtitle.
  ///
  /// In he, this message translates to:
  /// **'קבל התראה אם תתפנה שעה מוקדמת יותר.'**
  String get appointmentDetailEarlierSlotSubtitle;

  /// No description provided for @appointmentDetailEnableAlerts.
  ///
  /// In he, this message translates to:
  /// **'הפעל התראות'**
  String get appointmentDetailEnableAlerts;

  /// No description provided for @appointmentDetailContactOffice.
  ///
  /// In he, this message translates to:
  /// **'צור קשר עם המרפאה'**
  String get appointmentDetailContactOffice;

  /// No description provided for @appointmentDetailVisitSummaryTitle.
  ///
  /// In he, this message translates to:
  /// **'סיכום ביקור'**
  String get appointmentDetailVisitSummaryTitle;

  /// No description provided for @appointmentDetailVisitSummarySubtitle.
  ///
  /// In he, this message translates to:
  /// **'מה קרה בביקור ומה הצעדים הבאים'**
  String get appointmentDetailVisitSummarySubtitle;

  /// No description provided for @appointmentDetailVisitSummaryDemo.
  ///
  /// In he, this message translates to:
  /// **'בוצעה בדיקה קלינית. הומלץ על מעקב בעוד 3 חודשים, והמשך טיפול לפי הצורך.'**
  String get appointmentDetailVisitSummaryDemo;

  /// No description provided for @appointmentDetailDoctorReportTitle.
  ///
  /// In he, this message translates to:
  /// **'סיכום רופא'**
  String get appointmentDetailDoctorReportTitle;

  /// No description provided for @appointmentDetailDoctorReportSubtitle.
  ///
  /// In he, this message translates to:
  /// **'דוח רפואי מהרופא המטפל'**
  String get appointmentDetailDoctorReportSubtitle;

  /// No description provided for @appointmentDetailDoctorReportDemo.
  ///
  /// In he, this message translates to:
  /// **'המטופל/ת הגיע/ה לבדיקה. לא נמצאו ממצאים חריגים. מומלץ להמשיך מעקב ולהביא מסמכים רלוונטיים לביקור הבא.'**
  String get appointmentDetailDoctorReportDemo;

  /// No description provided for @appointmentDetailDocumentsAndRxTitle.
  ///
  /// In he, this message translates to:
  /// **'מסמכים ומרשמים'**
  String get appointmentDetailDocumentsAndRxTitle;

  /// No description provided for @appointmentDetailDocumentsAndRxSubtitle.
  ///
  /// In he, this message translates to:
  /// **'מצא את המסמכים שהתקבלו לאחר הביקור'**
  String get appointmentDetailDocumentsAndRxSubtitle;

  /// No description provided for @appointmentDetailOpenVisitReport.
  ///
  /// In he, this message translates to:
  /// **'פתח את סיכום הביקור'**
  String get appointmentDetailOpenVisitReport;

  /// No description provided for @appointmentDetailOpenPrescription.
  ///
  /// In he, this message translates to:
  /// **'פתח מרשם'**
  String get appointmentDetailOpenPrescription;

  /// No description provided for @appointmentDetailSendMessageCta.
  ///
  /// In he, this message translates to:
  /// **'שלח הודעה למרפאה'**
  String get appointmentDetailSendMessageCta;

  /// No description provided for @messagesTitle.
  ///
  /// In he, this message translates to:
  /// **'הודעות'**
  String get messagesTitle;

  /// No description provided for @messagesMarkAllRead.
  ///
  /// In he, this message translates to:
  /// **'סמן הכול כנקרא'**
  String get messagesMarkAllRead;

  /// No description provided for @messagesEmptyTitle.
  ///
  /// In he, this message translates to:
  /// **'ההודעות שלך'**
  String get messagesEmptyTitle;

  /// No description provided for @messagesEmptySubtitle.
  ///
  /// In he, this message translates to:
  /// **'התחל שיחה עם הרופאים שלך כדי לבקש מסמך, לשאול שאלה או לעקוב אחר תוצאות.'**
  String get messagesEmptySubtitle;

  /// No description provided for @messagesNewMessageTitle.
  ///
  /// In he, this message translates to:
  /// **'הודעה חדשה'**
  String get messagesNewMessageTitle;

  /// No description provided for @messagesWriteToOfficeTitle.
  ///
  /// In he, this message translates to:
  /// **'כתוב למרפאה'**
  String get messagesWriteToOfficeTitle;

  /// No description provided for @messagesResponseTime.
  ///
  /// In he, this message translates to:
  /// **'מענה תוך 24–48 שעות.'**
  String get messagesResponseTime;

  /// No description provided for @messagesSubjectLabel.
  ///
  /// In he, this message translates to:
  /// **'נושא'**
  String get messagesSubjectLabel;

  /// No description provided for @messagesSubjectHint.
  ///
  /// In he, this message translates to:
  /// **'לדוגמה: תוצאות, שאלה…'**
  String get messagesSubjectHint;

  /// No description provided for @messagesSubjectRequired.
  ///
  /// In he, this message translates to:
  /// **'נדרש נושא'**
  String get messagesSubjectRequired;

  /// No description provided for @messagesMessageLabel.
  ///
  /// In he, this message translates to:
  /// **'הודעה'**
  String get messagesMessageLabel;

  /// No description provided for @messagesMessageHint.
  ///
  /// In he, this message translates to:
  /// **'כתוב את ההודעה שלך…'**
  String get messagesMessageHint;

  /// No description provided for @messagesSendButton.
  ///
  /// In he, this message translates to:
  /// **'שלח'**
  String get messagesSendButton;

  /// No description provided for @conversationTitle.
  ///
  /// In he, this message translates to:
  /// **'שיחה'**
  String get conversationTitle;

  /// No description provided for @conversationNewMessageTooltip.
  ///
  /// In he, this message translates to:
  /// **'הודעה חדשה'**
  String get conversationNewMessageTooltip;

  /// No description provided for @conversationWriteMessageHint.
  ///
  /// In he, this message translates to:
  /// **'כתוב הודעה…'**
  String get conversationWriteMessageHint;

  /// No description provided for @practitionerTitle.
  ///
  /// In he, this message translates to:
  /// **'רופא'**
  String get practitionerTitle;

  /// No description provided for @practitionerUnavailableTitle.
  ///
  /// In he, this message translates to:
  /// **'הרופא אינו זמין'**
  String get practitionerUnavailableTitle;

  /// No description provided for @practitionerNotFoundTitle.
  ///
  /// In he, this message translates to:
  /// **'הרופא לא נמצא'**
  String get practitionerNotFoundTitle;

  /// No description provided for @practitionerNotFoundSubtitle.
  ///
  /// In he, this message translates to:
  /// **'הפרופיל אינו זמין.'**
  String get practitionerNotFoundSubtitle;

  /// No description provided for @practitionerBookAppointment.
  ///
  /// In he, this message translates to:
  /// **'קבע תור'**
  String get practitionerBookAppointment;

  /// No description provided for @practitionerSendMessage.
  ///
  /// In he, this message translates to:
  /// **'שלח הודעה'**
  String get practitionerSendMessage;

  /// No description provided for @practitionerAvailabilities.
  ///
  /// In he, this message translates to:
  /// **'זמינות'**
  String get practitionerAvailabilities;

  /// No description provided for @practitionerAddress.
  ///
  /// In he, this message translates to:
  /// **'כתובת'**
  String get practitionerAddress;

  /// No description provided for @practitionerProfileSection.
  ///
  /// In he, this message translates to:
  /// **'פרופיל'**
  String get practitionerProfileSection;

  /// No description provided for @documentsTitle.
  ///
  /// In he, this message translates to:
  /// **'מסמכים'**
  String get documentsTitle;

  /// No description provided for @documentsEmptyTitle.
  ///
  /// In he, this message translates to:
  /// **'אין מסמך'**
  String get documentsEmptyTitle;

  /// No description provided for @documentsEmptySubtitle.
  ///
  /// In he, this message translates to:
  /// **'המרשמים והתוצאות שלך יופיעו כאן.'**
  String get documentsEmptySubtitle;

  /// No description provided for @documentsOpen.
  ///
  /// In he, this message translates to:
  /// **'פתח'**
  String get documentsOpen;

  /// No description provided for @documentsShare.
  ///
  /// In he, this message translates to:
  /// **'שתף'**
  String get documentsShare;

  /// No description provided for @authLogout.
  ///
  /// In he, this message translates to:
  /// **'התנתק'**
  String get authLogout;

  /// No description provided for @securityTitle.
  ///
  /// In he, this message translates to:
  /// **'אבטחה'**
  String get securityTitle;

  /// No description provided for @securitySecureAccountTitle.
  ///
  /// In he, this message translates to:
  /// **'אבטח את החשבון שלך'**
  String get securitySecureAccountTitle;

  /// No description provided for @securitySecureAccountSubtitle.
  ///
  /// In he, this message translates to:
  /// **'עדכן את הפרטים שלך'**
  String get securitySecureAccountSubtitle;

  /// No description provided for @securityChangePassword.
  ///
  /// In he, this message translates to:
  /// **'שנה סיסמה'**
  String get securityChangePassword;

  /// No description provided for @securityChangePasswordSuccess.
  ///
  /// In he, this message translates to:
  /// **'הבקשה נשמרה'**
  String get securityChangePasswordSuccess;

  /// No description provided for @securityCurrentPassword.
  ///
  /// In he, this message translates to:
  /// **'סיסמה נוכחית'**
  String get securityCurrentPassword;

  /// No description provided for @securityNewPassword.
  ///
  /// In he, this message translates to:
  /// **'סיסמה חדשה'**
  String get securityNewPassword;

  /// No description provided for @accountTitle.
  ///
  /// In he, this message translates to:
  /// **'החשבון שלי'**
  String get accountTitle;

  /// No description provided for @accountTaglineTitle.
  ///
  /// In he, this message translates to:
  /// **'הבריאות שלך. הנתונים שלך.'**
  String get accountTaglineTitle;

  /// No description provided for @accountTaglineSubtitle.
  ///
  /// In he, this message translates to:
  /// **'הפרטיות שלך היא העדיפות שלנו.'**
  String get accountTaglineSubtitle;

  /// No description provided for @accountPersonalInfoSection.
  ///
  /// In he, this message translates to:
  /// **'פרטים אישיים'**
  String get accountPersonalInfoSection;

  /// No description provided for @accountMyProfile.
  ///
  /// In he, this message translates to:
  /// **'הפרופיל שלי'**
  String get accountMyProfile;

  /// No description provided for @accountMyRelatives.
  ///
  /// In he, this message translates to:
  /// **'הקרובים שלי'**
  String get accountMyRelatives;

  /// No description provided for @accountSectionTitle.
  ///
  /// In he, this message translates to:
  /// **'חשבון'**
  String get accountSectionTitle;

  /// No description provided for @privacyTitle.
  ///
  /// In he, this message translates to:
  /// **'פרטיות'**
  String get privacyTitle;

  /// No description provided for @privacyYourDataTitle.
  ///
  /// In he, this message translates to:
  /// **'הנתונים שלך'**
  String get privacyYourDataTitle;

  /// No description provided for @privacyYourDataSubtitle.
  ///
  /// In he, this message translates to:
  /// **'אנחנו מגנים על המידע שלך ומגבילים את הגישה אליו.'**
  String get privacyYourDataSubtitle;

  /// No description provided for @privacySharingTitle.
  ///
  /// In he, this message translates to:
  /// **'שיתוף'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingSubtitle.
  ///
  /// In he, this message translates to:
  /// **'שלוט במסמכים שמשותפים עם הרופאים שלך.'**
  String get privacySharingSubtitle;

  /// No description provided for @privacyExportTitle.
  ///
  /// In he, this message translates to:
  /// **'ייצוא'**
  String get privacyExportTitle;

  /// No description provided for @privacyExportSubtitle.
  ///
  /// In he, this message translates to:
  /// **'ייצא את הנתונים שלך בכל עת.'**
  String get privacyExportSubtitle;

  /// No description provided for @paymentTitle.
  ///
  /// In he, this message translates to:
  /// **'תשלום'**
  String get paymentTitle;

  /// No description provided for @paymentEmptyTitle.
  ///
  /// In he, this message translates to:
  /// **'אין אמצעי תשלום'**
  String get paymentEmptyTitle;

  /// No description provided for @paymentEmptySubtitle.
  ///
  /// In he, this message translates to:
  /// **'הוסף כרטיס כדי לפשט את החיוב.'**
  String get paymentEmptySubtitle;

  /// No description provided for @paymentExpires.
  ///
  /// In he, this message translates to:
  /// **'תוקף {expiry}'**
  String paymentExpires(Object expiry);

  /// No description provided for @relativesTitle.
  ///
  /// In he, this message translates to:
  /// **'הקרובים שלי'**
  String get relativesTitle;

  /// No description provided for @relativesEmptyTitle.
  ///
  /// In he, this message translates to:
  /// **'אין קרוב'**
  String get relativesEmptyTitle;

  /// No description provided for @relativesEmptySubtitle.
  ///
  /// In he, this message translates to:
  /// **'הוסף קרובים כדי לקבוע תור בשמם.'**
  String get relativesEmptySubtitle;

  /// No description provided for @settingsUnavailableTitle.
  ///
  /// In he, this message translates to:
  /// **'ההגדרות אינן זמינות'**
  String get settingsUnavailableTitle;

  /// No description provided for @settingsUnavailableSubtitle.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון את ההעדפות שלך.'**
  String get settingsUnavailableSubtitle;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In he, this message translates to:
  /// **'התראות'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In he, this message translates to:
  /// **'קבל הודעות ועדכונים'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsRemindersTitle.
  ///
  /// In he, this message translates to:
  /// **'תזכורות לתורים'**
  String get settingsRemindersTitle;

  /// No description provided for @settingsRemindersSubtitle.
  ///
  /// In he, this message translates to:
  /// **'קבל תזכורות לפני התורים שלך'**
  String get settingsRemindersSubtitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In he, this message translates to:
  /// **'שפה'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageCurrentLabel.
  ///
  /// In he, this message translates to:
  /// **'עברית (נוכחי)'**
  String get settingsLanguageCurrentLabel;

  /// No description provided for @settingsLanguageShortLabel.
  ///
  /// In he, this message translates to:
  /// **'עברית'**
  String get settingsLanguageShortLabel;

  /// No description provided for @profileTitle.
  ///
  /// In he, this message translates to:
  /// **'הפרופיל שלי'**
  String get profileTitle;

  /// No description provided for @profileUnavailableTitle.
  ///
  /// In he, this message translates to:
  /// **'הפרופיל אינו זמין'**
  String get profileUnavailableTitle;

  /// No description provided for @profileUnavailableSubtitle.
  ///
  /// In he, this message translates to:
  /// **'הפרטים שלך אינם זמינים.'**
  String get profileUnavailableSubtitle;

  /// No description provided for @profileIdentitySection.
  ///
  /// In he, this message translates to:
  /// **'זהות'**
  String get profileIdentitySection;

  /// No description provided for @commonName.
  ///
  /// In he, this message translates to:
  /// **'שם'**
  String get commonName;

  /// No description provided for @commonAddress.
  ///
  /// In he, this message translates to:
  /// **'כתובת'**
  String get commonAddress;

  /// No description provided for @commonCity.
  ///
  /// In he, this message translates to:
  /// **'עיר'**
  String get commonCity;

  /// No description provided for @profileMedicalInfoSection.
  ///
  /// In he, this message translates to:
  /// **'מידע רפואי'**
  String get profileMedicalInfoSection;

  /// No description provided for @profileBloodType.
  ///
  /// In he, this message translates to:
  /// **'סוג דם'**
  String get profileBloodType;

  /// No description provided for @profileHeight.
  ///
  /// In he, this message translates to:
  /// **'גובה'**
  String get profileHeight;

  /// No description provided for @profileWeight.
  ///
  /// In he, this message translates to:
  /// **'משקל'**
  String get profileWeight;

  /// No description provided for @bookingSelectPatientTitle.
  ///
  /// In he, this message translates to:
  /// **'למי מיועד התור הזה?'**
  String get bookingSelectPatientTitle;

  /// No description provided for @bookingPatientsUnavailableTitle.
  ///
  /// In he, this message translates to:
  /// **'המטופלים אינם זמינים'**
  String get bookingPatientsUnavailableTitle;

  /// No description provided for @bookingAddRelative.
  ///
  /// In he, this message translates to:
  /// **'הוסף קרוב'**
  String get bookingAddRelative;

  /// No description provided for @commonMe.
  ///
  /// In he, this message translates to:
  /// **'אני'**
  String get commonMe;

  /// No description provided for @bookingSelectSlotTitle.
  ///
  /// In he, this message translates to:
  /// **'בחר תאריך'**
  String get bookingSelectSlotTitle;

  /// No description provided for @bookingSelectSlotSubtitle.
  ///
  /// In he, this message translates to:
  /// **'בחר תאריך ושעה זמינים.'**
  String get bookingSelectSlotSubtitle;

  /// No description provided for @bookingSeeMoreDates.
  ///
  /// In he, this message translates to:
  /// **'ראה עוד תאריכים'**
  String get bookingSeeMoreDates;

  /// No description provided for @commonSelected.
  ///
  /// In he, this message translates to:
  /// **'נבחר'**
  String get commonSelected;

  /// No description provided for @bookingInstructionsTitle.
  ///
  /// In he, this message translates to:
  /// **'הנחיות'**
  String get bookingInstructionsTitle;

  /// No description provided for @bookingInstructionsSubtitle.
  ///
  /// In he, this message translates to:
  /// **'לפני התור, אנא בדוק את הנקודות הבאות.'**
  String get bookingInstructionsSubtitle;

  /// No description provided for @bookingInstructionsBullet1.
  ///
  /// In he, this message translates to:
  /// **'הבא את כרטיס הביטוח והמרשם במידת הצורך.'**
  String get bookingInstructionsBullet1;

  /// No description provided for @bookingInstructionsBullet2.
  ///
  /// In he, this message translates to:
  /// **'הגע 10 דקות מוקדם יותר לצורך סידורים.'**
  String get bookingInstructionsBullet2;

  /// No description provided for @bookingInstructionsBullet3.
  ///
  /// In he, this message translates to:
  /// **'במקרה של ביטול, הודע בהקדם האפשרי.'**
  String get bookingInstructionsBullet3;

  /// No description provided for @bookingInstructionsAccept.
  ///
  /// In he, this message translates to:
  /// **'קראתי ואני מסכים להנחיות אלו.'**
  String get bookingInstructionsAccept;

  /// No description provided for @bookingConfirmTitle.
  ///
  /// In he, this message translates to:
  /// **'אשר את התור'**
  String get bookingConfirmTitle;

  /// No description provided for @bookingConfirmSubtitle.
  ///
  /// In he, this message translates to:
  /// **'בדוק את המידע לפני האישור.'**
  String get bookingConfirmSubtitle;

  /// No description provided for @bookingReasonLabel.
  ///
  /// In he, this message translates to:
  /// **'סיבה'**
  String get bookingReasonLabel;

  /// No description provided for @bookingPatientLabel.
  ///
  /// In he, this message translates to:
  /// **'מטופל'**
  String get bookingPatientLabel;

  /// No description provided for @bookingSlotLabel.
  ///
  /// In he, this message translates to:
  /// **'מועד'**
  String get bookingSlotLabel;

  /// No description provided for @bookingMissingInfoTitle.
  ///
  /// In he, this message translates to:
  /// **'מידע חסר'**
  String get bookingMissingInfoTitle;

  /// No description provided for @bookingZipCodeLabel.
  ///
  /// In he, this message translates to:
  /// **'מיקוד'**
  String get bookingZipCodeLabel;

  /// No description provided for @bookingVisitedBeforeQuestion.
  ///
  /// In he, this message translates to:
  /// **'האם ביקרת אצל רופא זה בעבר?'**
  String get bookingVisitedBeforeQuestion;

  /// No description provided for @commonYes.
  ///
  /// In he, this message translates to:
  /// **'כן'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In he, this message translates to:
  /// **'לא'**
  String get commonNo;

  /// No description provided for @bookingConfirmButton.
  ///
  /// In he, this message translates to:
  /// **'אשר את התור'**
  String get bookingConfirmButton;

  /// No description provided for @bookingChangeSlotButton.
  ///
  /// In he, this message translates to:
  /// **'שנה את המועד'**
  String get bookingChangeSlotButton;

  /// No description provided for @bookingSuccessTitle.
  ///
  /// In he, this message translates to:
  /// **'התור אושר'**
  String get bookingSuccessTitle;

  /// No description provided for @bookingSuccessSubtitle.
  ///
  /// In he, this message translates to:
  /// **'שלחנו אישור לאימייל שלך.'**
  String get bookingSuccessSubtitle;

  /// No description provided for @bookingAddToCalendar.
  ///
  /// In he, this message translates to:
  /// **'הוסף ללוח השנה שלי'**
  String get bookingAddToCalendar;

  /// No description provided for @bookingBookAnotherAppointment.
  ///
  /// In he, this message translates to:
  /// **'קבע תור נוסף'**
  String get bookingBookAnotherAppointment;

  /// No description provided for @bookingSendDocsSubtitle.
  ///
  /// In he, this message translates to:
  /// **'שלח מסמכים לרופא עבור הביקור.'**
  String get bookingSendDocsSubtitle;

  /// No description provided for @bookingViewMyAppointments.
  ///
  /// In he, this message translates to:
  /// **'ראה את התורים שלי'**
  String get bookingViewMyAppointments;

  /// No description provided for @bookingBackToHome.
  ///
  /// In he, this message translates to:
  /// **'חזרה לדף הבית'**
  String get bookingBackToHome;

  /// No description provided for @vaccinationsEmptyTitle.
  ///
  /// In he, this message translates to:
  /// **'אין חיסונים רשומים'**
  String get vaccinationsEmptyTitle;

  /// No description provided for @vaccinationsEmptySubtitle.
  ///
  /// In he, this message translates to:
  /// **'עקוב אחר החיסונים והתזכורות שלך.'**
  String get vaccinationsEmptySubtitle;

  /// No description provided for @allergiesEmptyTitle.
  ///
  /// In he, this message translates to:
  /// **'אין אלרגיות'**
  String get allergiesEmptyTitle;

  /// No description provided for @allergiesEmptySubtitle.
  ///
  /// In he, this message translates to:
  /// **'דווח על האלרגיות שלך למען בטיחותך.'**
  String get allergiesEmptySubtitle;

  /// No description provided for @medicationsEmptyTitle.
  ///
  /// In he, this message translates to:
  /// **'אין תרופות'**
  String get medicationsEmptyTitle;

  /// No description provided for @medicationsEmptySubtitle.
  ///
  /// In he, this message translates to:
  /// **'הוסף את הטיפולים הנוכחיים שלך.'**
  String get medicationsEmptySubtitle;

  /// No description provided for @conditionsEmptyTitle.
  ///
  /// In he, this message translates to:
  /// **'אין מצב רפואי'**
  String get conditionsEmptyTitle;

  /// No description provided for @conditionsEmptySubtitle.
  ///
  /// In he, this message translates to:
  /// **'הוסף היסטוריה רפואית עבור התורים שלך.'**
  String get conditionsEmptySubtitle;

  /// No description provided for @languageHebrew.
  ///
  /// In he, this message translates to:
  /// **'עברית'**
  String get languageHebrew;

  /// No description provided for @languageFrench.
  ///
  /// In he, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageEnglish.
  ///
  /// In he, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @errorGenericTryAgain.
  ///
  /// In he, this message translates to:
  /// **'אירעה שגיאה. נסה שוב.'**
  String get errorGenericTryAgain;

  /// No description provided for @authSignInFailedTryAgain.
  ///
  /// In he, this message translates to:
  /// **'ההתחברות נכשלה. נסה שוב.'**
  String get authSignInFailedTryAgain;

  /// No description provided for @authSignUpFailedTryAgain.
  ///
  /// In he, this message translates to:
  /// **'ההרשמה נכשלה. נסה שוב.'**
  String get authSignUpFailedTryAgain;

  /// No description provided for @errorUnableToConfirmAppointment.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לאשר את התור.'**
  String get errorUnableToConfirmAppointment;

  /// No description provided for @errorUnableToLoadProfile.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון את הפרופיל.'**
  String get errorUnableToLoadProfile;

  /// No description provided for @errorUnableToReadHistoryState.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לקרוא את מצב ההיסטוריה.'**
  String get errorUnableToReadHistoryState;

  /// No description provided for @errorUnableToEnableHistory.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן להפעיל את ההיסטוריה.'**
  String get errorUnableToEnableHistory;

  /// No description provided for @errorUnableToLoadRelatives.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון את הקרובים.'**
  String get errorUnableToLoadRelatives;

  /// No description provided for @errorUnableToAddRelative.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן להוסיף קרוב.'**
  String get errorUnableToAddRelative;

  /// No description provided for @errorUnableToLoadPayments.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון תשלומים.'**
  String get errorUnableToLoadPayments;

  /// No description provided for @errorUnableToAddPaymentMethod.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן להוסיף אמצעי תשלום.'**
  String get errorUnableToAddPaymentMethod;

  /// No description provided for @errorUnableToLoadHealthData.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון נתוני בריאות.'**
  String get errorUnableToLoadHealthData;

  /// No description provided for @errorUnableToAddHealthItem.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן להוסיף פריט.'**
  String get errorUnableToAddHealthItem;

  /// No description provided for @errorUnableToLoadHealthProfile.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון את פרופיל הבריאות.'**
  String get errorUnableToLoadHealthProfile;

  /// No description provided for @errorUnableToSaveHealthProfile.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לשמור את פרופיל הבריאות.'**
  String get errorUnableToSaveHealthProfile;

  /// No description provided for @errorUnableToLoadPractitioner.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון את הרופא.'**
  String get errorUnableToLoadPractitioner;

  /// No description provided for @errorUnableToLoadSearch.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון את החיפוש.'**
  String get errorUnableToLoadSearch;

  /// No description provided for @errorUnableToLoadDocuments.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון מסמכים.'**
  String get errorUnableToLoadDocuments;

  /// No description provided for @errorUnableToAddDocument.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן להוסיף מסמך.'**
  String get errorUnableToAddDocument;

  /// No description provided for @errorUnableToReadSettings.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לקרוא את ההגדרות.'**
  String get errorUnableToReadSettings;

  /// No description provided for @errorUnableToSaveSettings.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לשמור את ההגדרות.'**
  String get errorUnableToSaveSettings;

  /// No description provided for @errorUnableToLoadUpcomingAppointments.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון תורים קרובים.'**
  String get errorUnableToLoadUpcomingAppointments;

  /// No description provided for @errorUnableToLoadHistory.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון היסטוריה.'**
  String get errorUnableToLoadHistory;

  /// No description provided for @errorUnableToLoadAppointment.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון את התור.'**
  String get errorUnableToLoadAppointment;

  /// No description provided for @errorUnableToCancelAppointment.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לבטל את התור.'**
  String get errorUnableToCancelAppointment;

  /// No description provided for @errorUnableToLoadConversations.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון שיחות.'**
  String get errorUnableToLoadConversations;

  /// No description provided for @errorUnableToLoadConversation.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון את השיחה.'**
  String get errorUnableToLoadConversation;

  /// No description provided for @errorUnableToSendMessage.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לשלוח את ההודעה.'**
  String get errorUnableToSendMessage;

  /// No description provided for @errorUnableToReadOnboardingState.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לקרוא את מצב ההדרכה.'**
  String get errorUnableToReadOnboardingState;

  /// No description provided for @errorUnableToSaveOnboarding.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לשמור את ההדרכה.'**
  String get errorUnableToSaveOnboarding;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In he, this message translates to:
  /// **'לפני {minutes} דק׳'**
  String timeMinutesAgo(int minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In he, this message translates to:
  /// **'לפני {hours} ש׳'**
  String timeHoursAgo(int hours);

  /// No description provided for @timeDaysAgo.
  ///
  /// In he, this message translates to:
  /// **'לפני {days} י׳'**
  String timeDaysAgo(int days);

  /// No description provided for @demoDentalOfficeName.
  ///
  /// In he, this message translates to:
  /// **'מרפאת שיניים'**
  String get demoDentalOfficeName;

  /// No description provided for @demoConversation1LastMessage.
  ///
  /// In he, this message translates to:
  /// **'שלום, התוצאות שלך זמינות...'**
  String get demoConversation1LastMessage;

  /// No description provided for @demoConversation2LastMessage.
  ///
  /// In he, this message translates to:
  /// **'מצוין, אני שולח לך את המסמך!'**
  String get demoConversation2LastMessage;

  /// No description provided for @demoConversation3LastMessage.
  ///
  /// In he, this message translates to:
  /// **'תודה על הביקור!'**
  String get demoConversation3LastMessage;

  /// No description provided for @demoAppointmentConsultation.
  ///
  /// In he, this message translates to:
  /// **'ייעוץ'**
  String get demoAppointmentConsultation;

  /// No description provided for @demoAppointmentFollowUp.
  ///
  /// In he, this message translates to:
  /// **'מעקב רפואי'**
  String get demoAppointmentFollowUp;

  /// No description provided for @demoShortDateThu19Feb.
  ///
  /// In he, this message translates to:
  /// **'ה׳ 19 בפבר׳'**
  String get demoShortDateThu19Feb;

  /// No description provided for @demoShortDateMon15Feb.
  ///
  /// In he, this message translates to:
  /// **'ב׳ 15 בפבר׳'**
  String get demoShortDateMon15Feb;

  /// No description provided for @demoMessage1_1.
  ///
  /// In he, this message translates to:
  /// **'שלום, איך אפשר לעזור?'**
  String get demoMessage1_1;

  /// No description provided for @demoMessage1_2.
  ///
  /// In he, this message translates to:
  /// **'שלום, אני רוצה לקבל את הסיכום שלי.'**
  String get demoMessage1_2;

  /// No description provided for @demoMessage1_3.
  ///
  /// In he, this message translates to:
  /// **'בוודאי, האם תוכל לציין את תאריך התור?'**
  String get demoMessage1_3;

  /// No description provided for @demoMessage2_1.
  ///
  /// In he, this message translates to:
  /// **'שלום, התיק שלך מעודכן.'**
  String get demoMessage2_1;

  /// No description provided for @demoMessage3_1.
  ///
  /// In he, this message translates to:
  /// **'שלום!'**
  String get demoMessage3_1;

  /// No description provided for @demoMessage3_2.
  ///
  /// In he, this message translates to:
  /// **'תודה דוקטור.'**
  String get demoMessage3_2;

  /// No description provided for @relativeRelation.
  ///
  /// In he, this message translates to:
  /// **'קרוב'**
  String get relativeRelation;

  /// No description provided for @relativeChild.
  ///
  /// In he, this message translates to:
  /// **'ילד'**
  String get relativeChild;

  /// No description provided for @relativeParent.
  ///
  /// In he, this message translates to:
  /// **'הורה'**
  String get relativeParent;

  /// No description provided for @relativeDemoName.
  ///
  /// In he, this message translates to:
  /// **'קרוב {index}'**
  String relativeDemoName(int index);

  /// No description provided for @relativeLabel.
  ///
  /// In he, this message translates to:
  /// **'{relation} • {year}'**
  String relativeLabel(Object relation, int year);

  /// No description provided for @documentsDemoTitle.
  ///
  /// In he, this message translates to:
  /// **'מסמך {index}'**
  String documentsDemoTitle(int index);

  /// No description provided for @documentsDemoTypeLabel.
  ///
  /// In he, this message translates to:
  /// **'סיכום'**
  String get documentsDemoTypeLabel;

  /// No description provided for @documentsDemoDateLabelToday.
  ///
  /// In he, this message translates to:
  /// **'היום'**
  String get documentsDemoDateLabelToday;

  /// No description provided for @demoSpecialtyOphthalmologist.
  ///
  /// In he, this message translates to:
  /// **'רופא עיניים'**
  String get demoSpecialtyOphthalmologist;

  /// No description provided for @demoSpecialtyGeneralPractitioner.
  ///
  /// In he, this message translates to:
  /// **'רופא משפחה'**
  String get demoSpecialtyGeneralPractitioner;

  /// No description provided for @demoPractitionerAbout.
  ///
  /// In he, this message translates to:
  /// **'רופא העיניים מטפל במחלות העין, ומתמחה ברפרקציה, פזילה והפרעות ראייה.\n\nפרופיל זה מוכן להתחבר לשרת.'**
  String get demoPractitionerAbout;

  /// No description provided for @demoAvailabilityTodayAt.
  ///
  /// In he, this message translates to:
  /// **'היום • {time}'**
  String demoAvailabilityTodayAt(Object time);

  /// No description provided for @demoAvailabilityTomorrowAt.
  ///
  /// In he, this message translates to:
  /// **'מחר • {time}'**
  String demoAvailabilityTomorrowAt(Object time);

  /// No description provided for @demoAvailabilityThisWeekAt.
  ///
  /// In he, this message translates to:
  /// **'השבוע • {time}'**
  String demoAvailabilityThisWeekAt(Object time);

  /// No description provided for @demoSearchPractitionerName.
  ///
  /// In he, this message translates to:
  /// **'ד\"ר מטפל {index}'**
  String demoSearchPractitionerName(int index);

  /// No description provided for @demoSearchAddress.
  ///
  /// In he, this message translates to:
  /// **'75019 פריז • Avenue Secrétan'**
  String get demoSearchAddress;

  /// No description provided for @demoSearchSector1.
  ///
  /// In he, this message translates to:
  /// **'סקטור 1'**
  String get demoSearchSector1;

  /// No description provided for @demoAvailabilityToday.
  ///
  /// In he, this message translates to:
  /// **'היום'**
  String get demoAvailabilityToday;

  /// No description provided for @demoAvailabilityThisWeek.
  ///
  /// In he, this message translates to:
  /// **'השבוע'**
  String get demoAvailabilityThisWeek;

  /// No description provided for @demoDistance12km.
  ///
  /// In he, this message translates to:
  /// **'1.2 ק\"מ'**
  String get demoDistance12km;

  /// No description provided for @demoAppointmentDateThu19Feb.
  ///
  /// In he, this message translates to:
  /// **'יום ה׳ 19 בפברואר'**
  String get demoAppointmentDateThu19Feb;

  /// No description provided for @demoAppointmentReasonNewPatientConsultation.
  ///
  /// In he, this message translates to:
  /// **'ייעוץ (מטופל חדש)'**
  String get demoAppointmentReasonNewPatientConsultation;

  /// No description provided for @demoPractitionerNameMarc.
  ///
  /// In he, this message translates to:
  /// **'ד\"ר מרק בן-חמו'**
  String get demoPractitionerNameMarc;

  /// No description provided for @demoPractitionerNameSarah.
  ///
  /// In he, this message translates to:
  /// **'ד\"ר שרה כהן'**
  String get demoPractitionerNameSarah;

  /// No description provided for @demoPractitionerNameNoam.
  ///
  /// In he, this message translates to:
  /// **'ד\"ר נעם לוי'**
  String get demoPractitionerNameNoam;

  /// No description provided for @demoPractitionerNameMarcShort.
  ///
  /// In he, this message translates to:
  /// **'ד\"ר מרק ב׳'**
  String get demoPractitionerNameMarcShort;

  /// No description provided for @demoPractitionerNameSophie.
  ///
  /// In he, this message translates to:
  /// **'ד\"ר סופי ל׳'**
  String get demoPractitionerNameSophie;

  /// No description provided for @demoPatientNameTom.
  ///
  /// In he, this message translates to:
  /// **'תום'**
  String get demoPatientNameTom;

  /// No description provided for @demoAddressParis.
  ///
  /// In he, this message translates to:
  /// **'28, שדרות סרטא, 75019 פריז'**
  String get demoAddressParis;

  /// No description provided for @demoProfileFullName.
  ///
  /// In he, this message translates to:
  /// **'תום ג׳מי'**
  String get demoProfileFullName;

  /// No description provided for @demoProfileEmail.
  ///
  /// In he, this message translates to:
  /// **'tom@domaine.com'**
  String get demoProfileEmail;

  /// No description provided for @demoProfileCity.
  ///
  /// In he, this message translates to:
  /// **'75019 פריז'**
  String get demoProfileCity;

  /// No description provided for @demoPaymentBrandVisa.
  ///
  /// In he, this message translates to:
  /// **'ויזה'**
  String get demoPaymentBrandVisa;

  /// No description provided for @commonInitialsFallback.
  ///
  /// In he, this message translates to:
  /// **'אני'**
  String get commonInitialsFallback;

  /// No description provided for @navHome.
  ///
  /// In he, this message translates to:
  /// **'בית'**
  String get navHome;

  /// No description provided for @navAppointments.
  ///
  /// In he, this message translates to:
  /// **'תורים'**
  String get navAppointments;

  /// No description provided for @navHealth.
  ///
  /// In he, this message translates to:
  /// **'בריאות'**
  String get navHealth;

  /// No description provided for @navMessages.
  ///
  /// In he, this message translates to:
  /// **'הודעות'**
  String get navMessages;

  /// No description provided for @navAccount.
  ///
  /// In he, this message translates to:
  /// **'חשבון'**
  String get navAccount;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
