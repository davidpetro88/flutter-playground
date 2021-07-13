import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    required String text,
    required Image logo,
    double height: 50.0,
    required Color color,
    required Color textColor,
    double borderRadius: 8.0,
    required VoidCallback onPressed,
  }) : assert( height > 0),
       assert( text.length > 1),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              logo,
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 16.0),
              ),
              Container()
            ],
          ),
          height: height,
          color: color,
          borderRadius: borderRadius,
          onPressed: onPressed,
        );
}
