import 'package:flutter/foundation.dart';

import '../../features/account/domain/entities/user_profile.dart';
import '../../features/account/domain/usecases/get_profile.dart';
import '../../features/health/domain/entities/health_profile.dart';
import '../../features/health/domain/usecases/get_health_profile.dart';

enum ProfileGuardStatus { unknown, loading, complete, incomplete, error }

class ProfileCompletionNotifier extends ChangeNotifier {
  ProfileCompletionNotifier({
    required GetProfile getProfile,
    required GetHealthProfile getHealthProfile,
    required String? Function() getAuthEmail,
  }) : _getProfile = getProfile,
       _getHealthProfile = getHealthProfile,
       _getAuthEmail = getAuthEmail;

  final GetProfile _getProfile;
  final GetHealthProfile _getHealthProfile;
  final String? Function() _getAuthEmail;

  ProfileGuardStatus _status = ProfileGuardStatus.unknown;
  ProfileGuardStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isRefreshing = false;

  bool get needsCompletion => _status == ProfileGuardStatus.incomplete;

  void reset() {
    _status = ProfileGuardStatus.unknown;
    _errorMessage = null;
    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    _set(ProfileGuardStatus.loading);

    try {
      final profRes = await _getProfile();
      final healthRes = await _getHealthProfile();

      if (profRes.isLeft() || healthRes.isLeft()) {
        _errorMessage =
            profRes.fold((l) => l.message, (_) => null) ??
            healthRes.fold((l) => l.message, (_) => null);
        _set(ProfileGuardStatus.error);
        return;
      }

      final profile = profRes.getOrElse(() => throw StateError('No profile'));
      final healthProfile = healthRes.getOrElse(() => null);
      final authEmail = _getAuthEmail();

      final complete = _isCompletePatientProfile(
        profile: profile,
        healthProfile: healthProfile,
        authEmail: authEmail,
      );

      _errorMessage = null;
      _set(
        complete ? ProfileGuardStatus.complete : ProfileGuardStatus.incomplete,
      );
    } finally {
      _isRefreshing = false;
    }
  }

  void _set(ProfileGuardStatus next) {
    if (_status == next) return;
    _status = next;
    notifyListeners();
  }
}

bool _isCompletePatientProfile({
  required UserProfile profile,
  required HealthProfile? healthProfile,
  required String? authEmail,
}) {
  // Only enforce for patient accounts; other roles can have a different workflow.
  if (profile.role != 'patient') return true;

  final firstName = (profile.firstName ?? '').trim();
  final lastName = (profile.lastName ?? '').trim();
  final phone = (profile.phone ?? '').trim();
  final dob = (profile.dateOfBirth ?? '').trim();

  final email = (authEmail ?? profile.email).trim();

  final teudat = (healthProfile?.teudatZehut ?? '').trim();
  final kupat = (healthProfile?.kupatHolim ?? '').trim();

  return firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      phone.isNotEmpty &&
      email.isNotEmpty &&
      dob.isNotEmpty &&
      teudat.isNotEmpty &&
      kupat.isNotEmpty;
}
