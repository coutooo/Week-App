import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/UserModel.dart';
import 'package:week/models/outfit_model.dart';
import 'package:week/models/posts_model.dart';
import 'package:week/models/user.dart';
import 'package:week/utils/comment_widget.dart';
import 'package:week/utils/list_item_widget.dart';
import 'package:week/utils/user_preferences.dart';

class PostScreen extends StatefulWidget {
  final UserModel user;
  final UserModel currentUser;
  final Publication pub;
  final Photo photo;
  const PostScreen(
      {Key? key,
      required this.user,
      required this.pub,
      required this.photo,
      required this.currentUser})
      : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  User user = UserPreferences.myUser;
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();

  bool liked = false;
  bool showList = false;
  var dbHelper;

  final listKey = GlobalKey<AnimatedListState>();
  List<Clothing> items = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserData();
    getList();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;
    setState(() {
      _conUserId.text = sp.getString("user_id")!;
    });
  }

  void getList() async {
    debugPrint('getting list');
    var res =
        await dbHelper.getClothing(widget.user.user_id, widget.photo.photoId);
    if (res != null) {
      debugPrint('got clothes: ' + res.length.toString());
      setState(() {
        items = res;
      });
    }
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
                                      width: MediaQuery.of(context).size.width *
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
                                              image: widget.user.imagePath ==
                                                      null
                                                  ? const AssetImage(
                                                          'assets/images/flutter_logo.png')
                                                      as ImageProvider
                                                  : FileImage(File(widget
                                                      .user.imagePath
                                                      .toString())),
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                        ),
                                        title: Text(
                                          widget.user.user_name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          widget.user.email,
                                        ), /*
                                          trailing: IconButton(
                                              color: Colors.black,
                                              onPressed: () => print('More'),
                                              icon: const Icon(
                                                Icons.more_horiz,
                                              ))*/
                                      ))
                                ]),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    showList = !showList;
                                    getList();
                                  });
                                },
                                onDoubleTap: () {
                                  setState(() {
                                    liked = !liked;
                                  });
                                },
                                child: /*showList
                                    ? Container()
                                    :*/
                                    Container(
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
                                          image: FileImage(File(
                                              widget.photo.image.toString())),
                                          fit: BoxFit.fitWidth)),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                liked = !liked;
                                              });
                                            },
                                            icon: liked
                                                ? Icon(Icons.favorite_outlined)
                                                : Icon(Icons.favorite_border),
                                            iconSize: 30,
                                          ),
                                          const Text(
                                            '2,515',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 20),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.chat),
                                            iconSize: 30,
                                          ),
                                          const Text(
                                            '350',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showList = !showList;
                                      });
                                    },
                                    icon: const Icon(Icons.more),
                                    iconSize: 30,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              showList
                  ? Container(
                      height: 400,
                      child: items.isNotEmpty
                          ? AnimatedList(
                              key: listKey,
                              initialItemCount: items.length,
                              itemBuilder: (context, index, animation) =>
                                  ListItemWidget(
                                    item: items[index],
                                    animation: animation,
                                    onClicked: () => {},
                                  ))
                          : const Text('No clothing pieces'),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                    )
                  : Container(
                      width: double.infinity,
                      height: 600,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                        children: [
                          CommentWidget(index: 0),
                          CommentWidget(index: 1),
                          CommentWidget(index: 2),
                          CommentWidget(index: 3),
                          CommentWidget(index: 4)
                        ],
                      ),
                    )
            ],
          ),
        ),
        bottomNavigationBar: Transform.translate(
            offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                height: 100.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -2),
                      blurRadius: 6.0,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.all(20.0),
                      hintText: 'Add a comment',
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(4.0),
                        width: 48.0,
                        height: 48.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          child: ClipOval(
                            child: Image(
                              height: 48.0,
                              width: 48.0,
                              image: widget.user.imagePath == null
                                  ? const AssetImage(
                                          'assets/images/flutter_logo.png')
                                      as ImageProvider
                                  : FileImage(
                                      File(widget.user.imagePath.toString())),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 4.0),
                        width: 70.0,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: const Color(0xFF23B66F),
                          onPressed: () => print('Post comment'),
                          child: const Icon(
                            Icons.send,
                            size: 25.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ))));
  }
}
