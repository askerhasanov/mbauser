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
        onPressed: callback,
        style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.black,
            foregroundColor: Colors.black,
            side: BorderSide(
                color: lineColor,
                width: 1,
                style: BorderStyle.solid
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),

            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(width: double.maxFinite, child: Text(text, style: TextStyle(color: lineColor, fontSize: 20), textAlign: TextAlign.center,)),
        ));
  }
}