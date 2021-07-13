import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    required String text,
    double height: 50.0,
    required Color color,
    required Color textColor,
    double borderRadius: 8.0,
    required VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16.0),
          ),
          height: height,
          color: color,
          borderRadius: borderRadius,
          onPressed: onPressed,
        );
}
