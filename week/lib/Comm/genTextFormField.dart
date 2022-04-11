import 'package:flutter/material.dart';

class genTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintName;
  IconData icon;
  bool isobscureText;
  TextInputType inputType;

  genTextFormField(
    this.controller,
    this.hintName,
    this.icon,
    this.isobscureText,
    this.inputType);

  @override
  Widget build(BuildContext context) {
    return  Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: controller,
                    obscureText: isobscureText,
                    keyboardType: inputType,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(icon),
                      hintText: hintName,
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                );
  }
}