import 'package:flutter/material.dart';

class EventHubTextFormField extends StatelessWidget {
  const EventHubTextFormField({
    super.key,
    this.controller,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.textInputType,
    this.maxLength,
    this.textAlign,
    this.focusNode,
    this.onchange,
    this.validator,
  });

  final TextEditingController? controller;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType? textInputType;
  final int? maxLength;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Function(String)? onchange;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: textInputType,
      maxLength: maxLength,
      focusNode: focusNode,
      textAlign: textAlign ?? TextAlign.left,
      onChanged: onchange,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        counterText: "",
        hintText: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
    );
  }
}
