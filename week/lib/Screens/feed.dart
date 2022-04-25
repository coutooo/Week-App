import 'package:flutter/material.dart';
import 'profile.dart';
import '../utils/post_widget.dart';
import '../models/post_model.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Showing your friends')));
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
        body: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              width: double.infinity,
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stories.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return const SizedBox(width: 10);
                  }
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
                        child: ClipOval(
                      child: Image(
                        height: 60,
                        width: 60,
                        image: AssetImage(stories[index - 1]),
                        fit: BoxFit.cover,
                      ),
                    )),
                  );
                },
              ),
            ),
            PostWidget(index: 0),
            PostWidget(index: 1),
          ],
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child:
              BottomNavigationBar(type: BottomNavigationBarType.fixed, items: [
            const BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.dashboard,
                  size: 30,
                  color: Colors.black,
                )),
            const BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.grey,
                )),
            BottomNavigationBarItem(
              icon: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: FlatButton(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Color(0xFF23B66F),
                  onPressed: () => print('Upload photo'),
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
            const BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.person_outline,
                  size: 30,
                  color: Colors.grey,
                )),
          ]),
        ));
  }
}
