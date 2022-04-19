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
        ));
  }
}
