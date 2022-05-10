import 'dart:io';
import 'package:flutter/material.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/posts_model.dart';
import '../widgets/profileWidget.dart';
import '../widgets/profileWidget2.dart';
import '../widgets/textFieldWidget.dart';
import '../models/UserModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({required this.user, Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? image;
  var dbHelper;
  late final TextEditingController controllerAbout =
      TextEditingController(text: widget.user.about);
  late final TextEditingController controllerEmail =
      TextEditingController(text: widget.user.email);
  late final TextEditingController controllerUserName =
      TextEditingController(text: widget.user.user_name);

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      //final imageTemporary = File(image.path);
      final imagePermanet = await saveImagePermanently(image.path);

      //user.imagePath = imagePermanet;
      setState(() => this.image = imagePermanet.path);
    } on PlatformException catch (e) {}
  }

  Future saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  saveNewData(BuildContext context) async {
    UserModel u;

    if (image != null) {
      u = UserModel(
          widget.user.user_id,
          controllerUserName.text,
          controllerEmail.text,
          widget.user.password,
          image,
          controllerAbout.text);
    } else {
      u = UserModel(
          widget.user.user_id,
          controllerUserName.text,
          controllerEmail.text,
          widget.user.password,
          widget.user.imagePath,
          controllerAbout.text);
    }
/*
    print('about: ' + controllerAbout.text);
    print('name: ' + controllerUserName.text);
    print('email: ' + controllerEmail.text);
    print('image: ' + image.toString());*/
    dbHelper.updateUser(u);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  imagePath:
                      widget.user.imagePath ?? 'assets/images/flutter_logo.png',
                  isEditing: true,
                  onClicked: () => pickImage(ImageSource.gallery),
                ),
          const SizedBox(
            height: 24,
          ),
          TextFieldWidget(
            label: 'Full Name',
            text: widget.user.user_name,
            onChange: (name) {},
            controller: controllerUserName,
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldWidget(
            label: 'Email',
            text: widget.user.email,
            onChange: (email) {},
            controller: controllerEmail,
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldWidget(
            label: 'About',
            text: widget.user.about ?? '',
            maxLines: 5,
            onChange: (about) {},
            controller: controllerAbout,
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                textStyle: const TextStyle(fontSize: 20)),
            onPressed: () => saveNewData(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
