import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:toast/toast.dart';

alertDialog(BuildContext context, String msg) {
  Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
}

validateEmail(String email) {
  final emailReg = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return emailReg.hasMatch(email);
}


// https://www.youtube.com/watch?v=8sC9paqJJjI
// https://www.youtube.com/watch?v=8uwMxnWwCgM