import 'dart:io';

import 'package:flutter/material.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/comment_model.dart';

class CommentWidget extends StatefulWidget {
  final Comment com;
  const CommentWidget({Key? key, required this.com}) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  //bool liked = false;
  bool loading = true;
  var dbHelper;
  var user;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserInfo();
    //liked = false;
  }

  Future<void> getUserInfo() async {
    debugPrint('getting user in com');
    var res = await dbHelper.getUserInfo(widget.com.user_id);
    if (res != null) {
      debugPrint('got user in com: ' + res.toString());
      setState(() {
        user = res;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: loading
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.all(10),
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
                            ? AssetImage('assets/images/flutter_logo.png')
                                as ImageProvider
                            : FileImage(File(user.imagePath.toString())),
                        fit: BoxFit.cover,
                      ),
                    )),
                  ),
                  title: Text(
                    user.user_name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(widget.com.commentText),
                  /*trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      liked = !liked;
                    });
                  },
                  icon: liked
                      ? Icon(Icons.favorite_outlined)
                      : Icon(Icons.favorite_border),
                  color: Colors.grey),*/
                )));
  }
}
