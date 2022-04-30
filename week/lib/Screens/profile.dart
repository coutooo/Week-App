import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/screens/editProfilePage.dart';
import 'dart:io';
import '../utils/bottom_nav_bar_widget.dart';
import '../widgets/profileWidget.dart';
import '../models/user.dart';
import '../widgets/numbersWidget.dart';
import 'package:week/screens/settingsPage.dart';
import '../utils/outfit_widget.dart';
import '../utils/bottom_nav_bar_widget.dart';
import '../models/UserModel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  File? image;
  var dbHelper;
  var user;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserData();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;
    final res = await dbHelper.getLoginUser(
        sp.getString("user_id")!, sp.getString("password")!);
    setState(() {
      _conUserId.text = sp.getString("user_id")!;
      _conUserName.text = sp.getString("user_name")!;
      _conEmail.text = sp.getString("email")!;
      _conPassword.text = sp.getString("password")!;
      user = res;
      loading = false;
      print("got an user: " + user.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    //final user = UserPreferences.myUser;
    return Scaffold(
      appBar: AppBar(
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
        actions: [
          IconButton(
            color: Colors.black,
            icon: const Icon(
              Icons.more_horiz,
            ),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
              /*
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));*/
            },
          ),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: loading
            ? [CircularProgressIndicator()]
            : [
                ProfileWidget(
                  imagePath: user.imagePath ?? 'assets/images/flutter_logo.png',
                  onClicked: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                              user: user,
                            )));
                    loading = true;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                buildName(user),
                const SizedBox(
                  height: 24,
                ),
                NumbersWidget(),
                const SizedBox(
                  height: 48,
                ),
                buildAbout(user),
                const SizedBox(
                  height: 48,
                ),
                OutfitWidget(),
              ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget buildName(UserModel user) => Column(
        children: [
          Text(
            user.user_name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(UserModel user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about == null ? ('') : user.about.toString(),
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
