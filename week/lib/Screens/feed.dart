import 'package:flutter/material.dart';
import 'profile.dart';

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
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.people),
          tooltip: 'Show Snackbar',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Showing your friends')));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.portrait),
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
      body: const Center(
        child: Text(
          'This is your feed page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
