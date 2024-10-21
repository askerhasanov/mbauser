import 'package:flutter/material.dart';
import 'elements/colors.dart';
import 'models/user.dart';

String? CurrentUserID;

UserModel? globalUser;

InputBorder myBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
        color: MbaColors.red, width: 1, style: BorderStyle.solid));
