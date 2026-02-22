import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/insurance_providers.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_avatar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/edit_profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _teudatZehutController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  String _kupatHolim = '';
  String? _insuranceProvider;
  String? _avatarFilePath;
  bool _formInitialized = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _teudatZehutController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _hydrateFromState(EditProfileState state) {
    if (_formInitialized || state.profile == null) return;
    _formInitialized = true;
    final p = state.profile!;
    final h = state.healthProfile;
    _firstNameController.text =
        p.firstName ?? p.fullName.split(' ').firstOrNull ?? '';
    _lastNameController.text = p.lastName ??
        (p.fullName.split(' ').length > 1
            ? p.fullName.split(' ').sublist(1).join(' ')
            : '');
    _teudatZehutController.text = h?.teudatZehut ?? '';
    _dateOfBirthController.text = _formatDateForDisplay(
      h?.dateOfBirth ?? p.dateOfBirth,
    );
    _kupatHolim = (h?.kupatHolim ?? '').trim().isEmpty ? '' : (h!.kupatHolim);
    _insuranceProvider = (h?.insuranceProvider ?? '').trim().isEmpty
        ? null
        : h!.insuranceProvider;
  }

  String _formatDateForDisplay(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    final parts = isoDate.split('-');
    if (parts.length != 3) return isoDate;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    DateTime selected = DateTime(now.year - 18, now.month, now.day);
    if (_dateOfBirthController.text.isNotEmpty) {
      final parts = _dateOfBirthController.text.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]) ?? selected.day;
        final month = int.tryParse(parts[1]) ?? selected.month;
        final year = int.tryParse(parts[2]) ?? selected.year;
        selected = DateTime(year, month, day);
      }
    }
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.commonCancel),
                ),
                Text(
                  context.l10n.healthProfileDateOfBirth,
                  style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                ),
                CupertinoButton(
                  onPressed: () {
                    final day = selected.day.toString().padLeft(2, '0');
                    final month = selected.month.toString().padLeft(2, '0');
                    final year = selected.year.toString();
                    _dateOfBirthController.text = '$day/$month/$year';
                    Navigator.of(context).pop();
                  },
                  child: Text(context.l10n.commonConfirm),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selected,
                minimumDate: DateTime(1900),
                maximumDate: now,
                onDateTimeChanged: (date) => selected = date,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      imageQuality: 85,
    );
    if (xFile == null) return;
    final path = xFile.path;
    if (path.isEmpty) return;
    setState(() => _avatarFilePath = path);
  }

  Widget _buildAvatar(UserProfile? profile) {
    final name =
        '${_firstNameController.text} ${_lastNameController.text}'.trim();
    final displayName =
        name.isEmpty ? (profile?.fullName ?? '?') : name;
    if (_avatarFilePath != null && _avatarFilePath!.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: 80.r,
          height: 80.r,
          child: Image.file(
            File(_avatarFilePath!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    if (profile?.avatarUrl != null &&
        profile!.avatarUrl!.trim().isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: 80.r,
          height: 80.r,
          child: Image.network(
            profile.avatarUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                DokalAvatar(name: displayName, size: 80),
          ),
        ),
      );
    }
    return DokalAvatar(name: displayName, size: 80);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<EditProfileCubit>()..load(),
      child: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state.status == EditProfileStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? l10n.commonError)),
            );
          }
          if (state.status == EditProfileStatus.saveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.profileNameUpdatedSuccess)),
            );
            if (context.canPop()) context.pop();
          }
        },
        builder: (context, state) {
          if ((state.status == EditProfileStatus.success ||
                  state.status == EditProfileStatus.saveSuccess) &&
              state.profile != null) {
            _hydrateFromState(state);
          }
          final isLoading = state.status == EditProfileStatus.loading;
          final hasData = state.profile != null;

          return Scaffold(
            appBar: DokalAppBar(title: l10n.profileTitle),
            body: SafeArea(
              child: state.status == EditProfileStatus.loading && !hasData
                  ? Padding(
                      padding: EdgeInsets.all(AppSpacing.lg.r),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(AppSpacing.lg.r),
                      child: Form(
                        key: _formKey,
                        child: DokalCard(
                          padding: EdgeInsets.all(AppSpacing.lg.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: GestureDetector(
                                  onTap: _pickAvatar,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      _buildAvatar(state.profile),
                                      Container(
                                        padding: EdgeInsets.all(4.r),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          size: 16.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.lg.h),
                              DokalTextField(
                                controller: _firstNameController,
                                label: l10n.authFirstName,
                                hint: l10n.addRelativeFirstNameHint,
                                prefixIcon: Icons.person_outline_rounded,
                                textInputAction: TextInputAction.next,
                                validator: (v) {
                                  if ((v ?? '').trim().isEmpty) {
                                    return l10n.commonRequired;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: AppSpacing.md.h),
                              DokalTextField(
                                controller: _lastNameController,
                                label: l10n.authLastName,
                                hint: l10n.addRelativeLastNameHint,
                                prefixIcon: Icons.badge_outlined,
                                textInputAction: TextInputAction.next,
                                validator: (v) {
                                  if ((v ?? '').trim().isEmpty) {
                                    return l10n.commonRequired;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: AppSpacing.md.h),
                              DokalTextField(
                                controller: _teudatZehutController,
                                label: l10n.healthProfileTeudatZehut,
                                hint: l10n.addRelativeTeudatHint,
                                prefixIcon: Icons.credit_card_outlined,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(9),
                                ],
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty) return l10n.commonRequired;
                                  if (value.length != 9) {
                                    return l10n.profileCompletionTeudatInvalid;
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) => _selectDateOfBirth(),
                              ),
                              SizedBox(height: AppSpacing.md.h),
                              TextFormField(
                                controller: _dateOfBirthController,
                                readOnly: true,
                                onTap: _selectDateOfBirth,
                                decoration: InputDecoration(
                                  labelText: l10n.healthProfileDateOfBirth,
                                  hintText: 'DD/MM/YYYY',
                                  prefixIcon: const Icon(
                                    Icons.calendar_today_outlined,
                                  ),
                                ),
                                validator: (v) {
                                  if ((v ?? '').trim().isEmpty) {
                                    return l10n.commonRequired;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: AppSpacing.lg.h),
                              Divider(height: 1.h, color: AppColors.outline),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSpacing.sm.h,
                                ),
                                child: Text(
                                  l10n.addRelativeOptionalSection,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                key: ValueKey('kupat_$_formInitialized'),
                                initialValue: _kupatHolim.isEmpty ? null : _kupatHolim,
                                decoration: InputDecoration(
                                  labelText: l10n.healthProfileKupatHolim,
                                  prefixIcon: const Icon(
                                    Icons.local_hospital_outlined,
                                  ),
                                ),
                                items: [
                                  DropdownMenuItem<String>(
                                    value: null,
                                    child: Text(l10n.addRelativeKupatOptional),
                                  ),
                                  ...['clalit', 'maccabi', 'meuhedet', 'leumit', 'other']
                                      .map(
                                        (v) => DropdownMenuItem(
                                          value: v,
                                          child: Text(
                                            v == 'clalit'
                                                ? l10n.kupatClalit
                                                : v == 'maccabi'
                                                    ? l10n.kupatMaccabi
                                                    : v == 'meuhedet'
                                                        ? l10n.kupatMeuhedet
                                                        : v == 'leumit'
                                                            ? l10n.kupatLeumit
                                                            : l10n.kupatOther,
                                          ),
                                        ),
                                      ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _kupatHolim = v ?? ''),
                              ),
                              SizedBox(height: AppSpacing.md.h),
                              DropdownButtonFormField<String>(
                                key: ValueKey('insurance_$_formInitialized'),
                                initialValue: (_insuranceProvider == null ||
                                        _insuranceProvider!.trim().isEmpty)
                                    ? null
                                    : _insuranceProvider,
                                decoration: InputDecoration(
                                  labelText: l10n.addRelativeInsuranceLabel,
                                  prefixIcon: const Icon(
                                    Icons.health_and_safety_outlined,
                                  ),
                                ),
                                items: [
                                  DropdownMenuItem<String>(
                                    value: null,
                                    child: Text(
                                      l10n.profileCompletionInsuranceNone,
                                    ),
                                  ),
                                  ...insuranceProviders.map(
                                    (p) => DropdownMenuItem<String>(
                                      value: p,
                                      child: Text(p),
                                    ),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _insuranceProvider = v),
                              ),
                              SizedBox(height: AppSpacing.xl.h),
                              DokalButton.primary(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (!(_formKey.currentState
                                                ?.validate() ??
                                            false)) {
                                          return;
                                        }
                                        context
                                            .read<EditProfileCubit>()
                                            .save(
                                              firstName:
                                                  _firstNameController.text
                                                      .trim(),
                                              lastName:
                                                  _lastNameController.text
                                                      .trim(),
                                              teudatZehut:
                                                  _teudatZehutController.text
                                                      .trim(),
                                              dateOfBirth:
                                                  _dateOfBirthController.text
                                                      .trim(),
                                              kupatHolim: _kupatHolim.isEmpty
                                                  ? 'other'
                                                  : _kupatHolim,
                                              insuranceProvider:
                                                  _insuranceProvider,
                                              avatarFilePath: _avatarFilePath,
                                            );
                                      },
                                isLoading: isLoading,
                                child: Text(l10n.editRelativeSaveButton),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
