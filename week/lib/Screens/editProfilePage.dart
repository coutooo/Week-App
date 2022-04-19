import 'dart:io';
import 'package:flutter/material.dart';
import 'package:week/utils/user_preferences.dart';
import '../models/user.dart';
import '../widgets/profileWidget.dart';
import '../widgets/profileWidget2.dart';
import '../widgets/textFieldWidget.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = UserPreferences.myUser;

  String? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      //final imageTemporary = File(image.path);
      final imagePermanet = await saveImagePermanently(image.path);
      //user.imagePath = imagePermanet;
      setState(() => this.image = imagePermanet);
    } on PlatformException catch (e) {}
  }

  Future saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final str = '${directory.path}/$name';
    var v = File(imagePath).copy(str);
    return str;
    //return File(imagePath).copy(image.path);
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
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          image != null
              ? ProfileWidget2(
                  imagePath: image!,
                  isEditing: true,
                  onClicked: () => pickImage(ImageSource.gallery),
                )
              : ProfileWidget(
                  imagePath: user.imagePath,
                  isEditing: true,
                  onClicked: () => pickImage(ImageSource.gallery),
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
