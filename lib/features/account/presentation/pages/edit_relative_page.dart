import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/dokal_avatar.dart';
import '../../../../core/constants/insurance_providers.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_button.dart';
import '../../../../core/widgets/dokal_card.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/relative.dart';
import '../bloc/edit_relative_cubit.dart';

class EditRelativePage extends StatefulWidget {
  const EditRelativePage({super.key, required this.relative});

  final Relative relative;

  @override
  State<EditRelativePage> createState() => _EditRelativePageState();
}

class _EditRelativePageState extends State<EditRelativePage> {
  late final Relative _relative;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _teudatZehutController;
  late final TextEditingController _dateOfBirthController;

  late String _relation;
  String? _insuranceProvider;
  late String _kupatHolim;
  String? _avatarFilePath;

  @override
  void initState() {
    super.initState();
    _relative = widget.relative;
    _firstNameController = TextEditingController(
      text: _relative.firstName ?? _relative.name.split(' ').firstOrNull ?? '',
    );
    _lastNameController = TextEditingController(
      text: _relative.lastName ??
          (_relative.name.split(' ').length > 1
              ? _relative.name.split(' ').sublist(1).join(' ')
              : ''),
    );
    _teudatZehutController = TextEditingController(
      text: _relative.teudatZehut ?? '',
    );
    _dateOfBirthController = TextEditingController(
      text: _formatDateForDisplay(_relative.dateOfBirth),
    );
    _relation = _relative.relation ?? 'child';
    _insuranceProvider = _relative.insuranceProvider;
    _kupatHolim = _relative.kupatHolim ?? '';
  }

  String _formatDateForDisplay(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    final parts = isoDate.split('-');
    if (parts.length != 3) return isoDate;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _teudatZehutController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
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

  Future<void> _confirmDelete() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editRelativeDeleteTitle),
        content: Text(l10n.editRelativeDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text(l10n.editRelativeDeleteConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<EditRelativeCubit>().deleteRelative(_relative.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => sl<EditRelativeCubit>(),
      child: BlocConsumer<EditRelativeCubit, EditRelativeState>(
        listener: (context, state) {
          if (state.status == EditRelativeStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? l10n.commonError)),
            );
          }
          if (state.status == EditRelativeStatus.updateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.editRelativeUpdateSuccess)),
            );
            if (context.canPop()) context.pop();
          }
          if (state.status == EditRelativeStatus.deleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.editRelativeDeleteSuccess)),
            );
            if (context.canPop()) context.pop();
          }
        },
        builder: (context, state) {
          final isLoading = state.status == EditRelativeStatus.loading;
          return Scaffold(
            appBar: DokalAppBar(title: l10n.editRelativeTitle),
            body: SafeArea(
              child: SingleChildScrollView(
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
                                _buildAvatar(),
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
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return l10n.commonRequired;
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
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return l10n.commonRequired;
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
                            prefixIcon: const Icon(Icons.calendar_today_outlined),
                          ),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return l10n.commonRequired;
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        DropdownButtonFormField<String>(
                          initialValue: _relation,
                          decoration: InputDecoration(
                            labelText: l10n.relativeRelation,
                            prefixIcon: const Icon(Icons.family_restroom_rounded),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'child',
                              child: Text(l10n.relativeChild),
                            ),
                            DropdownMenuItem(
                              value: 'parent',
                              child: Text(l10n.relativeParent),
                            ),
                            DropdownMenuItem(
                              value: 'spouse',
                              child: Text(l10n.relativeSpouse),
                            ),
                            DropdownMenuItem(
                              value: 'sibling',
                              child: Text(l10n.relativeSibling),
                            ),
                            DropdownMenuItem(
                              value: 'other',
                              child: Text(l10n.relativeOther),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => _relation = v ?? 'child'),
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        Divider(height: 1.h, color: AppColors.outline),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
                          child: Text(
                            l10n.addRelativeOptionalSection,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          initialValue: _kupatHolim.isEmpty ? null : _kupatHolim,
                          decoration: InputDecoration(
                            labelText: l10n.healthProfileKupatHolim,
                            prefixIcon: const Icon(Icons.local_hospital_outlined),
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
                              child: Text(l10n.profileCompletionInsuranceNone),
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
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                                  context.read<EditRelativeCubit>().updateRelative(
                                        id: _relative.id,
                                        firstName: _firstNameController.text.trim(),
                                        lastName: _lastNameController.text.trim(),
                                        teudatZehut: _teudatZehutController.text.trim(),
                                        dateOfBirth: _dateOfBirthController.text.trim(),
                                        relation: _relation,
                                        kupatHolim: _kupatHolim.isEmpty
                                            ? null
                                            : _kupatHolim,
                                        insuranceProvider: _insuranceProvider,
                                        avatarFilePath: _avatarFilePath,
                                      );
                                },
                          isLoading: isLoading,
                          child: Text(l10n.editRelativeSaveButton),
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        OutlinedButton(
                          onPressed: isLoading ? null : _confirmDelete,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: BorderSide(color: AppColors.error),
                          ),
                          child: Text(l10n.editRelativeDeleteButton),
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

  Widget _buildAvatar() {
    final name = '${_firstNameController.text} ${_lastNameController.text}'.trim();
    final displayName = name.isEmpty ? _relative.name : name;
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
    if (_relative.avatarUrl != null && _relative.avatarUrl!.trim().isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: 80.r,
          height: 80.r,
          child: Image.network(
            _relative.avatarUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                DokalAvatar(name: displayName, size: 80),
          ),
        ),
      );
    }
    return DokalAvatar(name: displayName, size: 80);
  }
}
