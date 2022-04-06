import 'package:flutter/material.dart';
import 'package:week/utils/user_preferences.dart';
import '../models/user.dart';
import '../widgets/profileWidget.dart';
import '../widgets/textFieldWidget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = UserPreferences.myUser;

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
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: const Icon(
              Icons.more_horiz,
            ),
            tooltip: 'Settings',
            onPressed: () {
              /*
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));*/
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            isEditing: true,
            onClicked: () async {},
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldWidget(
            label: 'Full Name',
            text: user.name,
            onChange: (name) {},
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldWidget(
            label: 'Email',
            text: user.email,
            onChange: (email) {},
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldWidget(
            label: 'About',
            text: user.about,
            maxLines: 5,
            onChange: (about) {},
          ),
        ],
      ),
    );
  }
}
