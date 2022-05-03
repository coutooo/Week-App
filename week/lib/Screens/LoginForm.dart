import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/Comm/comHelper.dart';
import 'package:week/Comm/genLoginSignupHeader.dart';
import 'package:week/Comm/genTextFormField.dart';
import 'package:week/screens/SignupForm.dart';
import 'package:week/models/UserModel.dart';
import '../DatabaseHandler/DbHelper.dart';
import 'feed.dart';
import 'dart:async';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();

  var dbHelper;
  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
  }

  login() async {
    String uid = _conUserId.text;
    String passwd = _conPassword.text;

    if (uid.isEmpty) {
      alertDialog(context, "Please Enter User ID");
    } else if (passwd.isEmpty) {
      alertDialog(context, "Please Enter Password");
    } else {
      await dbHelper.getLoginUser(uid, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => FeedPage()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Error: User Not Found");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("user_id", user.user_id);
    sp.setString("user_name", user.user_name);
    sp.setString("email", user.email);
    sp.setString("password", user.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 100, 6, 113),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                genLoginSignupHeader('Login'),
                genTextFormField(_conUserId, 'User ID', Icons.person, false,
                    TextInputType.text, false),
                const SizedBox(height: 10.0),
                genTextFormField(_conPassword, 'Password', Icons.lock, true,
                    TextInputType.text, false),
                Container(
                  margin: const EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: TextButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: login,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 100, 6, 113),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? '),
                    TextButton(
                      child: const Text(
                        'Signup',
                        style:
                            TextStyle(color: Color.fromARGB(255, 100, 6, 113)),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SignupForm()));
                      },
                    ),
                    /*
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                          },
                          child: const Text('Profile')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FeedPage()));
                          },
                          child: const Text('Feed'))*/
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
