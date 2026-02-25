import '../errors/exceptions.dart';
import '../network/api_client.dart';

/// Service d'autocomplétion d'adresse via backend Dokal.
/// Le backend appelle Google Places avec sa clé serveur.
class GooglePlacesService {
  GooglePlacesService({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// Prédictions d'autocomplétion d'adresse.
  Future<List<PlacePrediction>> getPredictions(String input) async {
    final trimmed = input.trim();
    if (trimmed.length < 2) return [];

    try {
      final raw = await _api.get(
        '/api/v1/places/autocomplete',
        queryParameters: {
          'input': trimmed,
          'country': 'il',
          'language': 'he',
        },
      );
      if (raw is! Map<String, dynamic>) {
        throw const PlacesApiException(status: 'INVALID_RESPONSE');
      }
      final predictionsRaw =
          raw['predictions'] ?? raw['items'] ?? const <dynamic>[];
      if (predictionsRaw is! List<dynamic>) return [];
      return predictionsRaw
          .whereType<Map<String, dynamic>>()
          .map(_predictionFromJson)
          .where((p) => p.placeId.isNotEmpty && p.description.isNotEmpty)
          .toList();
    } on ServerException catch (e) {
      throw PlacesApiException(status: 'BACKEND_ERROR', message: e.message);
    } catch (e) {
      throw PlacesApiException(
        status: 'UNEXPECTED_ERROR',
        message: e.toString(),
      );
    }
  }

  PlacePrediction _predictionFromJson(Map<String, dynamic> json) {
    final placeId = _asString(json, ['place_id', 'placeId']);
    final description = _asString(json, ['description', 'label']);
    final mainText = _asString(json, ['main_text', 'mainText']);
    final resolvedMainText = mainText.isNotEmpty ? mainText : description;
    return PlacePrediction(
      placeId: placeId,
      description: description,
      mainText: resolvedMainText,
    );
  }

  /// Détails d'un lieu (address_line, zip_code, city).
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    if (placeId.isEmpty) return null;

    try {
      final raw = await _api.get(
        '/api/v1/places/details',
        queryParameters: {
          'place_id': placeId,
          'language': 'he',
        },
      );
      if (raw is! Map<String, dynamic>) {
        throw const PlacesApiException(status: 'INVALID_RESPONSE');
      }
      final detailsRaw = raw['result'] ?? raw;
      if (detailsRaw is! Map<String, dynamic>) return null;
      return _detailsFromJson(detailsRaw);
    } on ServerException catch (e) {
      throw PlacesApiException(status: 'BACKEND_ERROR', message: e.message);
    } catch (e) {
      throw PlacesApiException(
        status: 'UNEXPECTED_ERROR',
        message: e.toString(),
      );
    }
  }

  PlaceDetails _detailsFromJson(Map<String, dynamic> json) {
    // Backend peut soit renvoyer un payload simplifié, soit relayer le format Google.
    final directAddressLine = _asString(json, ['address_line', 'addressLine']);
    final directZip = _asString(json, ['zip_code', 'zipCode']);
    final directCity = _asString(json, ['city']);
    final directFormatted = _asString(
      json,
      ['formatted_address', 'formattedAddress'],
    );
    if (directAddressLine.isNotEmpty ||
        directZip.isNotEmpty ||
        directCity.isNotEmpty ||
        directFormatted.isNotEmpty) {
      final fallbackAddress = directAddressLine.isNotEmpty
          ? directAddressLine
          : directFormatted;
      return PlaceDetails(
        formattedAddress: directFormatted,
        addressLine: fallbackAddress,
        zipCode: directZip,
        city: directCity,
      );
    }

    final components = json['address_components'] as List<dynamic>? ?? [];
    String? streetNumber;
    String? route;
    String? locality;
    String? postalCode;
    String? sublocality;

    for (final c in components) {
      final map = c as Map<String, dynamic>;
      final types = (map['types'] as List<dynamic>?)?.cast<String>() ?? [];
      final long = map['long_name'] as String? ?? '';

      if (types.contains('street_number')) streetNumber = long;
      if (types.contains('route')) route = long;
      if (types.contains('locality')) locality = long;
      if (types.contains('postal_code')) postalCode = long;
      if (types.contains('sublocality') || types.contains('sublocality_level_1')) {
        sublocality ??= long;
      }
    }

    final city = locality ?? sublocality ?? '';
    final addressLine = [
      if (streetNumber != null) streetNumber,
      if (route != null) route,
    ].join(' ').trim();
    final formatted = json['formatted_address'] as String? ?? '';
    final effectiveAddressLine = addressLine.isNotEmpty ? addressLine : formatted;

    return PlaceDetails(
      formattedAddress: formatted,
      addressLine: effectiveAddressLine,
      zipCode: postalCode ?? '',
      city: city,
    );
  }

  static String _asString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }
}

class PlacesApiException implements Exception {
  const PlacesApiException({
    required this.status,
    this.message,
  });

  final String status;
  final String? message;

  @override
  String toString() => status;
}

class PlacePrediction {
  const PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
  });
  final String placeId;
  final String description;
  final String mainText;
}

class PlaceDetails {
  const PlaceDetails({
    required this.formattedAddress,
    required this.addressLine,
    required this.zipCode,
    required this.city,
  });
  final String formattedAddress;
  final String addressLine;
  final String zipCode;
  final String city;
}
