import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenith_stores/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.hintText,
    required this.icon,
    this.bottom = 0.0,
    this.obscureText = false,
    required this.keyboardType,
    required this.onChanged,
    required this.validate,
    Key? key,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final double bottom;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final String? Function(String?)? validate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: bottom),
      child: TextFormField(
        validator: validate,
        cursorColor: kDarkGreenColor,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(
          color: kDarkGreenColor,
          fontWeight: FontWeight.w600,
          fontSize: 15.0,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(18.0),
          filled: true,
          fillColor: kGinColor,
          prefixIcon: Icon(
            icon,
            size: 24.0,
            color: kDarkGreenColor,
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: kDarkGreenColor,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: kGinColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: kDarkGreenColor),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
