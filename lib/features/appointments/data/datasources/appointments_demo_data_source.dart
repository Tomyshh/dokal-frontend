import '../../domain/entities/appointment.dart';

abstract class AppointmentsDemoDataSource {
  List<Appointment> upcoming();
  List<Appointment> past();
  Appointment? getById(String id);
  void cancel(String id);
}

class AppointmentsDemoDataSourceImpl implements AppointmentsDemoDataSource {
  final _upcoming = <Appointment>[
    const Appointment(
      id: 'demo',
      dateLabel: 'Jeudi 19 Février',
      timeLabel: '15:15',
      practitionerName: 'Dr Marc BENHAMOU',
      specialty: 'Ophtalmologiste',
      reason: 'Consultation (nouveau patient)',
      address: '28, avenue Secrétan, 75019 Paris',
    ),
  ];

  final _past = <Appointment>[];

  @override
  List<Appointment> upcoming() => List.unmodifiable(_upcoming);

  @override
  List<Appointment> past() => List.unmodifiable(_past);

  @override
  Appointment? getById(String id) {
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

