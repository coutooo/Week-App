import 'package:flutter/material.dart';
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
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Login',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 235, 64, 147),
                      fontSize: 50.0),
                ),
                SizedBox(height: 10.0),
                Image.asset(
                  "assets/images/logo.png",
                  height: 100.0,
                  width: 100.0,
                ),
                Text(
                  'Sample Code',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                      fontSize: 20.0),
                ),
                genTextFormField(
                  _conUserId, 
                  'User ID', 
                  Icons.person, 
                  false),
                SizedBox(height: 5.0),
                genTextFormField(
                  _conPassword,   // verificar aqui se é este ou o conuserid
                  'Password', 
                  Icons.lock, 
                  true),
                  //https://youtu.be/OvE00_oz7yM?t=2742
                Container(
                  margin: EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
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
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => FeedPage())));
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
