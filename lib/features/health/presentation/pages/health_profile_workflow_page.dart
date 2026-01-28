import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/dokal_app_bar.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/health_profile.dart';
import '../bloc/health_profile_cubit.dart';

class HealthProfileWorkflowPage extends StatelessWidget {
  const HealthProfileWorkflowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HealthProfileCubit>()..load(),
      child: const _HealthProfileWorkflowView(),
    );
  }
}

class _HealthProfileWorkflowView extends StatefulWidget {
  const _HealthProfileWorkflowView();

  @override
  State<_HealthProfileWorkflowView> createState() =>
      _HealthProfileWorkflowViewState();
}

class _HealthProfileWorkflowViewState
    extends State<_HealthProfileWorkflowView> {
  int _step = 0;
  bool _hydrated = false;

  final _fullName = TextEditingController();
  final _teudatZehut = TextEditingController();
  final _dob = TextEditingController();
  String _sex = 'other';

  String _kupatHolim = 'clalit';
  final _kupatMemberId = TextEditingController();
  final _familyDoctor = TextEditingController();

  String _bloodType = '';
  final _allergies = TextEditingController();
  final _conditions = TextEditingController();
  final _medications = TextEditingController();

  final _emergencyName = TextEditingController();
  final _emergencyPhone = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _teudatZehut.dispose();
    _dob.dispose();
    _kupatMemberId.dispose();
    _familyDoctor.dispose();
    _allergies.dispose();
    _conditions.dispose();
    _medications.dispose();
    _emergencyName.dispose();
    _emergencyPhone.dispose();
    super.dispose();
  }

  void _hydrateFromProfile(HealthProfile p) {
    _fullName.text = p.fullName;
    _teudatZehut.text = p.teudatZehut;
    _dob.text = p.dateOfBirth;
    _sex = p.sex.isEmpty ? 'other' : p.sex;
    _kupatHolim = p.kupatHolim.isEmpty ? 'clalit' : p.kupatHolim;
    _kupatMemberId.text = p.kupatMemberId;
    _familyDoctor.text = p.familyDoctorName;
    _bloodType = p.bloodType;
    _allergies.text = p.allergies;
    _conditions.text = p.medicalConditions;
    _medications.text = p.medications;
    _emergencyName.text = p.emergencyContactName;
    _emergencyPhone.text = p.emergencyContactPhone;
  }

  HealthProfile _buildProfile() {
    return HealthProfile(
      fullName: _fullName.text.trim(),
      teudatZehut: _teudatZehut.text.trim(),
      dateOfBirth: _dob.text.trim(),
      sex: _sex,
      kupatHolim: _kupatHolim,
      kupatMemberId: _kupatMemberId.text.trim(),
      familyDoctorName: _familyDoctor.text.trim(),
      bloodType: _bloodType,
      allergies: _allergies.text.trim(),
      medicalConditions: _conditions.text.trim(),
      medications: _medications.text.trim(),
      emergencyContactName: _emergencyName.text.trim(),
      emergencyContactPhone: _emergencyPhone.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<HealthProfileCubit, HealthProfileState>(
      listenWhen: (p, n) => p.justSaved != n.justSaved || p.status != n.status,
      listener: (context, state) {
        if (state.justSaved) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.healthProfileSavedSnack)));
          context.read<HealthProfileCubit>().clearJustSavedFlag();
        }
      },
      builder: (context, state) {
        if (state.status == HealthProfileStatus.loading) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: const DokalAppBar(title: '—'),
            body: Padding(
              padding: EdgeInsets.all(AppSpacing.lg.r),
              child: const DokalLoader(lines: 7),
            ),
          );
        }

        if (state.status == HealthProfileStatus.failure) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: DokalAppBar(title: l10n.healthProfileTitle),
            body: DokalEmptyState(
              title: l10n.commonUnableToLoad,
              subtitle: state.error ?? l10n.commonTryAgainLater,
              icon: Icons.error_outline_rounded,
            ),
          );
        }

        final existing = state.profile;
        if (!_hydrated && existing != null) {
          _hydrateFromProfile(existing);
          _hydrated = true;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: DokalAppBar(
            title: l10n.healthProfileTitle,
            subtitle: l10n.healthProfileSubtitle,
          ),
          body: Stepper(
            currentStep: _step,
            onStepCancel: () {
              if (_step > 0) {
                setState(() => _step -= 1);
              } else {
                Navigator.of(context).maybePop();
              }
            },
            onStepContinue: () {
              if (_step < 3) {
                setState(() => _step += 1);
              } else {
                context.read<HealthProfileCubit>().save(_buildProfile());
              }
            },
            controlsBuilder: (context, details) {
              final isLast = _step == 3;
              return Padding(
                padding: EdgeInsets.only(top: AppSpacing.md.h),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                      ),
                      child: Text(
                        isLast ? l10n.healthProfileSave : l10n.commonContinue,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: Text(l10n.commonBack),
                    ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: Text(l10n.healthProfileStepIdentity),
                isActive: _step >= 0,
                content: Column(
                  children: [
                    Text(
                      l10n.healthProfileIntro,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    TextField(
                      controller: _fullName,
                      decoration: InputDecoration(
                        labelText: l10n.commonName,
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    TextField(
                      controller: _teudatZehut,
                      decoration: InputDecoration(
                        labelText: l10n.healthProfileTeudatZehut,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    TextField(
                      controller: _dob,
                      decoration: InputDecoration(
                        labelText: l10n.healthProfileDateOfBirth,
                        hintText: 'DD/MM/YYYY',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    DropdownButtonFormField<String>(
                      key: ValueKey(_sex),
                      initialValue: _sex,
                      decoration: InputDecoration(
                        labelText: l10n.healthProfileSex,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'female',
                          child: Text(l10n.healthProfileSexFemale),
                        ),
                        DropdownMenuItem(
                          value: 'male',
                          child: Text(l10n.healthProfileSexMale),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text(l10n.healthProfileSexOther),
                        ),
                      ],
                      onChanged: (v) => setState(() => _sex = v ?? 'other'),
                    ),
                  ],
                ),
              ),
              Step(
                title: Text(l10n.healthProfileStepKupatHolim),
                isActive: _step >= 1,
                content: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        l10n.healthProfileKupatHolim,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    DropdownButtonFormField<String>(
                      key: ValueKey(_kupatHolim),
                      initialValue: _kupatHolim,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'clalit',
                          child: Text(l10n.kupatClalit),
                        ),
                        DropdownMenuItem(
                          value: 'maccabi',
                          child: Text(l10n.kupatMaccabi),
                        ),
                        DropdownMenuItem(
                          value: 'meuhedet',
                          child: Text(l10n.kupatMeuhedet),
                        ),
                        DropdownMenuItem(
                          value: 'leumit',
                          child: Text(l10n.kupatLeumit),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text(l10n.kupatOther),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => _kupatHolim = v ?? 'clalit'),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    TextField(
                      controller: _kupatMemberId,
                      decoration: InputDecoration(
                        labelText: l10n.healthProfileKupatMemberId,
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    TextField(
                      controller: _familyDoctor,
                      decoration: InputDecoration(
                        labelText: l10n.healthProfileFamilyDoctor,
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
              Step(
                title: Text(l10n.healthProfileStepMedical),
                isActive: _step >= 2,
                content: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      key: ValueKey<String?>(
                        _bloodType.isEmpty ? null : _bloodType,
                      ),
                      initialValue: _bloodType.isEmpty ? null : _bloodType,
                      decoration: InputDecoration(
                        labelText: l10n.profileBloodType,
                        border: const OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'A+', child: Text('A+')),
                        DropdownMenuItem(value: 'A-', child: Text('A-')),
                        DropdownMenuItem(value: 'B+', child: Text('B+')),
                        DropdownMenuItem(value: 'B-', child: Text('B-')),
                        DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                        DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                        DropdownMenuItem(value: 'O+', child: Text('O+')),
                        DropdownMenuItem(value: 'O-', child: Text('O-')),
                      ],
                      onChanged: (v) => setState(() => _bloodType = v ?? ''),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    TextField(
                      controller: _allergies,
                      decoration: InputDecoration(
                        labelText: l10n.healthAllergiesTitle,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    TextField(
                      controller: _conditions,
                      decoration: InputDecoration(
                        labelText: l10n.healthConditionsTitle,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    TextField(
                      controller: _medications,
                      decoration: InputDecoration(
                        labelText: l10n.healthMedicationsTitle,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Step(
                title: Text(l10n.healthProfileStepEmergency),
                isActive: _step >= 3,
                content: Column(
                  children: [
                    TextField(
                      controller: _emergencyName,
                      decoration: InputDecoration(
                        labelText: l10n.healthProfileEmergencyContactName,
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    TextField(
                      controller: _emergencyPhone,
                      decoration: InputDecoration(
                        labelText: l10n.healthProfileEmergencyContactPhone,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
