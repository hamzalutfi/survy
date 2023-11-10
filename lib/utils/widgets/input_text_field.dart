import 'package:flutter/material.dart';

import '../constants/colors.dart';

class InputTextField extends StatelessWidget {
  final String hintText;
  final String errorText;
  final bool showError;
  final bool obscureText;
  final TextInputType inputType;
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String)? onSubmit;
  final Color color;
  final int maxLines;

  InputTextField({
    required this.onChanged,
    this.onSubmit,
    this.hintText = '',
    this.errorText = '',
    this.showError = false,
    this.obscureText = false,
    this.maxLines = 1,
    required this.controller,
    required this.inputType,
    this.color = textFieldColor, ////////
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(color: showError ? Colors.red : color, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: TextField(
              maxLines: maxLines,
              controller: controller,
              keyboardType: inputType,
              obscureText: obscureText,
              textInputAction: TextInputAction.done,
              onSubmitted: onSubmit,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 15,
                  color: hintOfTextFieldColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              cursorColor: primaryColor,
            ),
          ),
        ),
        Visibility(
          visible: showError && errorText != null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Text(
              errorText,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.red,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
