import 'package:flutter/material.dart';
import 'package:week/Screens/LoginForm.dart';

class SignupForm extends StatefulWidget {

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup'),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.person),
                      hintText: 'User ID',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 5.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'User Name',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 5.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 5.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 5.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Confirm Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      'SignUp',
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
                      Text('Do you have an account? '),
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text('Sign In'),
                        onPressed: () { 
                          Navigator.push(context, MaterialPageRoute(builder: (_) => LoginForm()));
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