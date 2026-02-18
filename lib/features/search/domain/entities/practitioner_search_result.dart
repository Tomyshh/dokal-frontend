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
    this.avatarUrl,
    this.distanceKm,
    this.availabilityOrder,
  });

  final String id;
  final String name;
  final String specialty;
  final String address;
  final String sector;
  final String nextAvailabilityLabel;
  final String? distanceLabel;
  final String? avatarUrl;

  /// Distance en km pour le tri (null = non disponible)
  final double? distanceKm;

  /// Ordre de disponibilité (0 = aujourd'hui, 1 = demain, 2 = cette semaine, etc.)
  final int? availabilityOrder;

  @override
  List<Object?> get props => [
    id,
    name,
    specialty,
    address,
    sector,
    nextAvailabilityLabel,
    distanceLabel,
    avatarUrl,
    distanceKm,
    availabilityOrder,
  ];
}
