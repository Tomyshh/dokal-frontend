import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/profile_completion/profile_completion_notifier.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../bloc/profile_completion_cubit.dart';

class CompletePatientProfileWizardPage extends StatelessWidget {
  const CompletePatientProfileWizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCompletionCubit(
        getProfile: sl(),
        getHealthProfile: sl(),
        updateProfile: sl(),
        saveHealthProfile: sl(),
        prefs: sl(),
      )..load(),
      child: const _WizardView(),
    );
  }
}

class _WizardView extends StatefulWidget {
  const _WizardView();

  @override
  State<_WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<_WizardView> {
  final _pageController = PageController();
  int _step = 0;
  bool _hydrated = false;

  final _identityFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();
  final _israelFormKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _dateOfBirth = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _teudatZehut = TextEditingController();

  String _kupatHolim = 'clalit';
  String? _insuranceProvider;

  @override
  void dispose() {
    _pageController.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _dateOfBirth.dispose();
    _email.dispose();
    _phone.dispose();
    _teudatZehut.dispose();
    super.dispose();
  }

  void _hydrate(ProfileCompletionState state) {
    if (_hydrated) return;
    final p = state.profile;
    final h = state.healthProfile;
    if (p == null) return;

    _firstName.text = (p.firstName ?? '').trim();
    _lastName.text = (p.lastName ?? '').trim();
    _phone.text = (p.phone ?? '').trim();
    final authEmail = Supabase.instance.client.auth.currentUser?.email;
    _email.text = ((p.email).trim().isNotEmpty ? p.email : (authEmail ?? ''))
        .trim();
    _dateOfBirth.text = _normalizeIsoDate((p.dateOfBirth ?? '').trim());

    _teudatZehut.text = (h?.teudatZehut ?? '').trim();
    _kupatHolim = (h?.kupatHolim ?? '').trim().isEmpty
        ? 'clalit'
        : (h?.kupatHolim ?? 'clalit').trim();

    _insuranceProvider = state.insuranceProvider;

    _hydrated = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_step > 0) {
          _prev();
        }
      },
      child: BlocConsumer<ProfileCompletionCubit, ProfileCompletionState>(
        listenWhen: (p, n) => p.status != n.status,
        listener: (context, state) async {
          if (state.status == ProfileCompletionStatus.success) {
            final target = GoRouterState.of(
              context,
            ).uri.queryParameters['redirect'];
            await sl<ProfileCompletionNotifier>().refresh();
            if (!context.mounted) return;
            context.read<ProfileCompletionCubit>().clearSuccess();
            context.go(target ?? '/home');
          }
          if (state.status == ProfileCompletionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? l10n.commonError)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileCompletionStatus.loading ||
              state.status == ProfileCompletionStatus.initial) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg.r),
                  child: const DokalLoader(lines: 7),
                ),
              ),
            );
          }

          if (state.status == ProfileCompletionStatus.failure) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: DokalEmptyState(
                  title: l10n.commonUnableToLoad,
                  subtitle: state.error ?? l10n.commonTryAgainLater,
                  icon: Icons.error_outline_rounded,
                  action: ElevatedButton(
                    onPressed: () =>
                        context.read<ProfileCompletionCubit>().load(),
                    child: Text(l10n.commonTryAgain),
                  ),
                ),
              ),
            );
          }

          _hydrate(state);

          final totalSteps = 4;
          final progress = (_step + 1) / totalSteps;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  _WizardHeader(
                    title: l10n.profileCompletionTitle,
                    subtitle: l10n.profileCompletionSubtitle,
                    stepLabel: l10n.profileCompletionStepLabel(
                      _step + 1,
                      totalSteps,
                    ),
                    progress: progress,
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _IdentityStep(
                          formKey: _identityFormKey,
                          firstName: _firstName,
                          lastName: _lastName,
                          dateOfBirth: _dateOfBirth,
                          onPickDob: _pickDob,
                        ),
                        _ContactStep(
                          formKey: _contactFormKey,
                          email: _email,
                          phone: _phone,
                        ),
                        _IsraelStep(
                          formKey: _israelFormKey,
                          teudatZehut: _teudatZehut,
                          kupatHolim: _kupatHolim,
                          onKupatChanged: (v) =>
                              setState(() => _kupatHolim = v),
                        ),
                        _InsuranceStep(
                          selected: _insuranceProvider,
                          onChanged: (v) =>
                              setState(() => _insuranceProvider = v),
                        ),
                      ],
                    ),
                  ),
                  _WizardFooter(
                    backLabel: l10n.commonBack,
                    nextLabel: _step == totalSteps - 1
                        ? l10n.profileCompletionFinish
                        : l10n.commonContinue,
                    isSaving: state.status == ProfileCompletionStatus.saving,
                    canGoBack: _step > 0,
                    onBack: _step > 0 ? _prev : null,
                    onNext: () => _nextOrSubmit(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _prev() {
    if (_step <= 0) return;
    setState(() => _step -= 1);
    _pageController.previousPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _nextOrSubmit(BuildContext context) async {
    final isLast = _step == 3;

    final valid = switch (_step) {
      0 => _identityFormKey.currentState?.validate() ?? false,
      1 => _contactFormKey.currentState?.validate() ?? false,
      2 => _israelFormKey.currentState?.validate() ?? false,
      _ => true,
    };
    if (!valid) return;

    if (!isLast) {
      setState(() => _step += 1);
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    final dobIso = _normalizeIsoDate(_dateOfBirth.text.trim());
    context.read<ProfileCompletionCubit>().saveRequiredInfo(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      phone: _phone.text.trim(),
      dateOfBirthIso: dobIso,
      teudatZehut: _digitsOnly(_teudatZehut.text),
      kupatHolim: _kupatHolim.trim(),
      insuranceProvider: _insuranceProvider,
    );
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial =
        _tryParseIsoDate(_dateOfBirth.text) ??
        DateTime(now.year - 30, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
    );
    if (picked == null) return;
    setState(() => _dateOfBirth.text = _formatIsoDate(picked));
  }
}

class _WizardHeader extends StatelessWidget {
  const _WizardHeader({
    required this.title,
    required this.subtitle,
    required this.stepLabel,
    required this.progress,
  });

  final String title;
  final String subtitle;
  final String stepLabel;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.md.h,
        AppSpacing.lg.w,
        AppSpacing.md.h,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8.h,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  stepLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WizardFooter extends StatelessWidget {
  const _WizardFooter({
    required this.backLabel,
    required this.nextLabel,
    required this.isSaving,
    required this.canGoBack,
    required this.onBack,
    required this.onNext,
  });

  final String backLabel;
  final String nextLabel;
  final bool isSaving;
  final bool canGoBack;
  final VoidCallback? onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.sm.h,
        AppSpacing.lg.w,
        AppSpacing.lg.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: canGoBack ? onBack : null,
              child: Text(backLabel),
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isSaving ? null : onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: isSaving
                  ? SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(nextLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: AppSpacing.lg.h),
        child,
        SizedBox(height: 24.h),
      ],
    );
  }
}

class _IdentityStep extends StatelessWidget {
  const _IdentityStep({
    required this.formKey,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.onPickDob,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController dateOfBirth;
  final VoidCallback onPickDob;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _StepCard(
      title: l10n.profileCompletionStepIdentityTitle,
      subtitle: l10n.profileCompletionStepIdentitySubtitle,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DokalTextField(
                    controller: firstName,
                    label: l10n.authFirstName,
                    prefixIcon: Icons.person_rounded,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? l10n.commonRequired : null,
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: DokalTextField(
                    controller: lastName,
                    label: l10n.authLastName,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? l10n.commonRequired : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
            TextFormField(
              controller: dateOfBirth,
              readOnly: true,
              onTap: onPickDob,
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? l10n.commonRequired : null,
              decoration: InputDecoration(
                labelText: l10n.profileCompletionDateOfBirth,
                hintText: 'YYYY-MM-DD',
                prefixIcon: const Icon(Icons.cake_rounded),
                suffixIcon: const Icon(Icons.calendar_today_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactStep extends StatelessWidget {
  const _ContactStep({
    required this.formKey,
    required this.email,
    required this.phone,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final TextEditingController phone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _StepCard(
      title: l10n.profileCompletionStepContactTitle,
      subtitle: l10n.profileCompletionStepContactSubtitle,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: email,
              enabled: false,
              decoration: InputDecoration(
                labelText: l10n.commonEmail,
                prefixIcon: const Icon(Icons.mail_rounded),
                helperText: l10n.profileCompletionEmailLockedHint,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            DokalTextField(
              controller: phone,
              label: l10n.profileCompletionPhone,
              hint: l10n.profileCompletionPhoneHint,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_rounded,
              textInputAction: TextInputAction.done,
              validator: (v) {
                final raw = (v ?? '').trim();
                if (raw.isEmpty) return l10n.commonRequired;
                if (_digitsOnly(raw).length < 7) {
                  return l10n.profileCompletionPhoneInvalid;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _IsraelStep extends StatelessWidget {
  const _IsraelStep({
    required this.formKey,
    required this.teudatZehut,
    required this.kupatHolim,
    required this.onKupatChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController teudatZehut;
  final String kupatHolim;
  final ValueChanged<String> onKupatChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _StepCard(
      title: l10n.profileCompletionStepIsraelTitle,
      subtitle: l10n.profileCompletionStepIsraelSubtitle,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            DokalTextField(
              controller: teudatZehut,
              label: l10n.healthProfileTeudatZehut,
              hint: l10n.profileCompletionTeudatHint,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.badge_rounded,
              validator: (v) {
                final digits = _digitsOnly(v ?? '');
                if (digits.isEmpty) return l10n.commonRequired;
                if (digits.length != 9) {
                  return l10n.profileCompletionTeudatInvalid;
                }
                if (!_isValidIsraeliId(digits)) {
                  return l10n.profileCompletionTeudatInvalid;
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.md.h),
            DropdownButtonFormField<String>(
              initialValue: kupatHolim,
              decoration: InputDecoration(
                labelText: l10n.healthProfileKupatHolim,
                prefixIcon: const Icon(Icons.local_hospital_rounded),
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
                DropdownMenuItem(value: 'other', child: Text(l10n.kupatOther)),
              ],
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? l10n.commonRequired : null,
              onChanged: (v) => onKupatChanged(v ?? 'clalit'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsuranceStep extends StatelessWidget {
  const _InsuranceStep({required this.selected, required this.onChanged});

  final String? selected;
  final ValueChanged<String?> onChanged;

  static const _providers = <String>[
    'AIG',
    'איילון',
    'ביטוח חקלאי',
    'דקלה',
    'הראל',
    'הכשרה',
    'הפניקס',
    'כלל',
    'מגדל',
    'מנורה',
    'ביטוח ישיר',
    'שירביט',
    'שלמה',
    'שומרה',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _StepCard(
      title: l10n.profileCompletionStepInsuranceTitle,
      subtitle: l10n.profileCompletionStepInsuranceSubtitle,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: (selected == null || selected!.trim().isEmpty)
                ? null
                : selected,
            decoration: InputDecoration(
              labelText: l10n.profileCompletionInsurance,
              prefixIcon: const Icon(Icons.verified_user_rounded),
            ),
            items: [
              DropdownMenuItem<String>(
                value: '',
                child: Text(l10n.profileCompletionInsuranceNone),
              ),
              ..._providers.map(
                (p) => DropdownMenuItem<String>(value: p, child: Text(p)),
              ),
            ],
            onChanged: (v) => onChanged((v ?? '').isEmpty ? null : v),
          ),
          SizedBox(height: AppSpacing.md.h),
          Container(
            padding: EdgeInsets.all(AppSpacing.md.r),
            decoration: BoxDecoration(
              color: AppColors.primaryLightBackground,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    l10n.profileCompletionInsuranceOptionalHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _digitsOnly(String input) => input.replaceAll(RegExp(r'[^0-9]'), '');

String _normalizeIsoDate(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return '';
  final d = _tryParseIsoDate(trimmed);
  return d == null ? trimmed : _formatIsoDate(d);
}

DateTime? _tryParseIsoDate(String input) {
  final trimmed = input.trim();
  if (trimmed.length < 10) return null;
  final parts = trimmed.substring(0, 10).split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  try {
    return DateTime(y, m, d);
  } catch (_) {
    return null;
  }
}

String _formatIsoDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

bool _isValidIsraeliId(String digits) {
  var id = _digitsOnly(digits);
  if (id.isEmpty) return false;
  id = id.padLeft(9, '0');
  if (id.length != 9) return false;

  var sum = 0;
  for (var i = 0; i < 9; i++) {
    var digit = int.tryParse(id[i]) ?? 0;
    final step = (i % 2) + 1;
    digit *= step;
    if (digit > 9) digit -= 9;
    sum += digit;
  }
  return sum % 10 == 0;
}
