import 'package:flutter/material.dart';

class HomeForm extends StatefulWidget {

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(child: Text('Login Successful'),
      ),
    );
  }
}