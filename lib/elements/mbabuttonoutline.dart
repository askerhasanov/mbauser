import 'package:flutter/material.dart';

class MbaButtonOutline extends StatelessWidget {

  final VoidCallback callback;
  final Color lineColor;
  final String text;

  const MbaButtonOutline({
    super.key,
    required this.callback,
    required this.lineColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: this.callback,
        style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.black,
            foregroundColor: Colors.black,
            side: BorderSide(
                color: this.lineColor,
                width: 1,
                style: BorderStyle.solid
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),

            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(width: double.maxFinite, child: Text(this.text, style: TextStyle(color: this.lineColor, fontSize: 20), textAlign: TextAlign.center,)),
        ));
  }
}