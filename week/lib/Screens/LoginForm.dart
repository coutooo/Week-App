import 'package:flutter/material.dart';
import 'package:week/Comm/genLoginSignupHeader.dart';
import 'package:week/Comm/genTextFormField.dart';
import 'package:week/Screens/SignupForm.dart';
import 'feed.dart';
import '../screens/editProfilePage.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                genLoginSignupHeader('Login'),
                genTextFormField(
                  _conUserId, 
                  'User ID', 
                  Icons.person, 
                  false,
                  TextInputType.text),
                SizedBox(height: 5.0),
                genTextFormField(
                  _conPassword,
                  'Password', 
                  Icons.lock, 
                  true,
                  TextInputType.text),
                Container(
                  margin: EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => FeedPage()));
                      },
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Does not have account? '),
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text('Signup'),
                        onPressed: () { 
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SignupForm()));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
