import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/relative.dart';
import '../../domain/entities/user_profile.dart';
import 'account_demo_data_source.dart';

/// Remote implementation of [AccountDemoDataSource] backed by the Dokal
/// backend REST API.
class AccountRemoteDataSourceImpl implements AccountDemoDataSource {
  AccountRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------

  @override
  UserProfile getProfile() =>
      throw UnimplementedError('Use getProfileAsync instead');

  Future<UserProfile> getProfileAsync() async {
    final json = await api.get('/api/v1/profile') as Map<String, dynamic>;
    final firstName = json['first_name'] as String? ?? '';
    final lastName = json['last_name'] as String? ?? '';
    final fullName = '$firstName $lastName'.trim();
    return UserProfile(
      id: json['id'] as String? ?? '',
      fullName: fullName.isNotEmpty
          ? fullName
          : (json['email'] as String? ?? ''),
      email: json['email'] as String? ?? '',
      city: json['city'] as String? ?? '',
      role: json['role'] as String? ?? 'patient',
      firstName: firstName.isNotEmpty ? firstName : null,
      lastName: lastName.isNotEmpty ? lastName : null,
      phone: json['phone'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      sex: json['sex'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Future<void> updateProfileAsync({
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
    String? dateOfBirth,
    String? sex,
  }) async {
    final data = <String, dynamic>{};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (phone != null) data['phone'] = phone;
    if (city != null) data['city'] = city;
    if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth;
    if (sex != null) data['sex'] = sex;
    if (data.isNotEmpty) {
      await api.patch('/api/v1/profile', data: data);
    }
  }

  Future<String?> uploadAvatarAsync(String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });
    final json =
        await api.post('/api/v1/profile/avatar', data: formData)
            as Map<String, dynamic>;
    return json['avatar_url'] as String?;
  }

  // ---------------------------------------------------------------------------
  // Relatives
  // ---------------------------------------------------------------------------

  @override
  List<Relative> listRelatives() =>
      throw UnimplementedError('Use listRelativesAsync instead');

  Future<List<Relative>> listRelativesAsync() async {
    final data = await api.get('/api/v1/relatives') as List<dynamic>;
    return data.map((json) {
      final j = json as Map<String, dynamic>;
      final firstName = j['first_name'] as String? ?? '';
      final lastName = j['last_name'] as String? ?? '';
      final relation = j['relation'] as String? ?? '';
      final dob = j['date_of_birth'] as String?;
      final year = dob != null && dob.length >= 4 ? dob.substring(0, 4) : '';
      return Relative(
        id: j['id'] as String,
        name: '$firstName $lastName'.trim(),
        label: '$relation${year.isNotEmpty ? ' - $year' : ''}',
        firstName: firstName.isEmpty ? null : firstName,
        lastName: lastName.isEmpty ? null : lastName,
        relation: relation.isEmpty ? null : relation,
        dateOfBirth: dob,
        teudatZehut: j['teudat_zehut'] as String?,
        kupatHolim: j['kupat_holim'] as String?,
        insuranceProvider: j['insurance_provider'] as String?,
        avatarUrl: j['avatar_url'] as String?,
      );
    }).toList();
  }

  @override
  void addRelativeDemo() =>
      throw UnimplementedError('Use addRelativeAsync instead');

  Future<Relative> addRelativeAsync({
    required String firstName,
    required String lastName,
    required String teudatZehut,
    String? dateOfBirth,
    required String relation,
    String? kupatHolim,
    String? insuranceProvider,
    String? avatarUrl,
  }) async {
    final json =
        await api.post(
              '/api/v1/relatives',
              data: {
                'first_name': firstName,
                'last_name': lastName,
                'teudat_zehut': teudatZehut,
                if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
                'relation': relation,
                if (kupatHolim != null && kupatHolim.isNotEmpty)
                  'kupat_holim': kupatHolim,
                if (insuranceProvider != null && insuranceProvider.isNotEmpty)
                  'insurance_provider': insuranceProvider,
                if (avatarUrl != null && avatarUrl.isNotEmpty)
                  'avatar_url': avatarUrl,
              },
            )
            as Map<String, dynamic>;
    final dob = json['date_of_birth'] as String?;
    final year = dob != null && dob.length >= 4 ? dob.substring(0, 4) : '';
    return Relative(
      id: json['id'] as String,
      name: '${json['first_name']} ${json['last_name']}'.trim(),
      label: '${json['relation']}${year.isNotEmpty ? ' - $year' : ''}',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      relation: json['relation'] as String?,
      dateOfBirth: dob,
      teudatZehut: json['teudat_zehut'] as String?,
      kupatHolim: json['kupat_holim'] as String?,
      insuranceProvider: json['insurance_provider'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Future<void> deleteRelative(String id) async {
    await api.delete('/api/v1/relatives/$id');
  }

  Future<String?> uploadRelativeAvatarAsync(String relativeId, String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });
    final json =
        await api.post(
              '/api/v1/relatives/$relativeId/avatar',
              data: formData,
            )
            as Map<String, dynamic>;
    return json['avatar_url'] as String?;
  }

  Future<Relative> updateRelativeAsync({
    required String id,
    required String firstName,
    required String lastName,
    required String teudatZehut,
    String? dateOfBirth,
    required String relation,
    String? kupatHolim,
    String? insuranceProvider,
    String? avatarUrl,
  }) async {
    final json =
        await api.patch(
              '/api/v1/relatives/$id',
              data: {
                'first_name': firstName,
                'last_name': lastName,
                'teudat_zehut': teudatZehut,
                if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
                'relation': relation,
                if (kupatHolim != null && kupatHolim.isNotEmpty)
                  'kupat_holim': kupatHolim,
                if (insuranceProvider != null && insuranceProvider.isNotEmpty)
                  'insurance_provider': insuranceProvider,
                if (avatarUrl != null && avatarUrl.isNotEmpty)
                  'avatar_url': avatarUrl,
              },
            )
            as Map<String, dynamic>;
    final dob = json['date_of_birth'] as String?;
    final year = dob != null && dob.length >= 4 ? dob.substring(0, 4) : '';
    return Relative(
      id: json['id'] as String,
      name: '${json['first_name']} ${json['last_name']}'.trim(),
      label: '${json['relation']}${year.isNotEmpty ? ' - $year' : ''}',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      relation: json['relation'] as String?,
      dateOfBirth: dob,
      teudatZehut: json['teudat_zehut'] as String?,
      kupatHolim: json['kupat_holim'] as String?,
      insuranceProvider: json['insurance_provider'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  // ---------------------------------------------------------------------------
  // Payment methods
  // ---------------------------------------------------------------------------

  @override
  List<PaymentMethod> listPaymentMethods() =>
      throw UnimplementedError('Use listPaymentMethodsAsync instead');

  Future<List<PaymentMethod>> listPaymentMethodsAsync() async {
    final data = await api.get('/api/v1/payments/methods') as List<dynamic>;
    return data.map((json) {
      final j = json as Map<String, dynamic>;
      return PaymentMethod(
        id: j['id'] as String,
        brandLabel: j['brand'] as String? ?? '',
        last4: j['last4'] as String? ?? '',
        expiry: '${j['expiry_month']}/${j['expiry_year']}',
        isDefault: j['is_default'] as bool? ?? false,
      );
    }).toList();
  }

  @override
  void addPaymentMethodDemo() =>
      throw UnimplementedError('Use addPaymentMethodAsync instead');

  Future<PaymentMethod> addPaymentMethodAsync({
    required String brand,
    required String last4,
    required int expiryMonth,
    required int expiryYear,
  }) async {
    final json =
        await api.post(
              '/api/v1/payments/methods',
              data: {
                'brand': brand,
                'last4': last4,
                'expiry_month': expiryMonth,
                'expiry_year': expiryYear,
              },
            )
            as Map<String, dynamic>;
    return PaymentMethod(
      id: json['id'] as String,
      brandLabel: json['brand'] as String? ?? brand,
      last4: json['last4'] as String? ?? last4,
      expiry: '${json['expiry_month']}/${json['expiry_year']}',
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Future<void> deletePaymentMethod(String id) async {
    await api.delete('/api/v1/payments/methods/$id');
  }

  Future<void> setDefaultPaymentMethod(String id) async {
    await api.patch('/api/v1/payments/methods/$id/default');
  }

  // ---------------------------------------------------------------------------
  // Account deletion
  // ---------------------------------------------------------------------------

  Future<void> deleteAccountAsync() async {
    // Backend must delete the authenticated user and all associated data.
    await api.delete('/api/v1/account');
  }
}
