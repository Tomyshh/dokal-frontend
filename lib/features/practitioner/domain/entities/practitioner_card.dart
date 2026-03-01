import 'package:equatable/equatable.dart';

class PractitionerCard extends Equatable {
  const PractitionerCard({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    this.specialty,
    this.organizationName,
    this.phone,
    this.email,
    this.city,
    this.addressLine,
    this.about,
    this.education,
    this.languages,
    this.yearsOfExperience,
    this.websiteUrl,
    this.facebookUrl,
    this.instagramUrl,
    this.whatsappNumber,
    this.linkedinUrl,
    this.tiktokUrl,
    this.youtubeUrl,
    this.wazeLink,
    this.googleMapsLink,
    this.cardHeadline,
    this.cardSlug,
    this.averageRating,
    this.reviewCount = 0,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final String? specialty;
  final String? organizationName;
  final String? phone;
  final String? email;
  final String? city;
  final String? addressLine;
  final String? about;
  final String? education;
  final List<String>? languages;
  final int? yearsOfExperience;
  final String? websiteUrl;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? whatsappNumber;
  final String? linkedinUrl;
  final String? tiktokUrl;
  final String? youtubeUrl;
  final String? wazeLink;
  final String? googleMapsLink;
  final String? cardHeadline;
  final String? cardSlug;
  final double? averageRating;
  final int reviewCount;

  String get fullName => 'Dr. $firstName $lastName';
  String get headline => cardHeadline ?? specialty ?? '';

  factory PractitionerCard.fromJson(Map<String, dynamic> json) {
    final profiles = json['profiles'] as Map<String, dynamic>?;
    final specialties = json['specialties'] as Map<String, dynamic>?;
    final organizations = json['organizations'] as Map<String, dynamic>?;
    final rawLangs = json['languages'];

    return PractitionerCard(
      id: json['id'] as String,
      firstName: profiles?['first_name'] as String? ?? '',
      lastName: profiles?['last_name'] as String? ?? '',
      avatarUrl: profiles?['avatar_url'] as String?,
      specialty: specialties?['name'] as String?,
      organizationName: organizations?['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      city: json['city'] as String?,
      addressLine: json['address_line'] as String?,
      about: json['about'] as String?,
      education: json['education'] as String?,
      languages: rawLangs is List ? rawLangs.cast<String>() : null,
      yearsOfExperience: json['years_of_experience'] as int?,
      websiteUrl: json['website_url'] as String?,
      facebookUrl: json['facebook_url'] as String?,
      instagramUrl: json['instagram_url'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      tiktokUrl: json['tiktok_url'] as String?,
      youtubeUrl: json['youtube_url'] as String?,
      wazeLink: json['waze_link'] as String?,
      googleMapsLink: json['google_maps_link'] as String?,
      cardHeadline: json['card_headline'] as String?,
      cardSlug: json['card_slug'] as String?,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, cardSlug];
}
