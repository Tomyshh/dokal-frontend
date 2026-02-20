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
    this.languages,
    this.distanceKm,
    this.availabilityOrder,
    this.rating,
    this.reviewCount,
    this.priceMinAgorot,
    this.priceMaxAgorot,
  });

  final String id;
  final String name;
  final String specialty;
  final String address;
  final String sector;
  final String nextAvailabilityLabel;
  final String? distanceLabel;
  final String? avatarUrl;

  /// Langues parlées (codes ISO: he, en, fr, etc.)
  final List<String>? languages;

  /// Distance en km pour le tri (null = non disponible)
  final double? distanceKm;

  /// Ordre de disponibilité (0 = aujourd'hui, 1 = demain, 2 = cette semaine, etc.)
  final int? availabilityOrder;

  /// Note moyenne (ex: 4.5)
  final double? rating;

  /// Nombre d'avis
  final int? reviewCount;

  /// Prix min consultation en agorot (ILS × 100)
  final int? priceMinAgorot;

  /// Prix max consultation en agorot (ILS × 100)
  final int? priceMaxAgorot;

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
    languages,
    distanceKm,
    availabilityOrder,
    rating,
    reviewCount,
    priceMinAgorot,
    priceMaxAgorot,
  ];
}
