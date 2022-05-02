import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/Screens/HomeForm.dart';
import 'package:week/Screens/LoginForm.dart';
import 'package:week/Screens/feed.dart';
import 'package:week/Screens/qrScreen.dart';

import '../widgets/profileWidget.dart';
import '../models/user.dart';
import '../widgets/numbersWidget.dart';

import 'package:week/utils/user_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool valNotify1 = true;
  bool valNotify2 = false;
  bool valNotify3 = false;

  onChangeFunction1(bool newValue1) {
    setState(() {
      valNotify1 = newValue1;
    });
  }

  onChangeFunction2(bool newValue2) {
    setState(() {
      valNotify2 = newValue2;
    });
  }

  onChangeFunction3(bool newValue3) {
    setState(() {
      valNotify3 = newValue3;
    });
  }

  signout() async{

    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("user_id");
    sp.remove("user_name");
    sp.remove("email");
    sp.remove("password");
  
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => LoginForm()));
  }

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          tooltip: 'Go back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            children: const [
              Icon(
                Icons.person,
                color: Colors.blue,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Account',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Divider(
            height: 20,
            thickness: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          buildAccountOption(context, 'Account Settings'),
          buildQrCodeOption(context, 'QrCode'),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: const [
              Icon(
                Icons.volume_up_outlined,
                color: Colors.blue,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Notifications',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Divider(
            height: 20,
            thickness: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          buildNotificationOption('Theme Dark', valNotify1, onChangeFunction1),
          buildNotificationOption(
              'Account Active', valNotify2, onChangeFunction2),
          buildNotificationOption('Opportunity', valNotify3, onChangeFunction3),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: signout,
              child: const Text(
                'SIGN OUT',
                style: TextStyle(
                    fontSize: 16, letterSpacing: 2.2, color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding buildNotificationOption(
      String title, bool value, Function onChangeMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600])),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
                activeColor: Colors.blue,
                trackColor: Colors.grey,
                value: value,
                onChanged: (bool newValue) {
                  onChangeMethod(newValue);
                }),
          )
        ],
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => HomeForm()));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600])),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ]),
        ));
  }
    GestureDetector buildQrCodeOption(BuildContext context, String title) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => qrScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600])),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ]),
        ));
  }
}
