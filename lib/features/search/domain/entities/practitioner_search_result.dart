import 'package:equatable/equatable.dart';

class PractitionerSearchResult extends Equatable {
  const PractitionerSearchResult({
    required this.id,
    required this.name,
    required this.specialty,
    required this.address,
    required this.sector,
    required this.nextAvailabilityLabel,
    this.distanceLabel,
  });

  final String id;
  final String name;
  final String specialty;
  final String address;
  final String sector;
  final String nextAvailabilityLabel;
  final String? distanceLabel;

  @override
  List<Object?> get props => [
        id,
        name,
        specialty,
        address,
        sector,
        nextAvailabilityLabel,
        distanceLabel,
      ];
}

