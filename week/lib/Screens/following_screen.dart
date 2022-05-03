import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/Screens/visiting_profile.dart';
import 'package:week/models/UserModel.dart';
import 'package:week/models/follower_model.dart';
import 'package:week/utils/bottom_nav_bar_widget.dart';
import 'dart:io';

class FollowingScreen extends StatefulWidget {
  final String user_id ; 

  const FollowingScreen({
    Key? key, required this.user_id
  }) : super(key: key);

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
  var listF;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserData();
    getList(widget.user_id);
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

  void getList(String user_id) async {
    print("getlist"+user_id);
    final SharedPreferences sp = await _pref;

    var res = await dbHelper.getFollowers(user_id);
    if (res != null) {
      var followersInfo = <UserModel>[];
      listF = res;
      for (var i = 0; i < res.length; i++) {
        followersInfo.add(await dbHelper.getUserInfo(res[i].followerID));
      }

      setState(() {
        list = followersInfo;
        loading = false;
      });
    }
  }

  void getFromList() async {

  }

  void unfollow(int index) async {
    await dbHelper.unfollow(listF[index]);
    setState(() {
      list.removeAt(index);
      listF.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 132, 132, 132),
      appBar: AppBar(
        title: Text('Following List'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 100, 6, 113),
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
                  height: 500,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: list.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return const SizedBox(width: 10);
                      }
                      final imgPath = list[index - 1].imagePath;
                      /*var t;
                      if (imgPath == null) {
                        t = const AssetImage('assets/images/flutter_logo.png');
                      } else {
                        t = Image.file(File(imgPath.toString()));
                      }*/

                      return Card(
                          child: InkWell(
                        splashColor: Colors.purple.withAlpha(30),
                        onTap: () {
                          debugPrint('Card tapped.');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => VisitingProfile(
                                          idVisiting: (index-1).toString(),
                                          user: list[index-1]))));
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: ClipOval(
                                child: Image(
                                  height: 60,
                                  width: 60,
                                  image: imgPath == null
                                      ? AssetImage(
                                              'assets/images/flutter_logo.png')
                                          as ImageProvider
                                      : FileImage(File(imgPath.toString())),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(list[index - 1].user_name),
                              subtitle: Text(list[index - 1].about.toString()),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: const Text('Unfollow',
                                              style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.purple,
                                              ),
                                              ),
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
