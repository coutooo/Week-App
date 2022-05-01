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
      print("got an user: " + user.toString());
    });
  }

  void getList() async {
    final SharedPreferences sp = await _pref;

    var res = await dbHelper.getFollowers(sp.getString("user_id")!);
    if (res != null) {
      setState(() {
        list = res;
        loading = false;
      });
    }
  }

  void unfollow(int index) async {
    await dbHelper.unfollow(list[index]);
    setState(() {
      list.removeAt(index);
    });
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
                Container(
                  width: double.infinity,
                  height: 150.0,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: list.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return const SizedBox(width: 10);
                      } /*
                      final imgPath = list[index - 1].imagePath;
                      var t;
                      if (imgPath == null) {
                        t = const AssetImage('assets/images/flutter_logo.png');
                      } else {
                        t = FileImage(File(imgPath.toString()));
                      }*/
                      var t = AssetImage('assets/images/flutter_logo.png');

                      return Card(
                          child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          debugPrint('Card tapped.');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.abc),
                              title: Text(list[index - 1].followerID),
                              subtitle: Text(list[index - 1].date),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: const Text('Unfollow'),
                                  onPressed: () {
                                    unfollow(index - 1);
                                  },
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ));
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
