import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/delete_relative.dart';
import '../../domain/usecases/update_relative.dart';
import '../../domain/usecases/upload_relative_avatar.dart';

part 'edit_relative_state.dart';

class EditRelativeCubit extends Cubit<EditRelativeState> {
  EditRelativeCubit({
    required UpdateRelative updateRelative,
    required DeleteRelative deleteRelative,
    required UploadRelativeAvatar uploadRelativeAvatar,
  })  : _updateRelative = updateRelative,
        _deleteRelative = deleteRelative,
        _uploadRelativeAvatar = uploadRelativeAvatar,
        super(const EditRelativeState.initial());

  final UpdateRelative _updateRelative;
  final DeleteRelative _deleteRelative;
  final UploadRelativeAvatar _uploadRelativeAvatar;

  Future<void> updateRelative({
    required String id,
    required String firstName,
    required String lastName,
    required String teudatZehut,
    required String dateOfBirth,
    required String relation,
    String? kupatHolim,
    String? insuranceProvider,
    String? avatarFilePath,
  }) async {
    emit(state.copyWith(status: EditRelativeStatus.loading));
    String? avatarUrl;
    if (avatarFilePath != null && avatarFilePath.trim().isNotEmpty) {
      final uploadRes =
          await _uploadRelativeAvatar(id, avatarFilePath.trim());
      final uploadFailed = uploadRes.fold(
        (f) {
          emit(
            state.copyWith(status: EditRelativeStatus.failure, error: f.message),
          );
          return true;
        },
        (url) {
          avatarUrl = url;
          return false;
        },
      );
      if (uploadFailed) return;
    }
    final res = await _updateRelative(
      id: id,
      firstName: firstName,
      lastName: lastName,
      teudatZehut: teudatZehut,
      dateOfBirth: _toIsoDate(dateOfBirth),
      relation: relation,
      kupatHolim: kupatHolim,
      insuranceProvider: insuranceProvider,
      avatarUrl: avatarUrl,
    );
    res.fold(
      (f) => emit(
        state.copyWith(status: EditRelativeStatus.failure, error: f.message),
      ),
      (_) => emit(state.copyWith(status: EditRelativeStatus.updateSuccess)),
    );
  }

  Future<void> deleteRelative(String id) async {
    emit(state.copyWith(status: EditRelativeStatus.loading));
    final res = await _deleteRelative(id);
    res.fold(
      (f) => emit(
        state.copyWith(status: EditRelativeStatus.failure, error: f.message),
      ),
      (_) => emit(state.copyWith(status: EditRelativeStatus.deleteSuccess)),
    );
  }

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
