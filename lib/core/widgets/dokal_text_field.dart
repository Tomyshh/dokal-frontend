import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DokalTextField extends StatelessWidget {
  const DokalTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onFieldSubmitted,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
