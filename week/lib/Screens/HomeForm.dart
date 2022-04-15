import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/UserModel.dart';

import '../Comm/genTextFormField.dart';

class HomeForm extends StatefulWidget {

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  final _formKey = new GlobalKey<FormState>();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  var dbHelper;

  final _conUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  @override
  void initState(){
    super.initState();
    getUserData();

    dbHelper = DbHelper();
  }

  Future<void> getUserData() async{
    final SharedPreferences sp = await _pref;

    setState(() {
      _conUserId.text = sp.getString("user_id")!;
      _conUserName.text = sp.getString("user_name")!;
      _conEmail.text = sp.getString("email")!;
      _conPassword.text = sp.getString("password")!;
    });
  }

  update(){
    String uid = _conUserId.text;
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String passwd = _conPassword.text;


    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      UserModel user = UserModel(uid, uname, email, passwd);
      dbHelper.updateUser(user);

      //https://youtu.be/8uwMxnWwCgM?t=1950 tou aquiiii
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Account'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //genLoginSignupHeader('Signup'),
                  genTextFormField(
                    _conUserId, 
                    'User ID', 
                    Icons.person, 
                    false,
                    TextInputType.text,
                    true),
                  SizedBox(height: 10.0),
                  genTextFormField(
                    _conUserName, 
                    'User Name', 
                    Icons.person_outline, 
                    false,
                    TextInputType.name,
                    false),
                  SizedBox(height: 10.0),
                  genTextFormField(
                    _conEmail, 
                    'Email', 
                    Icons.email, 
                    false,
                    TextInputType.emailAddress,
                    false),
                  SizedBox(height: 10.0),
                  genTextFormField(
                    _conPassword, 
                    'Password', 
                    Icons.lock, 
                    true,
                    TextInputType.text,
                    false),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: FlatButton(
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                        ),
                        onPressed: update,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
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