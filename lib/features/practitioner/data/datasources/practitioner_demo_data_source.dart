import '../../domain/entities/practitioner_profile.dart';

abstract class PractitionerDemoDataSource {
  PractitionerProfile getById(String id);
}

class PractitionerDemoDataSourceImpl implements PractitionerDemoDataSource {
  @override
  PractitionerProfile getById(String id) {
    return PractitionerProfile(
      id: id,
      name: 'Dr Marc BENHAMOU',
      specialty: 'Ophtalmologiste',
      address: '28, avenue Secrétan, 75019 Paris',
      about:
          'L’ophtalmologue traite les maladies de l’œil, et prend en charge la réfraction, '
          'le strabisme, et les troubles de la vision.\n\n'
          'Ce profil est prêt à être branché au backend.',
      nextAvailabilities: const [
        'Aujourd’hui • 14:30',
        'Demain • 09:15',
        'Cette semaine • 15:15',
      ],
    );
  }
}

