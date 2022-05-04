import 'package:flutter/material.dart';
import 'package:week/Screens/feed.dart';
import 'package:week/Screens/profile.dart';
import 'package:week/screens/add_post_screen.dart';
import 'package:week/screens/closet_screen.dart';
import 'package:week/screens/visiting_profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: BottomNavigationBar(type: BottomNavigationBarType.fixed, items: [
        BottomNavigationBarItem(
            label: '',
            icon: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FeedPage()));
                },
            icon: Icon(
              Icons.dashboard,
              size: 30,
              color: Colors.black,
            ))),
        BottomNavigationBarItem(
            label: '',
            icon: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ClosetScreen()));
                },
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.grey,
                ))),
        BottomNavigationBarItem(
          icon: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: FlatButton(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: const Color.fromARGB(255, 100, 6, 113),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddPostScreen()));
              },
              child: const Icon(
                Icons.add,
                size: 35.0,
                color: Colors.white,
              ),
            ),
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.favorite_border,
              size: 30,
              color: Colors.grey,
            )),
        BottomNavigationBarItem(
            label: '',
            icon: IconButton(
                onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => ProfilePage())));
                },
                icon: Icon(
                  Icons.person_outline,
                  size: 30,
                  color: Colors.grey,
                ))),
      ]),
    );
  }
}
