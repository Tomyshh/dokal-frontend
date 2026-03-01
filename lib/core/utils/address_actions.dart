import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/l10n.dart';

/// Opens the native map app with the given [address].
/// iOS -> Apple Plans, Android -> Google Maps.
Future<void> openAddressInMaps(String address) async {
  final encoded = Uri.encodeComponent(address);
  final Uri uri;
  if (Platform.isIOS) {
    uri = Uri.parse('https://maps.apple.com/?q=$encoded');
  } else {
    uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
  }
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

/// Copies [address] to clipboard and shows a snackbar.
void copyAddress(BuildContext context, String address) {
  Clipboard.setData(ClipboardData(text: address));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(context.l10n.addressCopied),
      duration: const Duration(seconds: 2),
    ),
  );
}
