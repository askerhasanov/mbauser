import 'package:flutter/material.dart';
import 'elements/colors.dart';
import 'models/user.dart';

String? CurrentUserID;

UserModel? globalUser;

String successUrl = 'mbauser://payment/success';
String cancelUrl = 'mbauser://payment/cancel';
String errorUrl = 'mbauser://payment/error';

InputBorder myBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
        color: MbaColors.red, width: 1, style: BorderStyle.solid));
