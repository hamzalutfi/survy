import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final Function() onPressed;
  final Color? buttonColor;

  const AuthButton({
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.buttonColor = primaryColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        minimumSize: Size(width, 50),
      ),
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.5,
            )
          : Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
    );
  }
}
