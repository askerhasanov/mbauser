import 'package:flutter/material.dart';

import 'colors.dart';


class pageHeader extends StatelessWidget {

  final String text;
  const pageHeader({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MbaColors.red,
      child: Padding(
        padding:
        EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
        ),
      ),
    );
  }
}