import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/UserModel.dart';
import 'package:week/models/comment_model.dart';
import 'package:week/models/like_model.dart';
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
  bool loading = true;
  var liked = false;
  var nLikes;
  bool showList = false;
  var dbHelper;

  //final listKey = GlobalKey<AnimatedListState>();
  List<Clothing> items = [];
  //GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Comment> coms = [];

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserData();
    getLike();
    getNLike();
    getList();
    getComs();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;
    setState(() {
      _conUserId.text = sp.getString("user_id")!;
    });
  }

  void getLike() async {
    debugPrint('getting like');
    var res = await dbHelper.getLike(
        widget.currentUser.user_id, widget.pub.publicationID.toString());

    setState(() {
      liked = res;
    });
  }

  void getNLike() async {
    debugPrint('getting like');
    var res = await dbHelper.getNLikes(widget.pub.publicationID.toString());

    setState(() {
      nLikes = res;
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

  void getComs() async {
    debugPrint('getting coms');
    var res = await dbHelper.getComments(widget.pub.publicationID);
    if (res != null) {
      debugPrint('got coms: ' + res.length.toString());
      for (var i = 0; i < res.length; i++) {
        debugPrint('' + res[i].toString());
      }
      setState(() {
        coms = res;
      });
    }
    setState(() {
      loading = false;
    });
  }

  void addComment() async {
    debugPrint('adding comment');
    Comment com = Comment(
        user_id: _conUserId.text,
        publicationID: widget.pub.publicationID.toString(),
        commentText: myController.text);
    await dbHelper.addComment(com);
    var res = await dbHelper.getComments(widget.pub.publicationID);

    if (res != null) {
      debugPrint('got coms: ' + res.length.toString());
      setState(() {
        coms = res;
      });
    }
    myController.clear();
  }

  void likePost() async {
    debugPrint('liking post');
    var val = 0;
    if (liked) {
      val = 1;
    }
    debugPrint('valor: ' + val.toString());

    LikeModel like = LikeModel(
        _conUserId.text, widget.pub.publicationID.toString(), val.toString());

    await dbHelper.addLike(like);
    getNLike();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEDF0F6),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
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
                                                  image: widget
                                                              .user.imagePath ==
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
                                      likePost();
                                    },
                                    child: /*showList
                                    ? Container()
                                    :*/
                                        Container(
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
                                              image: FileImage(File(widget
                                                  .photo.image
                                                  .toString())),
                                              fit: BoxFit.fitWidth)),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
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
                                                  likePost();
                                                },
                                                icon: liked
                                                    ? Icon(
                                                        Icons.favorite_outlined)
                                                    : Icon(
                                                        Icons.favorite_border),
                                                iconSize: 30,
                                              ),
                                              Text(
                                                nLikes,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          const SizedBox(width: 20),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    showList = !showList;
                                                    getList();
                                                  });
                                                },
                                                icon: const Icon(Icons.chat),
                                                iconSize: 30,
                                              ),
                                              Text(
                                                coms.length.toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                          Container(
                            width: double.infinity,
                            height: 600.0,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: coms.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CommentWidget(
                                  com: coms[index],
                                );
                              },
                            ),
                          )
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
                    controller: myController,
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
                          onPressed: () {
                            addComment();
                          },
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
