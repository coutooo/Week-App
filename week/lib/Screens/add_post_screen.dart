import 'package:flutter/material.dart';
import 'package:week/models/user.dart';
import 'package:week/utils/user_preferences.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  User user = UserPreferences.myUser;

  File? img;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      //final imageTemporary = File(image.path);
      final imagePermanet = await saveImagePermanently(image.path);
      setState(() => img = imagePermanet);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF0F6),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 40),
                width: double.infinity,
                height: 600,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  iconSize: 30,
                                  icon: const Icon(Icons.arrow_back),
                                  color: Colors.black,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: ListTile(
                                      leading: Container(
                                        width: 50,
                                        height: 50,
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
                                            height: 50,
                                            width: 50,
                                            image: AssetImage(user.imagePath),
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                      ),
                                      title: Text(
                                        user.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))
                              ]),
                          InkWell(
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                width: double.infinity,
                                height: 400,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0, 5),
                                          blurRadius: 8)
                                    ],
                                    image: DecorationImage(
                                        image: img != null
                                            ? FileImage(img!) as ImageProvider
                                            : AssetImage(
                                                'assets/images/placeholder.jpg'),
                                        fit: BoxFit.fitWidth)),
                              )),
                        ],
                      ),
                    ),
                  ],
                )),
            SizedBox(
                width: 240,
                height: 48,
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                        onPressed: () => pickImage(ImageSource.gallery),
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.image_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(width: 15),
                            Text(
                              'Pick Gallery',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )
                          ],
                        )))),
            SizedBox(
                width: 240,
                height: 48,
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                        onPressed: () => pickImage(ImageSource.camera),
                        child: Row(
                          children: const [
                            Icon(Icons.camera_alt_outlined),
                            SizedBox(width: 15),
                            Text(
                              'Pick Camera',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        )))),
          ],
        ),
      ),
    );
  }
}
