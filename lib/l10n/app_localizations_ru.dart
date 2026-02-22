// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get commonError => 'Ошибка';

  @override
  String get commonEmail => 'Электронная почта';

  @override
  String get commonEmailHint => 'например: name@domain.com';

  @override
  String get commonEmailRequired => 'Требуется email';

  @override
  String get commonEmailInvalid => 'Неверный email';

  @override
  String get commonPassword => 'Пароль';

  @override
  String get commonPasswordHint => '••••••••';

  @override
  String get commonPasswordRequired => 'Требуется пароль';

  @override
  String commonPasswordMinChars(int min) {
    return 'Минимум $min символов';
  }

  @override
  String get authLoginTitle => 'Войти';

  @override
  String get authLoginSubtitle =>
      'Доступ к вашим приемам, сообщениям и документам.';

  @override
  String get authLoginButton => 'Войти';

  @override
  String get authForgotPasswordCta => 'Забыли пароль?';

  @override
  String get authCreateAccountCta => 'Создать аккаунт';

  @override
  String get authContinueWithGoogle => 'Войти через Google';

  @override
  String get authContinueWithoutAccount => 'Продолжить без аккаунта';

  @override
  String get authRegisterTitle => 'Создать аккаунт';

  @override
  String get authRegisterSubtitle => 'Все поля обязательны.';

  @override
  String get authFirstName => 'Имя';

  @override
  String get authLastName => 'Фамилия';

  @override
  String get profileCompletionTitle => 'Заполните профиль';

  @override
  String get profileCompletionSubtitle =>
      'Эти данные обязательны для продолжения.';

  @override
  String profileCompletionStepLabel(int current, int total) {
    return '$current/$total';
  }

  @override
  String get profileCompletionStepIdentityTitle => 'Личные данные';

  @override
  String get profileCompletionStepIdentitySubtitle => 'Расскажите о себе.';

  @override
  String get profileCompletionDateOfBirth => 'Дата рождения';

  @override
  String get profileCompletionCity => 'Город (необязательно)';

  @override
  String get profileCompletionSex => 'Пол (необязательно)';

  @override
  String get profileCompletionSexMale => 'Мужской';

  @override
  String get profileCompletionSexFemale => 'Женский';

  @override
  String get profileCompletionSexOther => 'Другой';

  @override
  String get profileCompletionAvatar => 'Фото профиля (необязательно)';

  @override
  String get profileCompletionStepContactTitle => 'Контакты';

  @override
  String get profileCompletionStepContactSubtitle => 'Как с вами связаться?';

  @override
  String get profileCompletionEmailLockedHint =>
      'Email привязан к аккаунту и не может быть изменён здесь.';

  @override
  String get profileCompletionPhone => 'Телефон';

  @override
  String get profileCompletionPhoneHint => 'например, +972 50 123 4567';

  @override
  String get profileCompletionPhoneInvalid => 'Неверный номер телефона';

  @override
  String get profileCompletionStepIsraelTitle => 'Израиль';

  @override
  String get profileCompletionStepIsraelSubtitle =>
      'Данные, необходимые для медицинского обслуживания в Израиле.';

  @override
  String get profileCompletionTeudatHint => '9 цифр';

  @override
  String get profileCompletionTeudatInvalid => 'Неверный номер удостоверения';

  @override
  String get profileCompletionStepInsuranceTitle => 'Страховка';

  @override
  String get profileCompletionStepInsuranceSubtitle =>
      'Необязательно (можно пропустить).';

  @override
  String get profileCompletionInsurance => 'Страховая компания';

  @override
  String get profileCompletionInsuranceNone => 'Нет / пропустить';

  @override
  String get profileCompletionInsuranceOptionalHint =>
      'Страховка необязательна. Можно добавить позже в настройках.';

  @override
  String get profileCompletionFinish => 'Готово';

  @override
  String get commonRequired => 'Обязательно';

  @override
  String get commonContinue => 'Продолжить';

  @override
  String get authAlreadyHaveAccount => 'У меня уже есть аккаунт';

  @override
  String get authForgotPasswordTitle => 'Забыли пароль';

  @override
  String get authForgotPasswordSubtitle =>
      'Мы отправим вам код из 6 цифр по email.';

  @override
  String get authForgotPasswordSendLink => 'Отправить код';

  @override
  String get authBackToLogin => 'Назад ко входу';

  @override
  String get authForgotPasswordEmailSent => 'Код отправлен. Проверьте почту.';

  @override
  String get authResetPasswordVerifyTitle => 'Введите код';

  @override
  String authResetPasswordVerifyDescription(Object email) {
    return 'Мы отправили 6‑значный код на $email. Введите его, чтобы продолжить.';
  }

  @override
  String get authResetPasswordNewTitle => 'Новый пароль';

  @override
  String get authResetPasswordNewSubtitle => 'Придумайте новый пароль.';

  @override
  String get authResetPasswordConfirmPassword => 'Подтвердите пароль';

  @override
  String get authResetPasswordPasswordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get authResetPasswordUpdateButton => 'Обновить пароль';

  @override
  String get authResetPasswordUpdatedSnack =>
      'Пароль обновлён. Вы можете войти снова.';

  @override
  String get authVerifyEmailTitle => 'Подтвердите email';

  @override
  String authVerifyEmailDescription(Object email) {
    return 'Мы отправили 6-значный код на $email. Введите его ниже.';
  }

  @override
  String get authVerifyEmailOtpHint => '000000';

  @override
  String get authVerifyEmailVerify => 'Подтвердить';

  @override
  String get authVerifyEmailCheckedBackToLogin =>
      'Подтвердил(а), назад ко входу';

  @override
  String get authVerifyEmailResend => 'Отправить код снова';

  @override
  String get authVerifyEmailResentSnack => 'Код подтверждения отправлен снова.';

  @override
  String get commonBack => 'Назад';

  @override
  String get homeMyPractitioners => 'Мои специалисты';

  @override
  String get homeHistory => 'История';

  @override
  String homeGreeting(Object name) {
    return 'Привет, $name';
  }

  @override
  String get homeGreetingGuest => 'Здравствуйте!';

  @override
  String get homeSearchHint => 'Врач, специальность...';

  @override
  String get homeHealthTip1 => 'В этом году заведите полезные привычки.';

  @override
  String get homeHealthTip2 => 'Еще не поздно сделать прививку.';

  @override
  String get homeCompleteHealthProfile => 'Заполните профиль здоровья';

  @override
  String get homeCompleteHealthProfileSubtitle =>
      'Получайте персональные напоминания и готовьтесь к приемам';

  @override
  String get homeStart => 'Начать';

  @override
  String get homeNoRecentPractitioner => 'Нет недавних специалистов';

  @override
  String get homeHistoryDescription =>
      'Вы можете посмотреть список специалистов, у которых вы были';

  @override
  String get homeHistoryEnabledSnack => 'История включена';

  @override
  String get homeHistoryEnabled => 'История включена';

  @override
  String get homeActivateHistory => 'Включить историю';

  @override
  String homeNewMessageTitle(Object name) {
    return 'У вас новое сообщение от доктора $name';
  }

  @override
  String get homeNewMessageNoAppointment => 'Нет связанного приема';

  @override
  String get homeUpcomingAppointmentsTitle => 'Ближайшие приемы';

  @override
  String get homeNoUpcomingAppointments =>
      'Нет ближайших приёмов на данный момент';

  @override
  String get homeFindAppointmentCta => 'Найти прием';

  @override
  String get homeNoAppointmentsEmptyDescription =>
      'Пока у вас нет записей. Найдите специалиста и запишитесь на первый приём.';

  @override
  String get homeLast3AppointmentsTitle => 'Последние 3 приема';

  @override
  String get homeSeeAllPastAppointments => 'Смотреть';

  @override
  String get homeAppointmentHistoryTitle => 'История приемов';

  @override
  String get homeNoAppointmentHistory => 'Нет прошедших приемов';

  @override
  String get commonTryAgainLater => 'Попробуйте позже.';

  @override
  String get commonTryAgain => 'Повторить';

  @override
  String get commonUnableToLoad => 'Не удалось загрузить';

  @override
  String get commonAvailableSoon => 'Скоро будет доступно';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonActionIsFinal => 'Это действие необратимо.';

  @override
  String get commonTodo => 'Сделать';

  @override
  String get commonToRead => 'К прочтению';

  @override
  String get commonSettings => 'Настройки';

  @override
  String get commonTryAgainInAMoment => 'Попробуйте чуть позже.';

  @override
  String commonMinChars(int min) {
    return 'Минимум $min символов';
  }

  @override
  String get commonOnline => 'Онлайн';

  @override
  String get appointmentsTitle => 'Мои приемы';

  @override
  String get appointmentsTabUpcoming => 'Предстоящие';

  @override
  String get appointmentsTabPast => 'Прошедшие';

  @override
  String get appointmentsNoUpcomingTitle => 'Нет предстоящих приемов';

  @override
  String get appointmentsNoUpcomingSubtitle =>
      'Ваши следующие приемы появятся здесь.';

  @override
  String get appointmentsNoPastTitle => 'Нет прошедших приемов';

  @override
  String get appointmentsNoPastSubtitle => 'Завершенные приемы появятся здесь.';

  @override
  String get searchTitle => 'Поиск';

  @override
  String get searchHint => 'Врач, специальность...';

  @override
  String get searchUnavailableTitle => 'Поиск недоступен';

  @override
  String get searchNoResultsTitle => 'Нет результатов';

  @override
  String get searchNoResultsSubtitle => 'Попробуйте другой запрос.';

  @override
  String get searchFilterTitle => 'Фильтр результатов';

  @override
  String get searchFilterDate => 'Дата доступности';

  @override
  String get searchFilterDateToday => 'Сегодня';

  @override
  String get searchFilterDateTomorrow => 'Завтра';

  @override
  String get searchFilterDateThisWeek => 'На этой неделе';

  @override
  String get searchFilterDateNextWeek => 'На следующей неделе';

  @override
  String get searchFilterDateAny => 'Любая дата';

  @override
  String get searchFilterSpecialty => 'Специальность';

  @override
  String get searchFilterSpecialtyAll => 'Все специальности';

  @override
  String get searchFilterKupatHolim => 'Больничная касса';

  @override
  String get searchFilterKupatHolimAll => 'Все кассы';

  @override
  String get searchFilterDistance => 'Максимальная дистанция';

  @override
  String get searchFilterDistanceAny => 'Без ограничения';

  @override
  String get searchFilterApply => 'Применить фильтры';

  @override
  String get searchFilterReset => 'Сбросить все';

  @override
  String searchFilterActiveCount(int count) {
    return 'Активных фильтров: $count';
  }

  @override
  String get searchSortTitle => 'Сортировать по';

  @override
  String get searchSortAvailability => 'Доступности';

  @override
  String get searchSortAvailabilitySubtitle =>
      'От наиболее доступных к менее доступным';

  @override
  String get searchSortDistance => 'Расстоянию';

  @override
  String get searchSortDistanceSubtitle => 'От ближайших к дальним';

  @override
  String get searchSortName => 'Имени';

  @override
  String get searchSortNameSubtitle => 'По алфавиту';

  @override
  String get searchSortRating => 'Рейтингу';

  @override
  String get searchSortRatingSubtitle => 'От наивысшего рейтинга';

  @override
  String get searchSortPrice => 'Цене';

  @override
  String get searchSortPriceSubtitle => 'От дорогих к дешёвым';

  @override
  String get searchFilterPrice => 'Диапазон цен';

  @override
  String get searchFilterPriceAll => 'Все цены';

  @override
  String get searchFilterPriceUnder200 => 'До 200₪';

  @override
  String get searchFilterPrice200_300 => '200-300₪';

  @override
  String get searchFilterPrice300_500 => '300-500₪';

  @override
  String get searchFilterPriceOver500 => 'Более 500₪';

  @override
  String get searchFilterLanguage => 'Язык общения';

  @override
  String get searchFilterLanguageAll => 'Все языки';

  @override
  String get searchFeesLabel => 'Стоимость';

  @override
  String get searchBookNow => 'Записаться';

  @override
  String searchNextToday(String time) {
    return 'Ближайший: сегодня в $time';
  }

  @override
  String searchNextTomorrow(String time) {
    return 'Ближайший: завтра в $time';
  }

  @override
  String searchNextInDays(int count) {
    return 'Ближайший: через $count дн.';
  }

  @override
  String get onboardingStep1Title =>
      'Легко находите и записывайтесь на приём к врачу';

  @override
  String get onboardingStep2Title => 'Легко общайтесь с вашими специалистами';

  @override
  String get onboardingStep2Subtitle =>
      'Быстро и безопасно переписывайтесь с врачами.';

  @override
  String get onboardingStep3Title =>
      'Напоминания и сводка последних консультаций';

  @override
  String get onboardingStep3Subtitle =>
      'Не пропускайте визиты: напоминания и краткие итоги приёмов.';

  @override
  String get onboardingContinueButton => 'Продолжить';

  @override
  String get onboardingStartButton => 'Начать';

  @override
  String get healthTitle => 'Мое здоровье';

  @override
  String get healthSubtitle => 'Управляйте профилем здоровья';

  @override
  String get healthProfileTitle => 'Профиль здоровья';

  @override
  String get healthProfileSubtitle => 'Заполните ключевую информацию (Израиль)';

  @override
  String get healthProfileIntro =>
      'Эта информация помогает подготовить ваш прием в Израиле (касса, семейный врач, аллергии и т.д.).';

  @override
  String get healthProfileSave => 'Сохранить';

  @override
  String get healthProfileSavedSnack => 'Профиль сохранен';

  @override
  String get healthProfileStepIdentity => 'Личность';

  @override
  String get healthProfileStepKupatHolim => 'Касса';

  @override
  String get healthProfileStepMedical => 'Медицинская информация';

  @override
  String get healthProfileStepEmergency => 'Контакт на случай ЧС';

  @override
  String get healthProfileTeudatZehut => 'Номер удостоверения';

  @override
  String get healthProfileDateOfBirth => 'Дата рождения';

  @override
  String get healthProfileSex => 'Пол';

  @override
  String get healthProfileSexFemale => 'Женский';

  @override
  String get healthProfileSexMale => 'Мужской';

  @override
  String get healthProfileSexOther => 'Другое';

  @override
  String get healthProfileKupatHolim => 'Больничная касса';

  @override
  String get healthProfileKupatMemberId => 'Номер участника';

  @override
  String get healthProfileFamilyDoctor => 'Семейный врач';

  @override
  String get healthProfileEmergencyContactName => 'Имя контакта на случай ЧС';

  @override
  String get healthProfileEmergencyContactPhone => 'Телефон на случай ЧС';

  @override
  String get kupatClalit => 'Clalit';

  @override
  String get kupatMaccabi => 'Maccabi';

  @override
  String get kupatMeuhedet => 'Meuhedet';

  @override
  String get kupatLeumit => 'Leumit';

  @override
  String get kupatOther => 'Другое';

  @override
  String get healthMyFileSectionTitle => 'Мой файл';

  @override
  String get healthDocumentsTitle => 'Документы';

  @override
  String get healthDocumentsSubtitle => 'Рецепты, анализы, отчеты';

  @override
  String get healthConditionsTitle => 'Заболевания';

  @override
  String get healthConditionsSubtitle => 'История и состояния';

  @override
  String get healthMedicationsTitle => 'Лекарства';

  @override
  String get healthMedicationsSubtitle => 'Текущие назначения';

  @override
  String get healthAllergiesTitle => 'Аллергии';

  @override
  String get healthAllergiesSubtitle => 'Известные аллергии';

  @override
  String get healthVaccinationsTitle => 'Прививки';

  @override
  String get healthVaccinationsSubtitle => 'История вакцинации';

  @override
  String get healthUpToDateTitle => 'Все актуально';

  @override
  String get healthUpToDateSubtitle =>
      'Мы уведомим вас, когда появятся новые напоминания.';

  @override
  String get appointmentDetailTitle => 'Детали приема';

  @override
  String get appointmentDetailCancelledSnack => 'Прием отменен';

  @override
  String get appointmentDetailNotFoundTitle => 'Прием не найден';

  @override
  String get appointmentDetailNotFoundSubtitle =>
      'Этот прием недоступен или отменен.';

  @override
  String get appointmentDetailReschedule => 'Перенести';

  @override
  String get appointmentRescheduleTitle => 'בחר תאריך חדש';

  @override
  String appointmentRescheduleSubtitle(String practitionerName) {
    return 'בחר תור זמין עם $practitionerName.';
  }

  @override
  String appointmentRescheduleCurrent(String date, String time) {
    return 'כרגע: $date בשעה $time';
  }

  @override
  String get appointmentRescheduleConfirm => 'אשר שינוי';

  @override
  String get appointmentRescheduleSuccessSnack => 'התור נקבע מחדש בהצלחה';

  @override
  String get appointmentDetailCancelQuestion => 'Отменить прием?';

  @override
  String get appointmentDetailPreparationTitle => 'Требуется подготовка';

  @override
  String get appointmentDetailPreparationSubtitle =>
      'Подготовьте визит заранее.';

  @override
  String get appointmentDetailPrepQuestionnaire =>
      'Заполнить медицинскую анкету';

  @override
  String get appointmentDetailPrepInstructions => 'Посмотреть инструкции';

  @override
  String get appointmentPrepQuestionnaireSubtitle =>
      'Стандартизированная анкета (готово для backend)';

  @override
  String get appointmentPrepInstructionsSubtitle =>
      'Важная информация перед визитом';

  @override
  String get appointmentPrepQuestionSymptoms => 'Причина / симптомы (кратко)';

  @override
  String get appointmentPrepQuestionAllergies => 'Аллергии (необязательно)';

  @override
  String get appointmentPrepQuestionMedications =>
      'Текущие лекарства (необязательно)';

  @override
  String get appointmentPrepQuestionOther =>
      'Дополнительная информация (необязательно)';

  @override
  String get appointmentPrepConsentLabel =>
      'Я согласен(на) поделиться этой информацией со специалистом';

  @override
  String get appointmentPrepConsentRequired =>
      'Пожалуйста, подтвердите, чтобы продолжить.';

  @override
  String get appointmentPrepSavedSnack => 'Подготовка сохранена';

  @override
  String get appointmentPrepSubmit => 'Отправить';

  @override
  String get appointmentPrepInstruction1 =>
      'Возьмите документ и страховую карту.';

  @override
  String get appointmentPrepInstruction2 => 'Приходите на 10 минут раньше.';

  @override
  String get appointmentPrepInstruction3 =>
      'Подготовьте важные медицинские документы.';

  @override
  String get appointmentPrepInstructionsAccept =>
      'Я прочитал(а) и принимаю эти инструкции';

  @override
  String get appointmentDetailSendDocsTitle => 'Отправить документы';

  @override
  String get appointmentDetailSendDocsSubtitle =>
      'Отправьте документы специалисту до приема.';

  @override
  String get appointmentDetailAddDocs => 'Добавить документы';

  @override
  String get appointmentDetailEarlierSlotTitle => 'Хотите более раннее время?';

  @override
  String get appointmentDetailEarlierSlotSubtitle =>
      'Получите уведомление, если появится более ранний слот.';

  @override
  String get appointmentDetailEnableAlerts => 'Включить уведомления';

  @override
  String get appointmentDetailContactOffice => 'Связаться с кабинетом';

  @override
  String get appointmentDetailVisitSummaryTitle => 'Итоги визита';

  @override
  String get appointmentDetailVisitSummarySubtitle =>
      'Главное и следующие шаги';

  @override
  String get appointmentDetailVisitSummaryDemo =>
      'Осмотр проведен. Рекомендован контроль через 3 месяца и продолжение лечения при необходимости.';

  @override
  String get appointmentDetailDoctorReportTitle => 'Отчет врача';

  @override
  String get appointmentDetailDoctorReportSubtitle => 'Заметка после визита';

  @override
  String get appointmentDetailDoctorReportDemo =>
      'Пациент пришел на консультацию. Тревожных находок нет. Рекомендовано наблюдение и принести релевантные документы на следующий прием.';

  @override
  String get appointmentDetailDocumentsAndRxTitle => 'Документы и рецепт';

  @override
  String get appointmentDetailDocumentsAndRxSubtitle =>
      'Документы, полученные после визита';

  @override
  String get appointmentDetailOpenVisitReport => 'Открыть отчет о визите';

  @override
  String get appointmentDetailOpenPrescription => 'Открыть рецепт';

  @override
  String get appointmentDetailSendMessageCta => 'Написать в кабинет';

  @override
  String get messagesTitle => 'Сообщения';

  @override
  String get messagesMarkAllRead => 'Отметить все прочитанным';

  @override
  String get messagesEmptyTitle => 'Ваши сообщения';

  @override
  String get messagesEmptySubtitle =>
      'Начните диалог со специалистами, чтобы запросить документ, задать вопрос или следить за результатами.';

  @override
  String get messagesNewMessageTitle => 'Новое сообщение';

  @override
  String get messagesWriteToOfficeTitle => 'Написать в кабинет';

  @override
  String get messagesResponseTime => 'Ответ в течение 24–48 ч.';

  @override
  String get messagesSubjectLabel => 'Тема';

  @override
  String get messagesSubjectHint => 'например: результаты, вопрос…';

  @override
  String get messagesSubjectRequired => 'Тема обязательна';

  @override
  String get messagesMessageLabel => 'Сообщение';

  @override
  String get messagesMessageHint => 'Напишите сообщение…';

  @override
  String get messagesSendButton => 'Отправить';

  @override
  String get conversationTitle => 'Диалог';

  @override
  String get conversationNewMessageTooltip => 'Новое сообщение';

  @override
  String get conversationWriteMessageHint => 'Написать сообщение…';

  @override
  String get practitionerTitle => 'Специалист';

  @override
  String get practitionerUnavailableTitle => 'Специалист недоступен';

  @override
  String get practitionerNotFoundTitle => 'Специалист не найден';

  @override
  String get practitionerNotFoundSubtitle => 'Этот профиль недоступен.';

  @override
  String get practitionerBookAppointment => 'Записаться на прием';

  @override
  String get practitionerSendMessage => 'Отправить сообщение';

  @override
  String get practitionerAvailabilities => 'Доступность';

  @override
  String get practitionerAddress => 'Адрес';

  @override
  String get practitionerProfileSection => 'Профиль';

  @override
  String get practitionerTabAvailability => 'Доступность';

  @override
  String get practitionerTabReviews => 'Отзывы';

  @override
  String get practitionerMyAppointmentsWithDoctor => 'Мои записи к этому врачу';

  @override
  String get practitionerNoAppointmentsWithDoctor =>
      'Нет записей к этому врачу';

  @override
  String get practitionerLoginToSeeHistory => 'Войдите, чтобы увидеть историю';

  @override
  String get practitionerNoReviews => 'Пока нет отзывов';

  @override
  String get practitionerCalendarLegendAvailable => 'Доступно';

  @override
  String get practitionerCalendarLegendSelected => 'Выбрано';

  @override
  String get practitionerNoSlotsForDate => 'Нет доступных слотов на эту дату';

  @override
  String get practitionerYourAppointment => 'Ваша запись';

  @override
  String get practitionerAddressAndContact => 'Адрес и контакты';

  @override
  String get practitionerAppointmentStatusCompleted => 'Завершено';

  @override
  String get practitionerAppointmentStatusConfirmed => 'Подтверждено';

  @override
  String get practitionerAppointmentStatusPending => 'Ожидание';

  @override
  String get practitionerAppointmentStatusCancelled => 'Отменено';

  @override
  String get practitionerAppointmentStatusNoShow => 'Не явился';

  @override
  String get practitionerReviewAnonymous => 'Анонимно';

  @override
  String get practitionerLanguageHebrew => 'Иврит';

  @override
  String get practitionerLanguageFrench => 'Французский';

  @override
  String get practitionerLanguageEnglish => 'Английский';

  @override
  String get practitionerLanguageRussian => 'Русский';

  @override
  String get practitionerLanguageSpanish => 'Испанский';

  @override
  String get practitionerLanguageAmharic => 'Амхарский';

  @override
  String get practitionerLanguageArabic => 'Арабский';

  @override
  String get documentsTitle => 'Документы';

  @override
  String get documentsEmptyTitle => 'Нет документов';

  @override
  String get documentsEmptySubtitle =>
      'Ваши рецепты и результаты появятся здесь.';

  @override
  String get documentsOpen => 'Открыть';

  @override
  String get documentsShare => 'Поделиться';

  @override
  String get authLogout => 'Выйти';

  @override
  String get authLoggingOut => 'Выход…';

  @override
  String get authLogoutConfirmTitle => 'Выход';

  @override
  String get authLogoutConfirmMessage => 'Вы уверены, что хотите выйти?';

  @override
  String get authLogoutSuccess => 'Вы вышли из аккаунта';

  @override
  String get authLoginSuccess => 'Добро пожаловать!';

  @override
  String get securityTitle => 'Безопасность';

  @override
  String get securitySecureAccountTitle => 'Защитите аккаунт';

  @override
  String get securitySecureAccountSubtitle => 'Обновите информацию';

  @override
  String get securityChangePassword => 'Сменить пароль';

  @override
  String get securityChangePasswordSuccess =>
      'Пароль обновлён. Войдите с новым паролем.';

  @override
  String get securityChangePasswordSendingCode =>
      'Отправка кода подтверждения…';

  @override
  String get securityChangePasswordSendCodeHint =>
      'На вашу почту будет отправлен 6-значный код для смены пароля.';

  @override
  String get securityChangePasswordOtpLabel => '6-значный код';

  @override
  String get securityCurrentPassword => 'Текущий пароль';

  @override
  String get securityNewPassword => 'Новый пароль';

  @override
  String get accountTitle => 'Мой аккаунт';

  @override
  String get accountTaglineTitle => 'Ваше здоровье. Ваши данные.';

  @override
  String get accountTaglineSubtitle =>
      'Ваша конфиденциальность — наш приоритет.';

  @override
  String get accountPersonalInfoSection => 'Личная информация';

  @override
  String get accountMyProfile => 'Мой профиль';

  @override
  String get accountMyRelatives => 'Мои близкие';

  @override
  String get accountSectionTitle => 'Аккаунт';

  @override
  String get privacyTitle => 'Конфиденциальность';

  @override
  String get privacyYourDataTitle => 'Ваши данные';

  @override
  String get privacyYourDataSubtitle =>
      'Мы защищаем вашу информацию и ограничиваем доступ к ней.';

  @override
  String get privacySharingTitle => 'Обмен';

  @override
  String get privacySharingSubtitle =>
      'Контролируйте документы, которыми делитесь со специалистами.';

  @override
  String get privacyExportTitle => 'Экспорт';

  @override
  String get privacyExportSubtitle => 'Экспортируйте данные в любое время.';

  @override
  String get paymentTitle => 'Оплата';

  @override
  String get paymentEmptyTitle => 'Нет способа оплаты';

  @override
  String get paymentEmptySubtitle => 'Добавьте карту, чтобы упростить оплату.';

  @override
  String paymentExpires(Object expiry) {
    return 'Действует до $expiry';
  }

  @override
  String get relativesTitle => 'Мои близкие';

  @override
  String get relativesEmptyTitle => 'Нет близких';

  @override
  String get relativesEmptySubtitle =>
      'Добавьте близких, чтобы записывать их на прием.';

  @override
  String get settingsUnavailableTitle => 'Настройки недоступны';

  @override
  String get settingsUnavailableSubtitle =>
      'Не удалось загрузить ваши предпочтения.';

  @override
  String get settingsNotificationsTitle => 'Уведомления';

  @override
  String get settingsNotificationsSubtitle =>
      'Получайте сообщения и обновления';

  @override
  String get settingsRemindersTitle => 'Напоминания о приемах';

  @override
  String get settingsRemindersSubtitle =>
      'Получайте напоминания перед приемами';

  @override
  String get settingsLanguageTitle => 'Язык';

  @override
  String get settingsLanguageCurrentLabel => 'Русский (текущий)';

  @override
  String get settingsLanguageShortLabel => 'Русский';

  @override
  String get profileTitle => 'Мой профиль';

  @override
  String get profileUnavailableTitle => 'Профиль недоступен';

  @override
  String get profileUnavailableSubtitle => 'Ваша информация недоступна.';

  @override
  String get profileIdentitySection => 'Личность';

  @override
  String get commonName => 'Имя';

  @override
  String get commonAddress => 'Адрес';

  @override
  String get commonCity => 'Город';

  @override
  String get profileMedicalInfoSection => 'Медицинская информация';

  @override
  String get profileBloodType => 'Группа крови';

  @override
  String get profileHeight => 'Рост';

  @override
  String get profileWeight => 'Вес';

  @override
  String get profileDangerZoneTitle => 'Опасная зона';

  @override
  String get profileDeleteAccountHint =>
      'Удалите аккаунт навсегда и все ваши данные.';

  @override
  String get profileDeleteAccountButton => 'Удалить аккаунт';

  @override
  String get profileDeleteAccountDialogTitle => 'Удалить аккаунт?';

  @override
  String get profileDeleteAccountDialogBody =>
      'Ваш аккаунт и все связанные данные будут удалены навсегда. Это действие нельзя отменить.';

  @override
  String get profileDeleteAccountConfirm => 'Удалить';

  @override
  String get profileDeleteAccountLoading => 'Удаление аккаунта…';

  @override
  String get profileAccountDeletedSnack =>
      'Аккаунт удален. Вы вышли из системы.';

  @override
  String get errorUnableToDeleteAccount => 'Не удалось удалить аккаунт.';

  @override
  String get bookingSelectPatientTitle => 'Для кого этот прием?';

  @override
  String get bookingPatientsUnavailableTitle => 'Пациенты недоступны';

  @override
  String get bookingAddRelative => 'Добавить близкого';

  @override
  String get commonMe => 'я';

  @override
  String get bookingSelectSlotTitle => 'Выберите дату';

  @override
  String get bookingSelectSlotSubtitle => 'Выберите доступную дату и время.';

  @override
  String get bookingSeeMoreDates => 'Показать больше дат';

  @override
  String get commonSelected => 'Выбрано';

  @override
  String get bookingInstructionsTitle => 'Инструкции';

  @override
  String get bookingInstructionsSubtitle =>
      'Перед приемом, пожалуйста, проверьте эти пункты.';

  @override
  String get bookingInstructionsBullet1 =>
      'Возьмите страховую карту и рецепт, если нужно.';

  @override
  String get bookingInstructionsBullet2 =>
      'Приходите на 10 минут раньше для оформления.';

  @override
  String get bookingInstructionsBullet3 =>
      'При отмене сообщите как можно скорее.';

  @override
  String get bookingInstructionsAccept =>
      'Я прочитал(а) и принимаю эти инструкции.';

  @override
  String get bookingConfirmTitle => 'Подтвердите прием';

  @override
  String get bookingConfirmSubtitle =>
      'Проверьте информацию перед подтверждением.';

  @override
  String get bookingReasonLabel => 'Причина';

  @override
  String get bookingPatientLabel => 'Пациент';

  @override
  String get bookingSlotLabel => 'Время';

  @override
  String get bookingMissingInfoTitle => 'Не хватает информации';

  @override
  String get bookingZipCodeLabel => 'Почтовый индекс';

  @override
  String get bookingVisitedBeforeQuestion => 'Вы уже были у этого специалиста?';

  @override
  String get commonYes => 'Да';

  @override
  String get commonNo => 'Нет';

  @override
  String get bookingConfirmButton => 'Подтвердить прием';

  @override
  String get bookingChangeSlotButton => 'Изменить время';

  @override
  String get bookingQuickPatientSubtitle => 'Выберите, кто пойдет на прием.';

  @override
  String get bookingQuickConfirmSubtitle => 'Проверьте данные и подтвердите.';

  @override
  String get bookingChangePatient => 'Изменить пациента';

  @override
  String get commonLoading => 'Загрузка…';

  @override
  String get bookingSuccessTitle => 'Прием подтвержден';

  @override
  String get bookingSuccessSubtitle =>
      'Мы отправили подтверждение на вашу почту.';

  @override
  String get bookingAddToCalendar => 'Добавить в календарь';

  @override
  String get bookingBookAnotherAppointment => 'Записаться еще раз';

  @override
  String get bookingSendDocsSubtitle =>
      'Отправьте документы специалисту к приему.';

  @override
  String get bookingViewMyAppointments => 'Посмотреть мои приемы';

  @override
  String get bookingBackToHome => 'На главную';

  @override
  String get vaccinationsEmptyTitle => 'Нет записанных прививок';

  @override
  String get vaccinationsEmptySubtitle =>
      'Отслеживайте прививки и напоминания.';

  @override
  String get allergiesEmptyTitle => 'Нет аллергий';

  @override
  String get allergiesEmptySubtitle =>
      'Укажите аллергии для вашей безопасности.';

  @override
  String get medicationsEmptyTitle => 'Нет лекарств';

  @override
  String get medicationsEmptySubtitle => 'Добавьте текущие назначения.';

  @override
  String get conditionsEmptyTitle => 'Нет заболеваний';

  @override
  String get conditionsEmptySubtitle =>
      'Добавьте историю для подготовки к приемам.';

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
  String get errorGenericTryAgain => 'Произошла ошибка. Попробуйте снова.';

  @override
  String get authSignInFailedTryAgain => 'Не удалось войти. Попробуйте снова.';

  @override
  String get authSignUpFailedTryAgain =>
      'Не удалось зарегистрироваться. Попробуйте снова.';

  @override
  String get authOnlyPatientsAllowed => 'Пока вход доступен только пациентам.';

  @override
  String get errorUnableToConfirmAppointment => 'Не удалось подтвердить прием.';

  @override
  String get errorUnableToLoadProfile => 'Не удалось загрузить профиль.';

  @override
  String get errorUnableToRetrieveEmail =>
      'Не удалось получить адрес электронной почты.';

  @override
  String get errorUnableToReadHistoryState =>
      'Не удалось прочитать состояние истории.';

  @override
  String get errorUnableToEnableHistory => 'Не удалось включить историю.';

  @override
  String get errorUnableToLoadRelatives => 'Не удалось загрузить близких.';

  @override
  String get errorUnableToAddRelative => 'Не удалось добавить близкого.';

  @override
  String get errorUnableToLoadPayments =>
      'Не удалось загрузить способы оплаты.';

  @override
  String get errorUnableToAddPaymentMethod =>
      'Не удалось добавить способ оплаты.';

  @override
  String get errorUnableToLoadHealthData =>
      'Не удалось загрузить данные о здоровье.';

  @override
  String get errorUnableToAddHealthItem => 'Не удалось добавить элемент.';

  @override
  String get errorUnableToLoadHealthProfile =>
      'Не удалось загрузить профиль здоровья.';

  @override
  String get errorUnableToSaveHealthProfile =>
      'Не удалось сохранить профиль здоровья.';

  @override
  String get errorUnableToLoadPractitioner =>
      'Не удалось загрузить специалиста.';

  @override
  String get errorUnableToLoadSearch => 'Не удалось загрузить поиск.';

  @override
  String get errorUnableToLoadDocuments => 'Не удалось загрузить документы.';

  @override
  String get errorUnableToAddDocument => 'Не удалось добавить документ.';

  @override
  String get errorUnableToReadSettings => 'Не удалось прочитать настройки.';

  @override
  String get errorUnableToSaveSettings => 'Не удалось сохранить настройки.';

  @override
  String get errorUnableToLoadUpcomingAppointments =>
      'Не удалось загрузить предстоящие приемы.';

  @override
  String get errorUnableToLoadHistory => 'Не удалось загрузить историю.';

  @override
  String get errorUnableToLoadAppointment => 'Не удалось загрузить прием.';

  @override
  String get errorUnableToCancelAppointment => 'Не удалось отменить прием.';

  @override
  String get errorUnableToRescheduleAppointment =>
      'Не удалось перенести прием.';

  @override
  String get errorUnableToLoadConversations => 'Не удалось загрузить диалоги.';

  @override
  String get errorUnableToLoadConversation => 'Не удалось загрузить диалог.';

  @override
  String get errorUnableToSendMessage => 'Не удалось отправить сообщение.';

  @override
  String get errorUnableToReadOnboardingState =>
      'Не удалось прочитать состояние онбординга.';

  @override
  String get errorUnableToSaveOnboarding => 'Не удалось сохранить онбординг.';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes мин назад';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours ч назад';
  }

  @override
  String timeDaysAgo(int days) {
    return '$days д назад';
  }

  @override
  String get demoDentalOfficeName => 'Стоматологическая клиника';

  @override
  String get demoConversation1LastMessage =>
      'Здравствуйте, ваши результаты доступны...';

  @override
  String get demoConversation2LastMessage =>
      'Отлично, я отправляю вам документ!';

  @override
  String get demoConversation3LastMessage => 'Спасибо за визит!';

  @override
  String get demoAppointmentConsultation => 'Консультация';

  @override
  String get demoAppointmentFollowUp => 'Медицинский контроль';

  @override
  String get demoShortDateThu19Feb => 'Чт, 19 фев';

  @override
  String get demoShortDateMon15Feb => 'Пн, 15 фев';

  @override
  String get demoMessage1_1 => 'Здравствуйте, чем можем помочь?';

  @override
  String get demoMessage1_2 =>
      'Здравствуйте, я хотел(а) бы получить свой отчет.';

  @override
  String get demoMessage1_3 => 'Конечно, уточните дату приема, пожалуйста.';

  @override
  String get demoMessage2_1 => 'Здравствуйте, ваш файл обновлен.';

  @override
  String get demoMessage3_1 => 'Здравствуйте!';

  @override
  String get demoMessage3_2 => 'Спасибо, доктор.';

  @override
  String get relativeRelation => 'Близкий';

  @override
  String get relativeChild => 'Ребенок';

  @override
  String get relativeParent => 'Родитель';

  @override
  String relativeDemoName(int index) {
    return 'Близкий $index';
  }

  @override
  String relativeLabel(Object relation, int year) {
    return '$relation • $year';
  }

  @override
  String documentsDemoTitle(int index) {
    return 'Документ $index';
  }

  @override
  String get documentsDemoTypeLabel => 'Отчет';

  @override
  String get documentsDemoDateLabelToday => 'Сегодня';

  @override
  String get demoSpecialtyOphthalmologist => 'Офтальмолог';

  @override
  String get demoSpecialtyGeneralPractitioner => 'Терапевт';

  @override
  String get demoPractitionerAbout =>
      'Офтальмолог лечит заболевания глаз и занимается рефракцией, косоглазием и нарушениями зрения.\n\nЭтот профиль готов к подключению к backend.';

  @override
  String demoAvailabilityTodayAt(Object time) {
    return 'Сегодня • $time';
  }

  @override
  String demoAvailabilityTomorrowAt(Object time) {
    return 'Завтра • $time';
  }

  @override
  String demoAvailabilityThisWeekAt(Object time) {
    return 'На этой неделе • $time';
  }

  @override
  String demoSearchPractitionerName(int index) {
    return 'Д-р Специалист $index';
  }

  @override
  String get demoSearchAddress => '75019 Париж • Avenue Secrétan';

  @override
  String get demoSearchSector1 => 'Сектор 1';

  @override
  String get demoAvailabilityToday => 'Сегодня';

  @override
  String get demoAvailabilityThisWeek => 'На этой неделе';

  @override
  String get demoDistance12km => '1,2 км';

  @override
  String get demoAppointmentDateThu19Feb => 'Четверг, 19 февраля';

  @override
  String get demoAppointmentReasonNewPatientConsultation =>
      'Консультация (новый пациент)';

  @override
  String get demoPractitionerNameMarc => 'Д-р Марк БЕНАМО';

  @override
  String get demoPractitionerNameSarah => 'Д-р Сара КОЭН';

  @override
  String get demoPractitionerNameNoam => 'Д-р Ноам ЛЕВИ';

  @override
  String get demoPractitionerNameMarcShort => 'Д-р Марк Б.';

  @override
  String get demoPractitionerNameSophie => 'Д-р Софи Л.';

  @override
  String get demoPatientNameTom => 'Том';

  @override
  String get demoAddressParis => '28, avenue Secrétan, 75019 Париж';

  @override
  String get demoProfileFullName => 'Том Джами';

  @override
  String get demoProfileEmail => 'tom@domaine.com';

  @override
  String get demoProfileCity => '75019 Париж';

  @override
  String get demoPaymentBrandVisa => 'Visa';

  @override
  String get commonInitialsFallback => 'Я';

  @override
  String get navHome => 'Главная';

  @override
  String get navAppointments => 'Приемы';

  @override
  String get navHealth => 'Здоровье';

  @override
  String get navMessages => 'Сообщения';

  @override
  String get navAccount => 'Аккаунт';
}
