import 'package:flutter/material.dart';

class UiHelpers{


  static void showSnackBar({
   required BuildContext context,  required String title, Color? color
}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color ?? Colors.black,
        content: Text(title),
        showCloseIcon: true,
      ),
      snackBarAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
      ),
    );
  }





}