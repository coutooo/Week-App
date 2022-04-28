import 'package:flutter/material.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/posts_model.dart';
import 'package:week/models/user.dart';
import 'package:week/utils/action_button.dart';
import 'package:week/utils/expandable_fab.dart';
import 'package:week/utils/list_item_widget.dart';
import 'package:week/utils/user_preferences.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/models/outfit_model.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  User user = UserPreferences.myUser;
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();

  File? img;

  var dbHelper;

  bool isButtonClickable = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    dbHelper = DbHelper.instance;
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _conUserId.text = sp.getString("user_id")!;
    });
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      //final imageTemporary = File(image.path);
      final imagePermanet = await saveImagePermanently(image.path);

      setState(() {
        img = imagePermanet;
        isButtonClickable = true;
      });
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

  Future publish() async {
    var bytes = await File(img!.path).readAsBytes();

    var img64 = Photo.base64String(bytes.buffer.asUint8List());
    Photo photo = Photo(user_id: _conUserId.text, image: img64);
    dbHelper.insertPhoto(photo);

    DateTime dateTime = DateTime.now();

    Publication publication = Publication(
        user_id: _conUserId.text,
        photoId: await dbHelper.getLastPhotoID(),
        date: dateTime.toString());

    dbHelper.insertPublication(publication);
    print('Publication published');
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
                                            : const AssetImage(
                                                'assets/images/placeholder.jpg'),
                                        fit: BoxFit.fitWidth)),
                              )),
                        ],
                      ),
                    ),
                  ],
                )),
            Container(
              height: 400,
              child: listWidget(context),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
            ),
          ],
        ),
      ),
    );
  }

  Widget listWidget(BuildContext context) {
    final listKey = GlobalKey<AnimatedListState>();
    final List<Clothing> items = [];

    void insertItem(String uid, String photoid, String date, String clothType,
        String brand, String season, String store, String color) {
      final newIndex = items.length;

      final newItem = Clothing(
          user_id: uid,
          photoID: photoid,
          date: date,
          clothType: clothType,
          brand: brand,
          season: season,
          store: store,
          color: color);
      items.insert(newIndex, newItem);
      listKey.currentState!.insertItem(newIndex);
    }

    void removeItem(int index) {
      final removedItem = items[index];
      items.removeAt(index);
      listKey.currentState!.removeItem(
          index,
          (context, animation) => ListItemWidget(
              item: removedItem, animation: animation, onClicked: () {}));
    }

    return Scaffold(
      body: AnimatedList(
          key: listKey,
          initialItemCount: items.length,
          itemBuilder: (context, index, animation) => ListItemWidget(
                item: items[index],
                animation: animation,
                onClicked: () => removeItem(index),
              )),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () => insertItem('10', '11', 'asd', 'top', 'zara',
                'spring', 'zara aveiro', 'white'),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () => pickImage(ImageSource.gallery),
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () => pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera),
          ),
          ActionButton(
            onPressed: () {
              if (isButtonClickable) {
                publish();
                Navigator.pop(context);
              } else {
                const snackBar = SnackBar(
                  content: Text('Please select a photo'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
    );
  }
}
