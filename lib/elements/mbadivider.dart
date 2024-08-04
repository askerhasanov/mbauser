import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MbaDivider extends StatelessWidget {
  final String text;
  final Color lineColor;
  const MbaDivider({
    super.key,
    required this.text,
    required this.lineColor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(height:2, thickness: 2, color: this.lineColor,)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(this.text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
        ),
        Expanded(child: Divider(height:2,thickness: 2, color: this.lineColor,)),
      ],
    );
  }
}