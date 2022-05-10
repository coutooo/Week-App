import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/posts_model.dart';
import 'package:week/utils/action_button.dart';
import 'package:week/utils/expandable_fab.dart';
import 'package:week/utils/list_item_widget.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/models/outfit_model.dart';
import 'package:flutter/foundation.dart' as foundation;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();
  var photoID;

  File? img;
  var user;
  var dbHelper;
  bool loading = true;

  bool isButtonClickable = false;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserData();
    listenSensor();
    setBrightness(1);
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;
    final res = await dbHelper.getLoginUser(
        sp.getString("user_id")!, sp.getString("password")!);

    setState(() {
      _conUserId.text = sp.getString("user_id")!;
      photoID = 0;
      user = res;
      loading = false;
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
      debugPrint('Failed to pick image: $e');
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
    Photo photo = Photo(user_id: _conUserId.text, image: img!.path);
    dbHelper.insertPhoto(photo);

    DateTime dateTime = DateTime.now();
    var pid = await dbHelper.getLastPhotoID();
    Publication publication = Publication(
        user_id: _conUserId.text, photoId: pid, date: dateTime.toString());

    dbHelper.insertPublication(publication);
    if (items.isNotEmpty) {
      for (var i = 0; i < items.length; i++) {
        items[i].photoID = pid;
        dbHelper.insertClothing(items[i]);
        debugPrint('inserted: ' + i.toString());
      }
    }
    debugPrint('Publication published');
    debugPrint('uid: ' + _conUserId.text + '\nPhotoID: ' + photoID.toString());
    resetBrightness();
  }

  final listKey = GlobalKey<AnimatedListState>();
  final List<Clothing> items = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  late StreamSubscription<dynamic> _streamSubscription;

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to reset brightness';
    }
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      debugPrint(event.toString());
      if (event > 0) {
        setBrightness(0);
      } else {
        setBrightness(1);
      }
    });
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final TextEditingController _textEditingControllerType =
            TextEditingController();
        final TextEditingController _textEditingControllerBrand =
            TextEditingController();
        final TextEditingController _textEditingControllerSeason =
            TextEditingController();
        final TextEditingController _textEditingControllerColor =
            TextEditingController();
        final TextEditingController _textEditingControllerStore =
            TextEditingController();

        return AlertDialog(
          title: const Text('Add a clothing piece'),
          content: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: ListBody(
              children: [
                TextFormField(
                  controller: _textEditingControllerType,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Invalid Field";
                  },
                  decoration: InputDecoration(hintText: "Type"),
                ),
                TextFormField(
                  controller: _textEditingControllerBrand,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Invalid Field";
                  },
                  decoration: InputDecoration(hintText: "Brand"),
                ),
                TextFormField(
                  controller: _textEditingControllerSeason,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Invalid Field";
                  },
                  decoration: InputDecoration(hintText: "Season"),
                ),
                TextFormField(
                  controller: _textEditingControllerColor,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Invalid Field";
                  },
                  decoration: InputDecoration(hintText: "Color"),
                ),
                TextFormField(
                  controller: _textEditingControllerStore,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Invalid Field";
                  },
                  decoration: InputDecoration(hintText: "Store"),
                ),
              ],
            ),
          )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final date = DateTime.now();
                  insertItem(
                      _conUserId.text,
                      photoID.toString(),
                      date.toString(),
                      _textEditingControllerType.text,
                      _textEditingControllerBrand.text,
                      _textEditingControllerSeason.text,
                      _textEditingControllerStore.text,
                      _textEditingControllerColor.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        iconSize: 30,
                                        icon: const Icon(Icons.arrow_back),
                                        color: Colors.black,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
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
                                                  image: user.imagePath == null
                                                      ? AssetImage(
                                                              'assets/images/flutter_logo.png')
                                                          as ImageProvider
                                                      : FileImage(
                                                          File(user.imagePath)),
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                            ),
                                            title: Text(
                                              user.user_name,
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
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black45,
                                                offset: Offset(0, 5),
                                                blurRadius: 8)
                                          ],
                                          image: DecorationImage(
                                              image: img != null
                                                  ? FileImage(img!)
                                                      as ImageProvider
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
                    child: AnimatedList(
                        key: listKey,
                        initialItemCount: items.length,
                        itemBuilder: (context, index, animation) =>
                            ListItemWidget(
                              item: items[index],
                              animation: animation,
                              onClicked: () => removeItem(index),
                            )),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ],
              ),
            ),
            floatingActionButton: ExpandableFab(
              inCloset: false,
              distance: 112.0,
              children: [
                ActionButton(
                  onPressed: () {
                    _showMyDialog(context);
                  },
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

  Widget listWidget(BuildContext context, String uid, int photoID) {
    final listKey = GlobalKey<AnimatedListState>();
    final List<Clothing> items = [];
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          final TextEditingController _textEditingControllerType =
              TextEditingController();
          final TextEditingController _textEditingControllerBrand =
              TextEditingController();
          final TextEditingController _textEditingControllerSeason =
              TextEditingController();
          final TextEditingController _textEditingControllerColor =
              TextEditingController();
          final TextEditingController _textEditingControllerStore =
              TextEditingController();

          return AlertDialog(
            title: const Text('Add a clothing piece'),
            content: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: ListBody(
                children: [
                  TextFormField(
                    controller: _textEditingControllerType,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Type"),
                  ),
                  TextFormField(
                    controller: _textEditingControllerBrand,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Brand"),
                  ),
                  TextFormField(
                    controller: _textEditingControllerSeason,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Season"),
                  ),
                  TextFormField(
                    controller: _textEditingControllerColor,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Color"),
                  ),
                  TextFormField(
                    controller: _textEditingControllerStore,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Store"),
                  ),
                ],
              ),
            )),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final date = DateTime.now();
                    insertItem(
                        uid,
                        photoID.toString(),
                        date.toString(),
                        _textEditingControllerType.text,
                        _textEditingControllerBrand.text,
                        _textEditingControllerSeason.text,
                        _textEditingControllerStore.text,
                        _textEditingControllerColor.text);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
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
        inCloset: false,
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () {
              _showMyDialog();
            },
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
