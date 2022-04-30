import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/Comm/comHelper.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/Screens/LoginForm.dart';
import 'package:week/models/UserModel.dart';
import 'package:week/models/user.dart';

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
  final _conDelUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();

    dbHelper = DbHelper.instance;
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _conUserId.text = sp.getString("user_id")!;
      _conDelUserId.text = sp.getString("user_id")!;
      _conUserName.text = sp.getString("user_name")!;
      _conEmail.text = sp.getString("email")!;
      _conPassword.text = sp.getString("password")!;
    });
  }

  update() async {
    String uid = _conUserId.text;
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String passwd = _conPassword.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      UserModel user = UserModel(uid, uname, email, passwd, null, null);
      await dbHelper.updateUser(user).then((value) {
        if (value == 1) {
          alertDialog(context, "Successfully Updated");

          updateSP(user, true).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginForm()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Update Error");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error");
      });
    }
  }

  delete() async {
    String delUserID = _conDelUserId.text;

    await dbHelper.deleteUser(delUserID).then((value) {
      if (value == 1) {
        alertDialog(context, "Successfully Deleted");

        updateSP(null, false).whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginForm()),
              (Route<dynamic> route) => false);
        });
      }
    });
  }

  Future updateSP(UserModel? user, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      sp.setString("user_name", user!.user_name);
      sp.setString("email", user.email);
      sp.setString("password", user.password);
    } else {
      sp.remove('user_id');
      sp.remove('user_name');
      sp.remove('email');
      sp.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Account'),
        backgroundColor: Color.fromARGB(255, 100, 6, 113),
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
                  //update
                  genTextFormField(_conUserId, 'User ID', Icons.person, false,
                      TextInputType.text, true),
                  SizedBox(height: 10.0),
                  genTextFormField(_conUserName, 'User Name',
                      Icons.person_outline, false, TextInputType.name, false),
                  SizedBox(height: 10.0),
                  genTextFormField(_conEmail, 'Email', Icons.email, false,
                      TextInputType.emailAddress, false),
                  SizedBox(height: 10.0),
                  genTextFormField(_conPassword, 'Password', Icons.lock, true,
                      TextInputType.text, false),
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
                      color: Color.fromARGB(255, 100, 6, 113),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),

                  // delete
                  genTextFormField(_conDelUserId, 'User ID', Icons.person,
                      false, TextInputType.text, true),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: FlatButton(
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: delete,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 100, 6, 113),
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
