import 'package:flutter/material.dart';

class UiHelpers{


  static void showSnackBar(BuildContext context, String title){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
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