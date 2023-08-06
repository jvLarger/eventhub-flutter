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
    this.readOnly,
    this.onTap,
    this.maxLines,
    this.minLines,
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
  final bool? readOnly;
  final Function()? onTap;
  final int? minLines;
  final int? maxLines;
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
      readOnly: readOnly ?? false,
      onTap: onTap,
      minLines: obscureText != null && obscureText! ? 1 : minLines,
      maxLines: obscureText != null && obscureText! ? 1 : maxLines,
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
