// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get commonError => 'Error';

  @override
  String get commonEmail => 'Correo electrónico';

  @override
  String get commonEmailHint => 'p. ej., name@domain.com';

  @override
  String get commonEmailRequired => 'Correo obligatorio';

  @override
  String get commonEmailInvalid => 'Correo no válido';

  @override
  String get commonPassword => 'Contraseña';

  @override
  String get commonPasswordHint => '••••••••';

  @override
  String get commonPasswordRequired => 'Contraseña obligatoria';

  @override
  String commonPasswordMinChars(int min) {
    return 'Mínimo $min caracteres';
  }

  @override
  String get authLoginTitle => 'Iniciar sesión';

  @override
  String get authLoginSubtitle => 'Accede a tus citas, mensajes y documentos.';

  @override
  String get authLoginButton => 'Iniciar sesión';

  @override
  String get authForgotPasswordCta => '¿Olvidaste tu contraseña?';

  @override
  String get authCreateAccountCta => 'Crear una cuenta';

  @override
  String get authContinueWithoutAccount => 'Continuar sin cuenta';

  @override
  String get authRegisterTitle => 'Crear una cuenta';

  @override
  String get authRegisterSubtitle => 'Todos los campos son obligatorios.';

  @override
  String get authFirstName => 'Nombre';

  @override
  String get authLastName => 'Apellido';

  @override
  String get commonRequired => 'Obligatorio';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get authAlreadyHaveAccount => 'Ya tengo una cuenta';

  @override
  String get authForgotPasswordTitle => 'Olvidé mi contraseña';

  @override
  String get authForgotPasswordSubtitle =>
      'Te enviaremos un enlace para restablecerla.';

  @override
  String get authForgotPasswordSendLink => 'Enviar enlace';

  @override
  String get authBackToLogin => 'Volver a iniciar sesión';

  @override
  String get authForgotPasswordEmailSent =>
      'Correo enviado. Revisa tu bandeja de entrada.';

  @override
  String get authVerifyEmailTitle => 'Verifica tu correo';

  @override
  String authVerifyEmailDescription(Object email) {
    return 'Enviamos un correo de confirmación a $email. Haz clic en el enlace del correo y vuelve a la app.';
  }

  @override
  String get authVerifyEmailCheckedBackToLogin =>
      'Ya lo verifiqué, volver a iniciar sesión';

  @override
  String get authVerifyEmailResend => 'Reenviar correo';

  @override
  String get authVerifyEmailResentSnack => 'Correo de confirmación reenviado.';

  @override
  String get commonBack => 'Atrás';

  @override
  String get homeMyPractitioners => 'Mis profesionales';

  @override
  String get homeHistory => 'Historial';

  @override
  String homeGreeting(Object name) {
    return 'Hola $name';
  }

  @override
  String get homeSearchHint => 'Profesional, especialidad...';

  @override
  String get homeHealthTip1 => 'Este año, adopta hábitos saludables.';

  @override
  String get homeHealthTip2 => 'Aún estás a tiempo de vacunarte.';

  @override
  String get homeCompleteHealthProfile => 'Completa tu perfil de salud';

  @override
  String get homeCompleteHealthProfileSubtitle =>
      'Recibe recordatorios personalizados y prepárate para tus citas';

  @override
  String get homeStart => 'Empezar';

  @override
  String get homeNoRecentPractitioner => 'Sin profesional reciente';

  @override
  String get homeHistoryDescription =>
      'Puedes ver la lista de profesionales que has consultado';

  @override
  String get homeHistoryEnabledSnack => 'Historial activado';

  @override
  String get homeHistoryEnabled => 'Historial activado';

  @override
  String get homeActivateHistory => 'Activar historial';

  @override
  String homeNewMessageTitle(Object name) {
    return 'Tienes un nuevo mensaje del Dr. $name';
  }

  @override
  String get homeNewMessageNoAppointment => 'Sin cita relacionada';

  @override
  String get homeUpcomingAppointmentsTitle => 'Próximas citas';

  @override
  String get homeLast3AppointmentsTitle => 'Últimas 3 citas';

  @override
  String get homeSeeAllPastAppointments => 'Ver todas las citas pasadas';

  @override
  String get homeAppointmentHistoryTitle => 'Historial de citas';

  @override
  String get homeNoAppointmentHistory => 'No hay citas pasadas';

  @override
  String get commonTryAgainLater => 'Inténtalo más tarde.';

  @override
  String get commonUnableToLoad => 'No se pudo cargar';

  @override
  String get commonAvailableSoon => 'Disponible pronto';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonActionIsFinal => 'Esta acción es definitiva.';

  @override
  String get commonTodo => 'Por hacer';

  @override
  String get commonToRead => 'Por leer';

  @override
  String get commonSettings => 'Ajustes';

  @override
  String get commonTryAgainInAMoment => 'Inténtalo de nuevo en un momento.';

  @override
  String commonMinChars(int min) {
    return 'Mínimo $min caracteres';
  }

  @override
  String get commonOnline => 'En línea';

  @override
  String get appointmentsTitle => 'Mis citas';

  @override
  String get appointmentsTabUpcoming => 'Próximas';

  @override
  String get appointmentsTabPast => 'Pasadas';

  @override
  String get appointmentsNoUpcomingTitle => 'No hay próximas citas';

  @override
  String get appointmentsNoUpcomingSubtitle =>
      'Tus próximas citas aparecerán aquí.';

  @override
  String get appointmentsNoPastTitle => 'No hay citas pasadas';

  @override
  String get appointmentsNoPastSubtitle =>
      'Tus citas completadas aparecerán aquí.';

  @override
  String get searchTitle => 'Buscar';

  @override
  String get searchHint => 'Profesional, especialidad...';

  @override
  String get searchUnavailableTitle => 'Búsqueda no disponible';

  @override
  String get searchNoResultsTitle => 'Sin resultados';

  @override
  String get searchNoResultsSubtitle => 'Prueba con otro término.';

  @override
  String get searchFilterTitle => 'Filtrar resultados';

  @override
  String get searchFilterDate => 'Fecha de disponibilidad';

  @override
  String get searchFilterDateToday => 'Hoy';

  @override
  String get searchFilterDateTomorrow => 'Mañana';

  @override
  String get searchFilterDateThisWeek => 'Esta semana';

  @override
  String get searchFilterDateNextWeek => 'La próxima semana';

  @override
  String get searchFilterDateAny => 'Cualquier fecha';

  @override
  String get searchFilterSpecialty => 'Especialidad';

  @override
  String get searchFilterSpecialtyAll => 'Todas las especialidades';

  @override
  String get searchFilterKupatHolim => 'Caja de salud';

  @override
  String get searchFilterKupatHolimAll => 'Todas las cajas';

  @override
  String get searchFilterDistance => 'Distancia máxima';

  @override
  String get searchFilterDistanceAny => 'Sin límite';

  @override
  String get searchFilterApply => 'Aplicar filtros';

  @override
  String get searchFilterReset => 'Borrar todo';

  @override
  String searchFilterActiveCount(int count) {
    return '$count filtros activos';
  }

  @override
  String get searchSortTitle => 'Ordenar por';

  @override
  String get searchSortAvailability => 'Disponibilidad';

  @override
  String get searchSortDistance => 'Distancia';

  @override
  String get searchSortName => 'Nombre';

  @override
  String get searchSortRating => 'Valoración';

  @override
  String get onboardingStep1Title => 'Reserva citas fácilmente';

  @override
  String get onboardingStep2Title => 'Chatea fácilmente con tus profesionales';

  @override
  String get onboardingStep3Title =>
      'Accede a tus registros médicos en cualquier momento';

  @override
  String get onboardingContinueButton => 'Continuar';

  @override
  String get onboardingStartButton => 'Empezar';

  @override
  String get healthTitle => 'Mi salud';

  @override
  String get healthSubtitle => 'Gestiona tu perfil de salud';

  @override
  String get healthProfileTitle => 'Perfil de salud';

  @override
  String get healthProfileSubtitle => 'Completa información clave (Israel)';

  @override
  String get healthProfileIntro =>
      'Esta información nos ayuda a preparar tu atención en Israel (caja, médico de familia, alergias, etc.).';

  @override
  String get healthProfileSave => 'Guardar';

  @override
  String get healthProfileSavedSnack => 'Perfil guardado';

  @override
  String get healthProfileStepIdentity => 'Identidad';

  @override
  String get healthProfileStepKupatHolim => 'Caja';

  @override
  String get healthProfileStepMedical => 'Información médica';

  @override
  String get healthProfileStepEmergency => 'Contacto de emergencia';

  @override
  String get healthProfileTeudatZehut => 'Número de identificación';

  @override
  String get healthProfileDateOfBirth => 'Fecha de nacimiento';

  @override
  String get healthProfileSex => 'Sexo';

  @override
  String get healthProfileSexFemale => 'Mujer';

  @override
  String get healthProfileSexMale => 'Hombre';

  @override
  String get healthProfileSexOther => 'Otro';

  @override
  String get healthProfileKupatHolim => 'Caja de salud';

  @override
  String get healthProfileKupatMemberId => 'ID de miembro';

  @override
  String get healthProfileFamilyDoctor => 'Médico de familia';

  @override
  String get healthProfileEmergencyContactName =>
      'Nombre del contacto de emergencia';

  @override
  String get healthProfileEmergencyContactPhone => 'Teléfono de emergencia';

  @override
  String get kupatClalit => 'Clalit';

  @override
  String get kupatMaccabi => 'Maccabi';

  @override
  String get kupatMeuhedet => 'Meuhedet';

  @override
  String get kupatLeumit => 'Leumit';

  @override
  String get kupatOther => 'Otro';

  @override
  String get healthMyFileSectionTitle => 'Mi expediente';

  @override
  String get healthDocumentsTitle => 'Documentos';

  @override
  String get healthDocumentsSubtitle => 'Recetas, pruebas, informes';

  @override
  String get healthConditionsTitle => 'Condiciones médicas';

  @override
  String get healthConditionsSubtitle => 'Historial y condiciones';

  @override
  String get healthMedicationsTitle => 'Medicamentos';

  @override
  String get healthMedicationsSubtitle => 'Tratamientos actuales';

  @override
  String get healthAllergiesTitle => 'Alergias';

  @override
  String get healthAllergiesSubtitle => 'Alergias conocidas';

  @override
  String get healthVaccinationsTitle => 'Vacunas';

  @override
  String get healthVaccinationsSubtitle => 'Historial de vacunación';

  @override
  String get healthUpToDateTitle => 'Estás al día';

  @override
  String get healthUpToDateSubtitle =>
      'Te avisaremos cuando tengas nuevos recordatorios de salud.';

  @override
  String get appointmentDetailTitle => 'Detalles de la cita';

  @override
  String get appointmentDetailCancelledSnack => 'Cita cancelada';

  @override
  String get appointmentDetailNotFoundTitle => 'Cita no encontrada';

  @override
  String get appointmentDetailNotFoundSubtitle =>
      'Esta cita no está disponible o fue cancelada.';

  @override
  String get appointmentDetailReschedule => 'Reprogramar';

  @override
  String get appointmentDetailCancelQuestion => '¿Cancelar la cita?';

  @override
  String get appointmentDetailPreparationTitle => 'Se requiere preparación';

  @override
  String get appointmentDetailPreparationSubtitle =>
      'Prepara tu visita con antelación.';

  @override
  String get appointmentDetailPrepQuestionnaire =>
      'Rellenar el cuestionario de salud';

  @override
  String get appointmentDetailPrepInstructions => 'Ver instrucciones';

  @override
  String get appointmentPrepQuestionnaireSubtitle =>
      'Cuestionario estandarizado (listo para backend)';

  @override
  String get appointmentPrepInstructionsSubtitle =>
      'Información importante antes de la visita';

  @override
  String get appointmentPrepQuestionSymptoms => 'Motivo / síntomas (breve)';

  @override
  String get appointmentPrepQuestionAllergies => 'Alergias (opcional)';

  @override
  String get appointmentPrepQuestionMedications =>
      'Medicamentos actuales (opcional)';

  @override
  String get appointmentPrepQuestionOther => 'Información adicional (opcional)';

  @override
  String get appointmentPrepConsentLabel =>
      'Acepto compartir esta información con el profesional';

  @override
  String get appointmentPrepConsentRequired =>
      'Por favor, acepta para continuar.';

  @override
  String get appointmentPrepSavedSnack => 'Preparación guardada';

  @override
  String get appointmentPrepSubmit => 'Enviar';

  @override
  String get appointmentPrepInstruction1 =>
      'Trae un documento de identidad y tu tarjeta de seguro.';

  @override
  String get appointmentPrepInstruction2 => 'Llega 10 minutos antes.';

  @override
  String get appointmentPrepInstruction3 =>
      'Prepara tus documentos médicos importantes.';

  @override
  String get appointmentPrepInstructionsAccept =>
      'He leído y acepto estas instrucciones';

  @override
  String get appointmentDetailSendDocsTitle => 'Enviar documentos';

  @override
  String get appointmentDetailSendDocsSubtitle =>
      'Envía documentos al profesional antes de la cita.';

  @override
  String get appointmentDetailAddDocs => 'Añadir documentos';

  @override
  String get appointmentDetailEarlierSlotTitle =>
      '¿Quieres un horario más temprano?';

  @override
  String get appointmentDetailEarlierSlotSubtitle =>
      'Recibe una alerta si se libera un horario anterior.';

  @override
  String get appointmentDetailEnableAlerts => 'Activar alertas';

  @override
  String get appointmentDetailContactOffice => 'Contactar con la consulta';

  @override
  String get appointmentDetailVisitSummaryTitle => 'Resumen de la visita';

  @override
  String get appointmentDetailVisitSummarySubtitle =>
      'Puntos clave y siguientes pasos';

  @override
  String get appointmentDetailVisitSummaryDemo =>
      'Examen clínico completado. Se recomienda seguimiento en 3 meses y continuar el tratamiento según sea necesario.';

  @override
  String get appointmentDetailDoctorReportTitle => 'Informe del médico';

  @override
  String get appointmentDetailDoctorReportSubtitle =>
      'Nota médica escrita después de la visita';

  @override
  String get appointmentDetailDoctorReportDemo =>
      'El paciente acudió a consulta. Sin hallazgos preocupantes. Se recomienda seguimiento y traer documentos relevantes a la próxima cita.';

  @override
  String get appointmentDetailDocumentsAndRxTitle => 'Documentos y receta';

  @override
  String get appointmentDetailDocumentsAndRxSubtitle =>
      'Encuentra los documentos compartidos después de tu visita';

  @override
  String get appointmentDetailOpenVisitReport => 'Abrir informe de visita';

  @override
  String get appointmentDetailOpenPrescription => 'Abrir receta';

  @override
  String get appointmentDetailSendMessageCta => 'Enviar mensaje a la consulta';

  @override
  String get messagesTitle => 'Mensajes';

  @override
  String get messagesMarkAllRead => 'Marcar todo como leído';

  @override
  String get messagesEmptyTitle => 'Tus mensajes';

  @override
  String get messagesEmptySubtitle =>
      'Inicia una conversación con tus profesionales para solicitar un documento, hacer una pregunta o seguir tus resultados.';

  @override
  String get messagesNewMessageTitle => 'Nuevo mensaje';

  @override
  String get messagesWriteToOfficeTitle => 'Escribir a la consulta';

  @override
  String get messagesResponseTime => 'Respuesta en 24–48 h.';

  @override
  String get messagesSubjectLabel => 'Asunto';

  @override
  String get messagesSubjectHint => 'p. ej., Resultados, pregunta…';

  @override
  String get messagesSubjectRequired => 'Asunto obligatorio';

  @override
  String get messagesMessageLabel => 'Mensaje';

  @override
  String get messagesMessageHint => 'Escribe tu mensaje…';

  @override
  String get messagesSendButton => 'Enviar';

  @override
  String get conversationTitle => 'Conversación';

  @override
  String get conversationNewMessageTooltip => 'Nuevo mensaje';

  @override
  String get conversationWriteMessageHint => 'Escribe un mensaje…';

  @override
  String get practitionerTitle => 'Profesional';

  @override
  String get practitionerUnavailableTitle => 'Profesional no disponible';

  @override
  String get practitionerNotFoundTitle => 'Profesional no encontrado';

  @override
  String get practitionerNotFoundSubtitle => 'Este perfil no está disponible.';

  @override
  String get practitionerBookAppointment => 'Reservar una cita';

  @override
  String get practitionerSendMessage => 'Enviar un mensaje';

  @override
  String get practitionerAvailabilities => 'Disponibilidad';

  @override
  String get practitionerAddress => 'Dirección';

  @override
  String get practitionerProfileSection => 'Perfil';

  @override
  String get documentsTitle => 'Documentos';

  @override
  String get documentsEmptyTitle => 'Sin documentos';

  @override
  String get documentsEmptySubtitle =>
      'Tus recetas y resultados aparecerán aquí.';

  @override
  String get documentsOpen => 'Abrir';

  @override
  String get documentsShare => 'Compartir';

  @override
  String get authLogout => 'Cerrar sesión';

  @override
  String get securityTitle => 'Seguridad';

  @override
  String get securitySecureAccountTitle => 'Protege tu cuenta';

  @override
  String get securitySecureAccountSubtitle => 'Actualiza tu información';

  @override
  String get securityChangePassword => 'Cambiar contraseña';

  @override
  String get securityChangePasswordSuccess => 'Solicitud guardada';

  @override
  String get securityCurrentPassword => 'Contraseña actual';

  @override
  String get securityNewPassword => 'Nueva contraseña';

  @override
  String get accountTitle => 'Mi cuenta';

  @override
  String get accountTaglineTitle => 'Tu salud. Tus datos.';

  @override
  String get accountTaglineSubtitle => 'Tu privacidad es nuestra prioridad.';

  @override
  String get accountPersonalInfoSection => 'Información personal';

  @override
  String get accountMyProfile => 'Mi perfil';

  @override
  String get accountMyRelatives => 'Mis familiares';

  @override
  String get accountSectionTitle => 'Cuenta';

  @override
  String get privacyTitle => 'Privacidad';

  @override
  String get privacyYourDataTitle => 'Tus datos';

  @override
  String get privacyYourDataSubtitle =>
      'Protegemos tu información y limitamos el acceso a ella.';

  @override
  String get privacySharingTitle => 'Compartir';

  @override
  String get privacySharingSubtitle =>
      'Controla los documentos que compartes con tus profesionales.';

  @override
  String get privacyExportTitle => 'Exportar';

  @override
  String get privacyExportSubtitle => 'Exporta tus datos en cualquier momento.';

  @override
  String get paymentTitle => 'Pago';

  @override
  String get paymentEmptyTitle => 'Sin método de pago';

  @override
  String get paymentEmptySubtitle =>
      'Añade una tarjeta para simplificar la facturación.';

  @override
  String paymentExpires(Object expiry) {
    return 'Caduca $expiry';
  }

  @override
  String get relativesTitle => 'Mis familiares';

  @override
  String get relativesEmptyTitle => 'Sin familiar';

  @override
  String get relativesEmptySubtitle =>
      'Añade familiares para reservar citas en su nombre.';

  @override
  String get settingsUnavailableTitle => 'Ajustes no disponibles';

  @override
  String get settingsUnavailableSubtitle =>
      'No se pudieron cargar tus preferencias.';

  @override
  String get settingsNotificationsTitle => 'Notificaciones';

  @override
  String get settingsNotificationsSubtitle =>
      'Recibe mensajes y actualizaciones';

  @override
  String get settingsRemindersTitle => 'Recordatorios de citas';

  @override
  String get settingsRemindersSubtitle =>
      'Recibe recordatorios antes de tus citas';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsLanguageCurrentLabel => 'Español (actual)';

  @override
  String get settingsLanguageShortLabel => 'Español';

  @override
  String get profileTitle => 'Mi perfil';

  @override
  String get profileUnavailableTitle => 'Perfil no disponible';

  @override
  String get profileUnavailableSubtitle => 'Tu información no está disponible.';

  @override
  String get profileIdentitySection => 'Identidad';

  @override
  String get commonName => 'Nombre';

  @override
  String get commonAddress => 'Dirección';

  @override
  String get commonCity => 'Ciudad';

  @override
  String get profileMedicalInfoSection => 'Información médica';

  @override
  String get profileBloodType => 'Grupo sanguíneo';

  @override
  String get profileHeight => 'Altura';

  @override
  String get profileWeight => 'Peso';

  @override
  String get bookingSelectPatientTitle => '¿Para quién es esta cita?';

  @override
  String get bookingPatientsUnavailableTitle => 'Pacientes no disponibles';

  @override
  String get bookingAddRelative => 'Añadir un familiar';

  @override
  String get commonMe => 'yo';

  @override
  String get bookingSelectSlotTitle => 'Elige una fecha';

  @override
  String get bookingSelectSlotSubtitle =>
      'Selecciona una fecha y hora disponibles.';

  @override
  String get bookingSeeMoreDates => 'Ver más fechas';

  @override
  String get commonSelected => 'Seleccionado';

  @override
  String get bookingInstructionsTitle => 'Instrucciones';

  @override
  String get bookingInstructionsSubtitle =>
      'Antes de la cita, revisa estos puntos.';

  @override
  String get bookingInstructionsBullet1 =>
      'Trae tu tarjeta de seguro y receta si es necesario.';

  @override
  String get bookingInstructionsBullet2 =>
      'Llega 10 minutos antes para los trámites.';

  @override
  String get bookingInstructionsBullet3 =>
      'En caso de cancelación, avísanos lo antes posible.';

  @override
  String get bookingInstructionsAccept =>
      'He leído y acepto estas instrucciones.';

  @override
  String get bookingConfirmTitle => 'Confirmar la cita';

  @override
  String get bookingConfirmSubtitle =>
      'Revisa la información antes de confirmar.';

  @override
  String get bookingReasonLabel => 'Motivo';

  @override
  String get bookingPatientLabel => 'Paciente';

  @override
  String get bookingSlotLabel => 'Horario';

  @override
  String get bookingMissingInfoTitle => 'Falta información';

  @override
  String get bookingZipCodeLabel => 'Código postal';

  @override
  String get bookingVisitedBeforeQuestion =>
      '¿Ya has visto a este profesional?';

  @override
  String get commonYes => 'Sí';

  @override
  String get commonNo => 'No';

  @override
  String get bookingConfirmButton => 'Confirmar cita';

  @override
  String get bookingChangeSlotButton => 'Cambiar horario';

  @override
  String get bookingSuccessTitle => 'Cita confirmada';

  @override
  String get bookingSuccessSubtitle => 'Enviamos una confirmación a tu correo.';

  @override
  String get bookingAddToCalendar => 'Añadir a mi calendario';

  @override
  String get bookingBookAnotherAppointment => 'Reservar otra cita';

  @override
  String get bookingSendDocsSubtitle =>
      'Envía documentos a tu profesional para la cita.';

  @override
  String get bookingViewMyAppointments => 'Ver mis citas';

  @override
  String get bookingBackToHome => 'Volver al inicio';

  @override
  String get vaccinationsEmptyTitle => 'No hay vacunas registradas';

  @override
  String get vaccinationsEmptySubtitle =>
      'Haz seguimiento de tus vacunas y recordatorios.';

  @override
  String get allergiesEmptyTitle => 'Sin alergias';

  @override
  String get allergiesEmptySubtitle =>
      'Declara tus alergias para tu seguridad.';

  @override
  String get medicationsEmptyTitle => 'Sin medicamentos';

  @override
  String get medicationsEmptySubtitle => 'Añade tus tratamientos actuales.';

  @override
  String get conditionsEmptyTitle => 'Sin condición';

  @override
  String get conditionsEmptySubtitle =>
      'Añade tu historial médico para tus citas.';

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
  String get errorGenericTryAgain => 'Ocurrió un error. Inténtalo de nuevo.';

  @override
  String get authSignInFailedTryAgain =>
      'Error al iniciar sesión. Inténtalo de nuevo.';

  @override
  String get authSignUpFailedTryAgain =>
      'Error al registrarse. Inténtalo de nuevo.';

  @override
  String get errorUnableToConfirmAppointment => 'No se pudo confirmar la cita.';

  @override
  String get errorUnableToLoadProfile => 'No se pudo cargar el perfil.';

  @override
  String get errorUnableToReadHistoryState =>
      'No se pudo leer el estado del historial.';

  @override
  String get errorUnableToEnableHistory => 'No se pudo activar el historial.';

  @override
  String get errorUnableToLoadRelatives =>
      'No se pudieron cargar los familiares.';

  @override
  String get errorUnableToAddRelative => 'No se pudo añadir el familiar.';

  @override
  String get errorUnableToLoadPayments => 'No se pudieron cargar los pagos.';

  @override
  String get errorUnableToAddPaymentMethod =>
      'No se pudo añadir un método de pago.';

  @override
  String get errorUnableToLoadHealthData =>
      'No se pudieron cargar los datos de salud.';

  @override
  String get errorUnableToAddHealthItem => 'No se pudo añadir el elemento.';

  @override
  String get errorUnableToLoadHealthProfile =>
      'No se pudo cargar el perfil de salud.';

  @override
  String get errorUnableToSaveHealthProfile =>
      'No se pudo guardar el perfil de salud.';

  @override
  String get errorUnableToLoadPractitioner =>
      'No se pudo cargar el profesional.';

  @override
  String get errorUnableToLoadSearch => 'No se pudo cargar la búsqueda.';

  @override
  String get errorUnableToLoadDocuments =>
      'No se pudieron cargar los documentos.';

  @override
  String get errorUnableToAddDocument => 'No se pudo añadir el documento.';

  @override
  String get errorUnableToReadSettings => 'No se pudieron leer los ajustes.';

  @override
  String get errorUnableToSaveSettings => 'No se pudieron guardar los ajustes.';

  @override
  String get errorUnableToLoadUpcomingAppointments =>
      'No se pudieron cargar las próximas citas.';

  @override
  String get errorUnableToLoadHistory => 'No se pudo cargar el historial.';

  @override
  String get errorUnableToLoadAppointment => 'No se pudo cargar la cita.';

  @override
  String get errorUnableToCancelAppointment => 'No se pudo cancelar la cita.';

  @override
  String get errorUnableToLoadConversations =>
      'No se pudieron cargar las conversaciones.';

  @override
  String get errorUnableToLoadConversation =>
      'No se pudo cargar la conversación.';

  @override
  String get errorUnableToSendMessage => 'No se pudo enviar el mensaje.';

  @override
  String get errorUnableToReadOnboardingState =>
      'No se pudo leer el estado del onboarding.';

  @override
  String get errorUnableToSaveOnboarding => 'No se pudo guardar el onboarding.';

  @override
  String timeMinutesAgo(int minutes) {
    return 'hace $minutes min';
  }

  @override
  String timeHoursAgo(int hours) {
    return 'hace $hours h';
  }

  @override
  String timeDaysAgo(int days) {
    return 'hace $days d';
  }

  @override
  String get demoDentalOfficeName => 'Consultorio dental';

  @override
  String get demoConversation1LastMessage =>
      'Hola, tus resultados están disponibles...';

  @override
  String get demoConversation2LastMessage =>
      'Perfecto, ¡te envío el documento!';

  @override
  String get demoConversation3LastMessage => '¡Gracias por tu visita!';

  @override
  String get demoAppointmentConsultation => 'Consulta';

  @override
  String get demoAppointmentFollowUp => 'Seguimiento médico';

  @override
  String get demoShortDateThu19Feb => 'jue 19 feb';

  @override
  String get demoShortDateMon15Feb => 'lun 15 feb';

  @override
  String get demoMessage1_1 => 'Hola, ¿en qué podemos ayudarte?';

  @override
  String get demoMessage1_2 => 'Hola, me gustaría obtener mi informe.';

  @override
  String get demoMessage1_3 => 'Claro, ¿podrías indicar la fecha de la cita?';

  @override
  String get demoMessage2_1 => 'Hola, tu expediente está al día.';

  @override
  String get demoMessage3_1 => '¡Hola!';

  @override
  String get demoMessage3_2 => 'Gracias, doctor.';

  @override
  String get relativeRelation => 'Familiar';

  @override
  String get relativeChild => 'Hijo';

  @override
  String get relativeParent => 'Padre/Madre';

  @override
  String relativeDemoName(int index) {
    return 'Familiar $index';
  }

  @override
  String relativeLabel(Object relation, int year) {
    return '$relation • $year';
  }

  @override
  String documentsDemoTitle(int index) {
    return 'Documento $index';
  }

  @override
  String get documentsDemoTypeLabel => 'Informe';

  @override
  String get documentsDemoDateLabelToday => 'Hoy';

  @override
  String get demoSpecialtyOphthalmologist => 'Oftalmólogo';

  @override
  String get demoSpecialtyGeneralPractitioner => 'Médico general';

  @override
  String get demoPractitionerAbout =>
      'El oftalmólogo trata enfermedades oculares y maneja la refracción, el estrabismo y los trastornos de visión.\n\nEste perfil está listo para conectarse al backend.';

  @override
  String demoAvailabilityTodayAt(Object time) {
    return 'Hoy • $time';
  }

  @override
  String demoAvailabilityTomorrowAt(Object time) {
    return 'Mañana • $time';
  }

  @override
  String demoAvailabilityThisWeekAt(Object time) {
    return 'Esta semana • $time';
  }

  @override
  String demoSearchPractitionerName(int index) {
    return 'Dr. Profesional $index';
  }

  @override
  String get demoSearchAddress => '75019 París • Avenue Secrétan';

  @override
  String get demoSearchSector1 => 'Sector 1';

  @override
  String get demoAvailabilityToday => 'Hoy';

  @override
  String get demoAvailabilityThisWeek => 'Esta semana';

  @override
  String get demoDistance12km => '1,2 km';

  @override
  String get demoAppointmentDateThu19Feb => 'jueves, 19 de febrero';

  @override
  String get demoAppointmentReasonNewPatientConsultation =>
      'Consulta (paciente nuevo)';

  @override
  String get demoPractitionerNameMarc => 'Dr. Marc BENHAMOU';

  @override
  String get demoPractitionerNameSarah => 'Dr. Sarah COHEN';

  @override
  String get demoPractitionerNameNoam => 'Dr. Noam LEVI';

  @override
  String get demoPractitionerNameMarcShort => 'Dr. Marc B.';

  @override
  String get demoPractitionerNameSophie => 'Dr. Sophie L.';

  @override
  String get demoPatientNameTom => 'Tom';

  @override
  String get demoAddressParis => '28, avenue Secrétan, 75019 París';

  @override
  String get demoProfileFullName => 'Tom Jami';

  @override
  String get demoProfileEmail => 'tom@domaine.com';

  @override
  String get demoProfileCity => '75019 París';

  @override
  String get demoPaymentBrandVisa => 'Visa';

  @override
  String get commonInitialsFallback => 'YO';

  @override
  String get navHome => 'Inicio';

  @override
  String get navAppointments => 'Citas';

  @override
  String get navHealth => 'Salud';

  @override
  String get navMessages => 'Mensajes';

  @override
  String get navAccount => 'Cuenta';
}
