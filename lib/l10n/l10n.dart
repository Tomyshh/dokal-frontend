import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Retourne le libellé localisé pour un type de relation (child, parent, spouse, etc.)
extension AppLocalizationsRelationExtension on AppLocalizations {
  String relationLabel(String relation) {
    switch (relation) {
      case 'child':
        return relativeChild;
      case 'parent':
        return relativeParent;
      case 'spouse':
        return relativeSpouse;
      case 'sibling':
        return relativeSibling;
      case 'other':
        return relativeOther;
      default:
        return relation;
    }
  }
}

/// Retourne le libellé localisé pour le statut d'annulation d'un rendez-vous (vue patient).
extension AppLocalizationsAppointmentStatusExtension on AppLocalizations {
  String? patientAppointmentStatusLabel(String status) {
    switch (status) {
      case 'cancelled_by_patient':
        return appointmentStatusCancelledByPatient;
      case 'cancelled_by_practitioner':
        return appointmentStatusCancelledByPractitioner;
      default:
        return null;
    }
  }
}
