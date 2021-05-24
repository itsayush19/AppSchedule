import 'package:flutter/material.dart';

class CostumedButton extends StatelessWidget {
  CostumedButton({
    this.child,
    this.color,
    this.borderRadius: 10.0,
    this.onPressed,
    this.h,
  });
  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final double h;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h,
      child: RaisedButton(
        child: child,
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            )
        ),
        onPressed: onPressed,
      ),
    );
  }
}
