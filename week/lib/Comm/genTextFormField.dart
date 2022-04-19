import 'package:flutter/material.dart';

import 'comHelper.dart';

class genTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintName;
  IconData icon;
  bool isobscureText;
  TextInputType inputType;
  bool readonly;

  genTextFormField(
    this.controller,
    this.hintName,
    this.icon,
    this.isobscureText,
    this.inputType,
    this.readonly);

  @override
  Widget build(BuildContext context) {
    return  Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: controller,
                    obscureText: isobscureText,
                    keyboardType: inputType,
                    enabled: !readonly,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter $hintName';
                      }
                      if (hintName == "Email" && !validateEmail(value)) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Color.fromARGB(255, 100, 6, 113)),
                      ),
                      prefixIcon: Icon(icon),
                      hintText: hintName,
                      labelText: hintName,
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                );
  }
}