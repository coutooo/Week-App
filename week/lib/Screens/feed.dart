import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/UserModel.dart';
import 'package:week/models/posts_model.dart';
import 'package:week/screens/following_screen.dart';
import 'package:week/screens/visiting_profile.dart';
import 'package:week/utils/bottom_nav_bar_widget.dart';
import 'profile.dart';
import '../utils/post_widget.dart';
import 'dart:io';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  var dbHelper;
  var user;
  var stories;
  var pubs = [];
  var pubsInfo = [];
  var photos = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserData();
    getPosts();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;
    final res = await dbHelper.getLoginUser(
        sp.getString("user_id")!, sp.getString("password")!);
    final res2 = await dbHelper.getRandomUsers(sp.getString("user_id")!);
    setState(() {
      _conUserId.text = sp.getString("user_id")!;
      _conUserName.text = sp.getString("user_name")!;
      _conEmail.text = sp.getString("email")!;
      _conPassword.text = sp.getString("password")!;
      user = res;
      stories = res2;
      loading = false;
      debugPrint("got an user: " + user.toString());
    });
  }

  Future<void> getPosts() async {
    final SharedPreferences sp = await _pref;
    var followers = await dbHelper.getFollowers(sp.getString("user_id")!);
    var posts = <Publication>[];
    var temp;

    var dateTime = DateTime.now();
    var currDate = DateFormat("yyyy-MM-dd").format(dateTime);
    final nextDay =
        DateFormat("yyyy-MM-dd").format(dateTime.add(const Duration(days: 1)));

    if (followers != null) {
      debugPrint('Got followers: ' + followers.length.toString());
      for (var i = 0; i < followers.length; i++) {
        debugPrint(followers[i].toString());
        temp =
            await dbHelper.getPub(followers[i].followerID, currDate, nextDay);
        if (temp != null) {
          posts.add(temp);
          pubsInfo.add(await dbHelper.getUserInfo(followers[i].followerID));
          photos.add(await dbHelper.getPhoto(temp.photoId));
        }
      }
    }

    setState(() {
      pubs = posts;
      loading = false;
      debugPrint("got posts: " + pubs.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF0F6),
      appBar: AppBar(
        title: const Text(
          'Week',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.people),
          color: Colors.black,
          tooltip: 'Show Snackbar',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => FollowingScreen())));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.portrait),
            color: Colors.black,
            tooltip: 'Profile',
            onPressed: () {
              /*
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));*/
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => ProfilePage())));
            },
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Container(
                  width: double.infinity,
                  height: 100.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: stories == null ? 0 : stories.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return const SizedBox(width: 10);
                      }
                      final imgPath = stories[index - 1].imagePath;
                      return Container(
                        margin: const EdgeInsets.all(10),
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 2),
                                  blurRadius: 6)
                            ]),
                        child: CircleAvatar(
                            child: GestureDetector(
                          onTapUp: (details) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => VisitingProfile(
                                        idVisiting: _conUserId.text,
                                        user: stories[index - 1]))));
                          },
                          child: ClipOval(
                            child: Image(
                              height: 60,
                              width: 60,
                              image: imgPath == null
                                  ? AssetImage('assets/images/flutter_logo.png')
                                      as ImageProvider
                                  : FileImage(File(imgPath.toString())),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 700.0,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: pubs.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return const SizedBox(width: 10);
                      }

                      return PostWidget(
                          user: pubsInfo[index - 1],
                          pub: pubs[index - 1],
                          photo: photos[index - 1]);
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
