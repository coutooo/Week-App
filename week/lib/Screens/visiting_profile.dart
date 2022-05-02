import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/UserModel.dart';
import 'package:week/models/follower_model.dart';
import 'package:week/utils/bottom_nav_bar_widget.dart';
import 'package:week/utils/outfit_widget.dart';
import 'package:week/widgets/numbersWidget.dart';
import 'package:week/widgets/profileWidget.dart';

class VisitingProfile extends StatefulWidget {
  final String idVisiting;
  final UserModel user;
  const VisitingProfile(
      {Key? key, required this.user, required this.idVisiting})
      : super(key: key);

  @override
  State<VisitingProfile> createState() => _VisitingProfileState();
}

class _VisitingProfileState extends State<VisitingProfile> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  File? image;
  var dbHelper;

  String isfollowing = "Follow";

  bool loading = true;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserData();
    checkFollow();
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
      loading = false;
    });
  }

  Future<void> startFollowing() async {
    String date = DateTime.now().toString();
    FollowerModel fmodel =
        FollowerModel(widget.idVisiting, widget.user.user_id, date);
    await dbHelper.follow(fmodel);
    checkFollow();
  }

  Future<void> stopFollowing() async {
    // ultimo parametro nao vai ser usado nao interessa

    FollowerModel fmodel =
        FollowerModel(widget.idVisiting, widget.user.user_id,DateTime.now().toString());
    await dbHelper.unfollow(fmodel);
    checkFollow();
  }

  Future<void> checkFollow() async {
    bool following =
        await dbHelper.checkIfFollowing(widget.idVisiting, widget.user.user_id);
    print(following);
    setState(() {
      if (following) {
        isfollowing = "Following";
      } else {
        isfollowing = "Follow";
      }
    });
    print(isfollowing);
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: loading
            ? [Center(child: CircularProgressIndicator())]
            : [
                ProfileWidget(
                  imagePath:
                      widget.user.imagePath ?? 'assets/images/flutter_logo.png',
                  onClicked: () {},
                  isVisiting: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                buildName(widget.user),
                const SizedBox(
                  height: 24,
                ),
                NumbersWidget(),
                const SizedBox(
                  height: 48,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.purple, // Background color
                      onPrimary: Colors.white, // Text Color (Foreground color)
                      textStyle: const TextStyle(fontSize: 20)
                      
                      ),
                  onPressed: () {
                    if(isfollowing == "Following")
                    {
                      stopFollowing();
                    }else{
                      startFollowing();
                    }  
                  },
                  child: Text(isfollowing),
                ),
                buildAbout(widget.user),
                const SizedBox(
                  height: 48,
                ),
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
