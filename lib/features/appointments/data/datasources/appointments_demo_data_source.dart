import '../../domain/entities/appointment.dart';
import '../../../../l10n/l10n_static.dart';

abstract class AppointmentsDemoDataSource {
  List<Appointment> upcoming();
  List<Appointment> past();
  Appointment? getById(String id);
  void cancel(String id);
}

class AppointmentsDemoDataSourceImpl implements AppointmentsDemoDataSource {
  final _upcoming = <Appointment>[];
  final _past = <Appointment>[];

  // Avatar URLs for practitioners
  static const _avatarMarc =
      'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=150&h=150&fit=crop&crop=face';
  static const _avatarSarah =
      'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=150&h=150&fit=crop&crop=face';
  static const _avatarNoam =
      'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=150&h=150&fit=crop&crop=face';

  void _ensureSeeded() {
    if (_upcoming.isNotEmpty) return;
    final l10n = l10nStatic;
    _upcoming.add(
      Appointment(
        id: 'demo',
        practitionerId: 'p1',
        dateLabel: l10n.demoAppointmentDateThu19Feb,
        timeLabel: '15:15',
        practitionerName: l10n.demoPractitionerNameMarc,
        specialty: l10n.demoSpecialtyOphthalmologist,
        reason: l10n.demoAppointmentReasonNewPatientConsultation,
        isPast: false,
        patientName: l10n.demoPatientNameTom,
        address: l10n.demoAddressParis,
        avatarUrl: _avatarMarc,
      ),
    );

    // Seed "past" appointments so the Home can show recent doctors (max 3).
    _past.addAll([
      Appointment(
        id: 'past-1',
        practitionerId: 'p2',
        dateLabel: l10n.demoShortDateMon15Feb,
        timeLabel: '10:00',
        practitionerName: l10n.demoPractitionerNameSarah,
        specialty: l10n.demoSpecialtyGeneralPractitioner,
        reason: l10n.demoAppointmentFollowUp,
        isPast: true,
        patientName: l10n.demoPatientNameTom,
        address: l10n.demoAddressParis,
        avatarUrl: _avatarSarah,
      ),
      Appointment(
        id: 'past-2',
        practitionerId: 'p1',
        dateLabel: l10n.demoShortDateThu19Feb,
        timeLabel: '09:30',
        practitionerName: l10n.demoPractitionerNameMarc,
        specialty: l10n.demoSpecialtyOphthalmologist,
        reason: l10n.demoAppointmentConsultation,
        isPast: true,
        patientName: l10n.demoPatientNameTom,
        address: l10n.demoAddressParis,
        avatarUrl: _avatarMarc,
      ),
      Appointment(
        id: 'past-3',
        practitionerId: 'p3',
        dateLabel: l10n.demoShortDateMon15Feb,
        timeLabel: '16:45',
        practitionerName: l10n.demoPractitionerNameNoam,
        specialty: l10n.demoSpecialtyGeneralPractitioner,
        reason: l10n.demoAppointmentConsultation,
        isPast: true,
        patientName: l10n.demoPatientNameTom,
        address: l10n.demoAddressParis,
        avatarUrl: _avatarNoam,
      ),
    ]);
  }

  @override
  List<Appointment> upcoming() {
    _ensureSeeded();
    return List.unmodifiable(_upcoming);
  }

  @override
  List<Appointment> past() {
    _ensureSeeded();
    return List.unmodifiable(_past);
  }

  @override
  Appointment? getById(String id) {
    _ensureSeeded();
    for (final a in _upcoming) {
      if (a.id == id) return a;
    }
    for (final a in _past) {
      if (a.id == id) return a;
    }
    return null;
  }

  @override
  void cancel(String id) {
    _upcoming.removeWhere((a) => a.id == id);
  }
}
