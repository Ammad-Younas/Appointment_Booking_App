import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      style: TextStyle(fontFamily: 'Ubuntu', color: Colors.black),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(fontFamily: 'Ubuntu', color: AppColors.madiGrey),
        filled: true,
        fillColor: AppColors.madiGrey.withAlpha(77),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            color: AppColors.madiGrey,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        )
            : null,
      ),
    );
  }
}