import 'package:flutter/material.dart';
import 'package:week/Comm/comHelper.dart';
import 'package:week/Comm/genLoginSignupHeader.dart';
import 'package:week/Screens/LoginForm.dart';
import 'package:week/Comm/genTextFormField.dart';

class SignupForm extends StatefulWidget {

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();
  final _conCPassword = TextEditingController();

  signUp(){
    final form = _formKey.currentState;

    String uid = _conUserId.text;
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String passwd = _conPassword.text;
    String cpasswd = _conCPassword.text;

    if(form!.validate()){
      alertDialog(context, "ok");
    }

    if(uid.isEmpty)
    {
      alertDialog(context,"Please Enter User ID");
    } else if(uname.isEmpty){
      alertDialog(context,"Please Enter User Name");
    } else if(email.isEmpty){
      alertDialog(context,"Please Enter Email");
    } else if(passwd.isEmpty){
      alertDialog(context,"Please Enter Password");
    } else if(cpasswd.isEmpty){
      alertDialog(context,"Please Confirm Password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  genLoginSignupHeader('Signup'),
                  genTextFormField(
                    _conUserId, 
                    'User ID', 
                    Icons.person, 
                    false,
                    TextInputType.text),
                  SizedBox(height: 10.0),
                  genTextFormField(
                    _conUserName,
                    'User Name', 
                    Icons.person_outline, 
                    false,
                    TextInputType.name),
                  SizedBox(height: 10.0),
                  genTextFormField(
                    _conEmail,
                    'Email', 
                    Icons.email, 
                    false,
                    TextInputType.emailAddress),
                  SizedBox(height: 10.0),
                  genTextFormField(
                    _conPassword,
                    'Password', 
                    Icons.lock, 
                    true,
                    TextInputType.text),
                  SizedBox(height: 10.0),
                  genTextFormField(
                    _conCPassword,
                    'Confirm Password', 
                    Icons.lock, 
                    true,
                    TextInputType.text),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: FlatButton(
                      child: Text(
                        'SignUp',
                        style: TextStyle(color: Colors.white),
                        ),
                        onPressed: signUp,
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
                        Text('Do you have an account? '),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text('Sign In'),
                          onPressed: () { 
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginForm()),
                            (Route<dynamic> route) => false);
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
      ),
    );
  }
}