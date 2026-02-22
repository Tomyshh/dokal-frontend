import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_relative.dart';
import '../../domain/usecases/upload_relative_avatar.dart';

part 'add_relative_state.dart';

class AddRelativeCubit extends Cubit<AddRelativeState> {
  AddRelativeCubit({
    required AddRelative addRelative,
    required UploadRelativeAvatar uploadRelativeAvatar,
  })  : _addRelative = addRelative,
        _uploadRelativeAvatar = uploadRelativeAvatar,
        super(const AddRelativeState.initial());

  final AddRelative _addRelative;
  final UploadRelativeAvatar _uploadRelativeAvatar;

  Future<void> addRelative({
    required String firstName,
    required String lastName,
    required String teudatZehut,
    required String dateOfBirth,
    required String relation,
    String? kupatHolim,
    String? insuranceProvider,
    String? avatarFilePath,
  }) async {
    emit(state.copyWith(status: AddRelativeStatus.loading));
    final res = await _addRelative(
      firstName: firstName,
      lastName: lastName,
      teudatZehut: teudatZehut,
      dateOfBirth: _toIsoDate(dateOfBirth),
      relation: relation,
      kupatHolim: kupatHolim,
      insuranceProvider: insuranceProvider,
    );
    await res.fold(
      (f) async => emit(
        state.copyWith(status: AddRelativeStatus.failure, error: f.message),
      ),
      (relative) async {
        if (avatarFilePath != null && avatarFilePath.trim().isNotEmpty) {
          final uploadRes =
              await _uploadRelativeAvatar(relative.id, avatarFilePath.trim());
          uploadRes.fold(
            (f) => emit(
              state.copyWith(
                status: AddRelativeStatus.failure,
                error: f.message,
              ),
            ),
            (_) => emit(state.copyWith(status: AddRelativeStatus.success)),
          );
        } else {
          emit(state.copyWith(status: AddRelativeStatus.success));
        }
      },
    );
  }

  /// Converts DD/MM/YYYY to YYYY-MM-DD for API.
  String? _toIsoDate(String date) {
    final parts = date.split('/');
    if (parts.length != 3) return date;
    final day = parts[0].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];
    if (day.length != 2 || month.length != 2 || year.length != 4) return date;
    return '$year-$month-$day';
  }
}
