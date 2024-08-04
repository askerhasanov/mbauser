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
        onPressed: this.callback,
        style: ElevatedButton.styleFrom(
            backgroundColor: this.bgColor,
            foregroundColor: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(width: double.maxFinite, child: Text(this.text, style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,)),
        ));
  }
}