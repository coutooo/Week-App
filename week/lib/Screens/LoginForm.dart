import 'package:flutter/material.dart';
import 'package:week/Comm/comHelper.dart';
import 'package:week/Comm/genLoginSignupHeader.dart';
import 'package:week/Comm/genTextFormField.dart';
import 'package:week/Screens/HomeForm.dart';
import 'package:week/Screens/SignupForm.dart';
import '../DatabaseHandler/DbHelper.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }
  
  login() async {
    String uid = _conUserId.text;
    String passwd = _conPassword.text;

    if (uid.isEmpty) {
      alertDialog(context, "Please Enter User ID");
    } else if(passwd.isEmpty){
      alertDialog(context, "Please Enter Password");
    } else {
      await dbHelper.getLoginUser(uid,passwd).then((userData){
        print(userData.email);
        if (userData != null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeForm()),
                (Route<dynamic> route) => false);
        } else {
          alertDialog(context, "Error: User Not Found");
        }
      }).catchError((error){
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

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
                SizedBox(height: 10.0),
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
                      onPressed: login,
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
