import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final double height;
  final Color color;
  final double borderRadius;
  final VoidCallback? onPressed;

  CustomElevatedButton({
    required this.child,
    required this.height,
    required this.color,
    required this.borderRadius,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),

        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
