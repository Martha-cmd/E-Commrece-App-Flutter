import 'package:flutter/material.dart';
import 'package:zenith_stores/constants.dart';

class AuthenticationButton extends StatelessWidget {
  AuthenticationButton({
    required this.child,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12.0),
        ),
        backgroundColor: MaterialStateProperty.all(kDarkGreenColor),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
      ),
      onPressed: onPressed,
      child:  child
    );
  }
}
