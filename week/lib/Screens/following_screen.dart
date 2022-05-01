import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/utils/bottom_nav_bar_widget.dart';
import 'dart:io';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();
  bool loading = true;

  var dbHelper;
  var user;
  var list;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserData();
    getList();
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

  void getList() async {
    final SharedPreferences sp = await _pref;

    list = await dbHelper.getFollowers(sp.getString("user_id")!);
    if (list != null) {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF0F6),
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
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Center(
                  child: Card(
                      child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint('Card tapped.');
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading:
                              Image.asset('assets/images/flutter_logo.png'),
                          title: Text('The Enchanted Nightingale'),
                          subtitle: Text(
                              'Music by Julie Gable. Lyrics by Sidney Stein.'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: const Text('Unfollow'),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  )),
                )
              ],
            ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
