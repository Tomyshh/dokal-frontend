import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../services/google_places_service.dart';
import '../../l10n/l10n.dart';

/// Champ d'adresse avec autocomplétion Google Places, limité à Israël.
/// Retourne [PlaceDetails] (address_line, zip_code, city) lors de la sélection.
class AddressAutocompleteField extends StatefulWidget {
  const AddressAutocompleteField({
    super.key,
    required this.controller,
    required this.placesService,
    this.label,
    this.hint,
    this.validator,
    this.onPlaceSelected,
  });

  final TextEditingController controller;
  final GooglePlacesService placesService;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final void Function(PlaceDetails details)? onPlaceSelected;

  @override
  State<AddressAutocompleteField> createState() => _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  final _layerLink = LayerLink();
  final _debounce = 400;
  final _focusNode = FocusNode();
  Timer? _debounceTimer;
  List<PlacePrediction> _predictions = [];
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  String? _lastErrorShown;
  DateTime? _lastErrorAt;
  bool _suppressNextTextChange = false;
  String? _selectedDescription;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _debounceTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _hideOverlay();
    }
  }

  void _onTextChanged() {
    if (_suppressNextTextChange) {
      _suppressNextTextChange = false;
      return;
    }
    final current = widget.controller.text.trim();
    if (_selectedDescription != null && current != _selectedDescription) {
      _selectedDescription = null;
    }
    if (_selectedDescription != null && current == _selectedDescription) {
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: _debounce), () {
      _fetchPredictions(widget.controller.text);
    });
  }

  Future<void> _fetchPredictions(String input) async {
    if (input.trim().length < 2) {
      _hideOverlay();
      return;
    }
    setState(() => _isLoading = true);
    try {
      final predictions = await widget.placesService.getPredictions(input);
      if (!mounted) return;
      setState(() {
        _predictions = predictions;
        _isLoading = false;
      });
      if (predictions.isNotEmpty) {
        _showPredictionsOverlay();
      } else {
        _hideOverlay();
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _predictions = [];
        _isLoading = false;
      });
      _hideOverlay();
      _showPlacesError(error);
    }
  }

  void _showPredictionsOverlay() {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => _PredictionsOverlay(
        layerLink: _layerLink,
        predictions: _predictions,
        isLoading: _isLoading,
        onSelect: _onSelectPrediction,
        onDismiss: _hideOverlay,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _hideOverlay() {
    _removeOverlay();
    setState(() {});
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _onSelectPrediction(PlacePrediction p) async {
    _hideOverlay();
    _suppressNextTextChange = true;
    _selectedDescription = p.description.trim();
    widget.controller.text = p.description;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: p.description.length),
    );
    if (mounted) {
      setState(() => _predictions = []);
    }

    try {
      final details = await widget.placesService.getPlaceDetails(p.placeId);
      if (details != null && mounted) {
        widget.onPlaceSelected?.call(details);
      }
    } catch (error) {
      if (!mounted) return;
      _showPlacesError(error);
    }
  }

  void _showPlacesError(Object error) {
    final l10n = context.l10n;
    final message = error is PlacesApiException
        ? switch (error.status) {
            'INVALID_RESPONSE' => l10n.placesErrorInvalidResponse,
            'BACKEND_ERROR' => l10n.placesErrorBackend,
            'UNEXPECTED_ERROR' => l10n.placesErrorUnexpected,
            _ => l10n.placesErrorGeneric,
          }
        : l10n.placesErrorGeneric;
    final now = DateTime.now();
    final recentlyShown = _lastErrorShown == message &&
        _lastErrorAt != null &&
        now.difference(_lastErrorAt!) < const Duration(seconds: 3);
    if (recentlyShown) return;

    _lastErrorShown = message;
    _lastErrorAt = now;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: const Icon(Icons.location_on_rounded),
          suffixIcon: _isLoading
              ? SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null,
        ),
        validator: widget.validator,
        onTap: () {
          if (widget.controller.text.trim().length >= 2 && _predictions.isNotEmpty) {
            _showPredictionsOverlay();
          }
        },
      ),
    );
  }
}

class _PredictionsOverlay extends StatelessWidget {
  const _PredictionsOverlay({
    required this.layerLink,
    required this.predictions,
    required this.isLoading,
    required this.onSelect,
    required this.onDismiss,
  });

  final LayerLink layerLink;
  final List<PlacePrediction> predictions;
  final bool isLoading;
  final void Function(PlacePrediction) onSelect;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      offset: Offset(0, 48.h),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12.r),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 280.h),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: predictions.length,
            itemBuilder: (context, i) {
              final p = predictions[i];
              return ListTile(
                leading: Icon(
                  Icons.place_rounded,
                  size: 20.r,
                  color: AppColors.textSecondary,
                ),
                title: Text(
                  p.mainText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                subtitle: p.description != p.mainText
                    ? Text(
                        p.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                onTap: () => onSelect(p),
              );
            },
          ),
        ),
      ),
    );
  }
}
