import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/insurance_providers.dart';
import '../../../../core/widgets/dokal_avatar.dart';
import '../../../../core/profile_completion/profile_completion_notifier.dart';
import '../../../../core/widgets/dokal_empty_state.dart';
import '../../../../core/widgets/dokal_loader.dart';
import '../../../../core/widgets/dokal_text_field.dart';
import '../../../../core/widgets/address_autocomplete_field.dart';
import '../../../../core/services/google_places_service.dart';
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
        uploadAvatar: sl(),
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
  final _address = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _teudatZehut = TextEditingController();

  String _fullPhone = '';
  String _kupatHolim = 'clalit';
  String? _insuranceProvider;
  String _sex = 'other';
  String? _avatarFilePath;
  String? _avatarUrlFromProfile;
  String _addressLine = '';
  String _zipCode = '';
  String _city = '';

  @override
  void dispose() {
    _pageController.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _dateOfBirth.dispose();
    _address.dispose();
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

    // Récupère les métadonnées OAuth (Google/Apple) pour pré-remplir
    final authUser = Supabase.instance.client.auth.currentUser;
    final authMeta = authUser?.userMetadata ?? const <String, dynamic>{};
    final authFirstName = (authMeta['first_name'] as String? ?? '').trim();
    final authLastName = (authMeta['last_name'] as String? ?? '').trim();
    final authEmail = authUser?.email;

    _firstName.text = (p.firstName ?? '').trim().isNotEmpty
        ? (p.firstName ?? '').trim()
        : authFirstName;
    _lastName.text = (p.lastName ?? '').trim().isNotEmpty
        ? (p.lastName ?? '').trim()
        : authLastName;
    final cityVal = p.city.trim();
    _city = cityVal;
    _address.text = cityVal;
    _sex = _normalizeSex(p.sex);
    _avatarUrlFromProfile = p.avatarUrl;
    _phone.text = (p.phone ?? '').trim();
    _email.text = ((p.email).trim().isNotEmpty ? p.email : (authEmail ?? ''))
        .trim();
    _dateOfBirth.text = _formatDisplayDate((p.dateOfBirth ?? '').trim());

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
            final notifier = sl<ProfileCompletionNotifier>();
            await notifier.refresh();
            if (!context.mounted) return;
            if (notifier.needsCompletion) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.commonTryAgainLater)),
              );
              return;
            }
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
              top: false,
              bottom: true,
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
                          address: _address,
                          addressLine: _addressLine,
                          zipCode: _zipCode,
                          city: _city,
                          onAddressSelected: (details) {
                            setState(() {
                              _addressLine = details.addressLine;
                              _zipCode = details.zipCode;
                              _city = details.city;
                            });
                          },
                          sex: _sex,
                          onSexChanged: (v) => setState(() => _sex = v),
                          avatarUrl: _avatarFilePath != null
                              ? null
                              : _avatarUrlFromProfile,
                          avatarFilePath: _avatarFilePath,
                          onPickAvatar: _onPickAvatarPressed,
                          onPickDob: _pickDob,
                        ),
                        _ContactStep(
                          formKey: _contactFormKey,
                          email: _email,
                          phone: _phone,
                          onPhoneChanged: (p) =>
                              _fullPhone = p.completeNumber,
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

    final dobIso = _displayToIso(_dateOfBirth.text.trim());
    final cityVal = _city.trim().isNotEmpty ? _city.trim() : _address.text.trim();
    context.read<ProfileCompletionCubit>().saveRequiredInfo(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      phone: _fullPhone.isNotEmpty ? _fullPhone : _phone.text.trim(),
      dateOfBirthIso: dobIso,
      teudatZehut: _digitsOnly(_teudatZehut.text),
      kupatHolim: _kupatHolim.trim(),
      insuranceProvider: _insuranceProvider,
      city: cityVal.isEmpty ? null : cityVal,
      addressLine: _addressLine.trim().isEmpty ? null : _addressLine.trim(),
      zipCode: _zipCode.trim().isEmpty ? null : _zipCode.trim(),
      sex: _sex,
      avatarFilePath: _avatarFilePath,
    );
  }

  Future<void> _onPickAvatarPressed() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final l10n = sheetContext.l10n;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_rounded),
                title: Text(l10n.avatarPickTakePhoto),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(l10n.avatarPickChooseFromGallery),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.close_rounded),
                title: Text(l10n.commonCancel),
                onTap: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        );
      },
    );
    if (source == null) return;
    await _pickAvatar(source);
  }

  Future<void> _pickAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      imageQuality: 85,
    );
    if (xFile == null) return;
    final path = xFile.path;
    if (path.isEmpty) return;
    setState(() {
      _avatarFilePath = path;
      _avatarUrlFromProfile = null;
    });
  }

  static String _normalizeSex(String? value) {
    final v = (value ?? '').trim().toLowerCase();
    if (v == 'male' || v == 'female' || v == 'other') return v;
    return 'other';
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial =
        _tryParseDate(_dateOfBirth.text) ??
        DateTime(now.year - 30, now.month, now.day);
    final picked = await _showCupertinoDatePicker(
      context: context,
      initialDate: initial,
      minimumDate: DateTime(1900, 1, 1),
      maximumDate: now,
    );
    if (picked == null) return;
    setState(() => _dateOfBirth.text = _formatDisplayDate(_formatIsoDate(picked)));
  }

  static Future<DateTime?> _showCupertinoDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime minimumDate,
    required DateTime maximumDate,
  }) async {
    final l10n = context.l10n;
    DateTime selected = initialDate;
    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CupertinoTheme(
        data: CupertinoThemeData(
          primaryColor: AppColors.primary,
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColors.surface,
        ),
        child: Container(
          height: 280.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            boxShadow: AppShadows.sm,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg.w,
                  vertical: AppSpacing.sm.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    bottom: BorderSide(color: AppColors.outline),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        l10n.commonCancel,
                        style: AppTextStyles.titleSm(color: AppColors.textSecondary),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(selected),
                      child: Text(
                        l10n.commonContinue,
                        style: AppTextStyles.titleSm(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  onDateTimeChanged: (DateTime value) => selected = value,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
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
    final topSafe = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        topSafe + AppSpacing.md.h,
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
            style: AppTextStyles.headingSm(color: AppColors.textOnPrimary),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: AppTextStyles.bodyMd(color: AppColors.textOnPrimary),
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(999.r),
                      child: SizedBox(
                        height: 8.h,
                        child: Stack(
                          children: [
                            Container(
                              width: w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius:
                                    BorderRadius.circular(999.r),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              width: w * progress.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(999.r),
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFB8860B), // dark goldenrod
                                      Color(0xFFD4AF37), // gold
                                      Color(0xFFF4E4BC), // light gold
                                      Color(0xFFD4AF37), // gold
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
                    width: 1.r,
                  ),
                ),
                child: Text(
                  stepLabel,
                  style: AppTextStyles.labelMd(color: AppColors.textOnPrimary),
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
        color: AppColors.surface,
        boxShadow: AppShadows.sm,
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
                foregroundColor: AppColors.textOnPrimary,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: isSaving
                  ? SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textOnPrimary,
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
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.all(AppSpacing.lg.r),
      children: [
        Text(
          title,
          style: AppTextStyles.titleLg(),
        ),
        SizedBox(height: 6.h),
        Text(
          subtitle,
          style: AppTextStyles.bodyMd(color: AppColors.textSecondary),
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
    required this.address,
    required this.addressLine,
    required this.zipCode,
    required this.city,
    required this.onAddressSelected,
    required this.sex,
    required this.onSexChanged,
    required this.avatarUrl,
    required this.avatarFilePath,
    required this.onPickAvatar,
    required this.onPickDob,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController dateOfBirth;
  final TextEditingController address;
  final String addressLine;
  final String zipCode;
  final String city;
  final void Function(PlaceDetails details) onAddressSelected;
  final String sex;
  final ValueChanged<String> onSexChanged;
  final String? avatarUrl;
  final String? avatarFilePath;
  final VoidCallback onPickAvatar;
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
            Center(
              child: GestureDetector(
                onTap: onPickAvatar,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    _buildAvatar(),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: 2.r,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 18.r,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              l10n.profileCompletionAvatar,
              style: AppTextStyles.bodySm(color: AppColors.textSecondary),
            ),
            SizedBox(height: AppSpacing.lg.h),
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
                hintText: context.l10n.commonDateHintDdMmYyyy,
                prefixIcon: const Icon(Icons.cake_rounded),
                suffixIcon: const Icon(Icons.calendar_today_rounded),
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            AddressAutocompleteField(
              controller: address,
              placesService: sl<GooglePlacesService>(),
              label: l10n.profileCompletionAddress,
              hint: l10n.profileCompletionAddressHint,
              onPlaceSelected: onAddressSelected,
            ),
            SizedBox(height: AppSpacing.md.h),
            DropdownButtonFormField<String>(
              key: ValueKey<String?>(sex),
              initialValue: sex,
              decoration: InputDecoration(
                labelText: l10n.profileCompletionSex,
                prefixIcon: const Icon(Icons.wc_rounded),
              ),
              items: [
                DropdownMenuItem(
                  value: 'male',
                  child: Text(l10n.profileCompletionSexMale),
                ),
                DropdownMenuItem(
                  value: 'female',
                  child: Text(l10n.profileCompletionSexFemale),
                ),
                DropdownMenuItem(
                  value: 'other',
                  child: Text(l10n.profileCompletionSexOther),
                ),
              ],
              onChanged: (v) => onSexChanged(v ?? 'other'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final displayPath = avatarFilePath;
    final displayUrl = avatarUrl;
    final name = '${firstName.text} ${lastName.text}'.trim();
    if (displayPath != null && displayPath.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: 96.r,
          height: 96.r,
          child: Image.file(
            File(displayPath),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    if (displayUrl != null && displayUrl.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: 96.r,
          height: 96.r,
          child: Image.network(
            displayUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => DokalAvatar(
              name: name.isEmpty ? '?' : name,
              size: 96,
            ),
          ),
        ),
      );
    }
    return DokalAvatar(
      name: name.isEmpty ? '?' : name,
      size: 96,
    );
  }
}

class _ContactStep extends StatelessWidget {
  const _ContactStep({
    required this.formKey,
    required this.email,
    required this.phone,
    required this.onPhoneChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final TextEditingController phone;
  final ValueChanged<PhoneNumber> onPhoneChanged;

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
            IntlPhoneField(
              controller: phone,
              initialCountryCode: 'IL',
              languageCode: Localizations.localeOf(context).languageCode,
              disableLengthCheck: true,
              decoration: InputDecoration(
                labelText: l10n.profileCompletionPhone,
                hintText: l10n.profileCompletionPhoneHint,
                counterText: '',
              ),
              dropdownTextStyle: AppTextStyles.bodyMd(),
              style: AppTextStyles.bodyMd(),
              flagsButtonPadding: EdgeInsets.only(left: 12.w),
              dropdownIconPosition: IconPosition.trailing,
              dropdownIcon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.textSecondary,
              ),
              validator: (v) {
                final raw = (v?.number ?? '').trim();
                if (raw.isEmpty) return l10n.commonRequired;
                if (_digitsOnly(raw).length < 7) {
                  return l10n.profileCompletionPhoneInvalid;
                }
                return null;
              },
              onChanged: onPhoneChanged,
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
              ...insuranceProviders.map(
                (p) => DropdownMenuItem<String>(
                  value: p,
                  child: Text(insuranceDisplayName(context, p)),
                ),
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
                width: 1.r,
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
                    style: AppTextStyles.bodySm(color: AppColors.textSecondary),
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

/// Parses ISO (YYYY-MM-DD) or display (DD/MM/YYYY) into a DateTime.
DateTime? _tryParseDate(String input) {
  final trimmed = input.trim();
  if (trimmed.length < 10) return null;

  // Try DD/MM/YYYY
  if (trimmed.contains('/')) {
    final parts = trimmed.substring(0, 10).split('/');
    if (parts.length == 3) {
      final d = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final y = int.tryParse(parts[2]);
      if (y != null && m != null && d != null) {
        try {
          return DateTime(y, m, d);
        } catch (_) {}
      }
    }
  }

  // Try YYYY-MM-DD
  final parts = trimmed.substring(0, 10).split('-');
  if (parts.length == 3) {
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y != null && m != null && d != null) {
      try {
        return DateTime(y, m, d);
      } catch (_) {}
    }
  }
  return null;
}

/// Formats a DateTime as ISO YYYY-MM-DD (for API).
String _formatIsoDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Converts any date string (ISO or display) to DD/MM/YYYY for the text field.
String _formatDisplayDate(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return '';
  final dt = _tryParseDate(trimmed);
  if (dt == null) return trimmed;
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final y = dt.year.toString().padLeft(4, '0');
  return '$d/$m/$y';
}

/// Converts any date string (ISO or display) to ISO YYYY-MM-DD for the API.
String _displayToIso(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return '';
  final dt = _tryParseDate(trimmed);
  return dt == null ? trimmed : _formatIsoDate(dt);
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
