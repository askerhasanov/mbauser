import 'package:flutter/material.dart';

class MbaButton extends StatelessWidget {

  final VoidCallback callback;
  final Color bgColor;
  final String text;

  const MbaButton({
    super.key,
    required this.callback,
    required this.bgColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: Colors.red,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(width: double.maxFinite, child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,)),
        ));
  }
}