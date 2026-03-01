import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';
import '../../data/datasources/practitioner_remote_data_source.dart';
import '../../domain/entities/practitioner_card.dart';

class BusinessCardPage extends StatefulWidget {
  const BusinessCardPage({super.key, required this.practitionerIdOrSlug});

  final String practitionerIdOrSlug;

  @override
  State<BusinessCardPage> createState() => _BusinessCardPageState();
}

class _BusinessCardPageState extends State<BusinessCardPage> {
  PractitionerCard? _card;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadCard();
  }

  Future<void> _loadCard() async {
    try {
      final ds = sl<PractitionerRemoteDataSourceImpl>();
      final card = await ds.getCardAsync(widget.practitionerIdOrSlug);
      if (mounted) setState(() { _card = card; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _error = true; _loading = false; });
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _saveContact() async {
    if (_card == null) return;
    final url = '${EnvConfig.backendUrl}/api/v1/practitioners/${_card!.id}/vcard';
    await _launchUrl(url);
  }

  Future<void> _share() async {
    if (_card == null) return;
    final siteUrl = 'https://dokal.co.il';
    final identifier = _card!.cardSlug ?? _card!.id;
    final url = '$siteUrl/he/card/$identifier';
    await SharePlus.instance.share(
      ShareParams(
        text: '${_card!.fullName}\n${_card!.headline}\n$url',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (_loading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error || _card == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.cardNotFound, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    final card = _card!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(card)),
          SliverToBoxAdapter(child: _buildActions(card, l10n)),
          SliverToBoxAdapter(child: _buildSaveContact(l10n)),
          if (card.about != null && card.about!.isNotEmpty)
            SliverToBoxAdapter(child: _buildAbout(card, l10n)),
          SliverToBoxAdapter(child: _buildInfo(card, l10n)),
          SliverToBoxAdapter(child: _buildBookButton(card, l10n)),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),
        ],
      ),
    );
  }

  Widget _buildHeader(PractitionerCard card) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: _share,
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          top: 140,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: ClipOval(
                child: card.avatarUrl != null
                    ? CachedNetworkImage(
                        imageUrl: card.avatarUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _avatarPlaceholder(card),
                        errorWidget: (_, __, ___) => _avatarPlaceholder(card),
                      )
                    : _avatarPlaceholder(card),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.fullName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  if (card.headline.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      card.headline,
                      style: const TextStyle(fontSize: 15, color: AppColors.primary, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (card.organizationName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      card.organizationName!,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                  if (card.averageRating != null && card.reviewCount > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          '${card.averageRating!.toStringAsFixed(1)} (${card.reviewCount})',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder(PractitionerCard card) {
    return Container(
      color: AppColors.primaryLightBackground,
      child: Center(
        child: Text(
          '${card.firstName.isNotEmpty ? card.firstName[0] : ''}${card.lastName.isNotEmpty ? card.lastName[0] : ''}',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildActions(PractitionerCard card, AppLocalizations l10n) {
    final actions = <_ActionData>[];

    if (card.phone != null) {
      actions.add(_ActionData(
        icon: Icons.phone,
        label: l10n.cardCallMe,
        color: Colors.amber,
        onTap: () => _launchUrl('tel:${card.phone}'),
      ));
    }
    if (card.email != null) {
      actions.add(_ActionData(
        icon: Icons.email_outlined,
        label: l10n.cardEmail,
        color: Colors.amber,
        onTap: () => _launchUrl('mailto:${card.email}'),
      ));
    }
    if (card.whatsappNumber != null) {
      final num = card.whatsappNumber!.replaceAll(RegExp(r'[^0-9]'), '');
      actions.add(_ActionData(
        icon: Icons.chat,
        label: 'WhatsApp',
        color: Colors.green,
        onTap: () => _launchUrl('https://wa.me/$num'),
      ));
    }
    if (card.instagramUrl != null) {
      actions.add(_ActionData(
        icon: Icons.camera_alt_outlined,
        label: 'Instagram',
        color: Colors.pink,
        onTap: () => _launchUrl(card.instagramUrl!),
      ));
    }
    if (card.facebookUrl != null) {
      actions.add(_ActionData(
        icon: Icons.facebook,
        label: 'Facebook',
        color: Colors.blue,
        onTap: () => _launchUrl(card.facebookUrl!),
      ));
    }
    if (card.linkedinUrl != null) {
      actions.add(_ActionData(
        icon: Icons.work_outline,
        label: 'LinkedIn',
        color: Colors.blue.shade800,
        onTap: () => _launchUrl(card.linkedinUrl!),
      ));
    }
    if (card.websiteUrl != null) {
      actions.add(_ActionData(
        icon: Icons.language,
        label: 'Web',
        color: AppColors.primary,
        onTap: () => _launchUrl(card.websiteUrl!),
      ));
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.md,
        children: actions.map((a) => _ActionButton(data: a)).toList(),
      ),
    );
  }

  Widget _buildSaveContact(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _saveContact,
          icon: const Icon(Icons.person_add, size: 20),
          label: Text(l10n.cardSaveContact),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.pill)),
          ),
        ),
      ),
    );
  }

  Widget _buildAbout(PractitionerCard card, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.cardAbout, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Container(height: 1, color: AppColors.primaryLightBackground)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(card.about!, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildInfo(PractitionerCard card, AppLocalizations l10n) {
    final items = <Widget>[];

    if (card.addressLine != null || card.city != null) {
      final address = [card.addressLine, card.city].where((s) => s != null).join(', ');
      items.add(_InfoRow(
        icon: Icons.location_on_outlined,
        label: address,
        trailing: card.wazeLink != null || card.googleMapsLink != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (card.wazeLink != null)
                    GestureDetector(
                      onTap: () => _launchUrl(card.wazeLink!),
                      child: const Text('Waze', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                    ),
                  if (card.wazeLink != null && card.googleMapsLink != null) const SizedBox(width: 8),
                  if (card.googleMapsLink != null)
                    GestureDetector(
                      onTap: () => _launchUrl(card.googleMapsLink!),
                      child: const Text('Maps', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                    ),
                ],
              )
            : null,
      ));
    }

    if (card.education != null) {
      items.add(_InfoRow(icon: Icons.school_outlined, label: card.education!));
    }

    if (card.languages != null && card.languages!.isNotEmpty) {
      items.add(_InfoRow(icon: Icons.language, label: card.languages!.join(', ')));
    }

    if (card.yearsOfExperience != null && card.yearsOfExperience! > 0) {
      items.add(_InfoRow(
        icon: Icons.access_time,
        label: '${card.yearsOfExperience} ${l10n.cardYearsExperience}',
      ));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
      child: Column(children: items),
    );
  }

  Widget _buildBookButton(PractitionerCard card, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => context.push('/practitioner/${card.id}'),
          icon: const Icon(Icons.calendar_today, size: 18),
          label: Text(l10n.cardBookAppointment),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.pill)),
          ),
        ),
      ),
    );
  }
}

class _ActionData {
  _ActionData({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.data});
  final _ActionData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: data.color, width: 2),
            ),
            child: Icon(data.icon, color: data.color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(data.label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, this.trailing});
  final IconData icon;
  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
