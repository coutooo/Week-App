import 'package:flutter/material.dart';
import 'package:week/models/comment_model.dart';

class CommentWidget extends StatefulWidget {
  final int index;
  const CommentWidget({Key? key, required this.index}) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool liked = false;

  @override
  void initState() {
    super.initState();
    liked = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
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
                    image: AssetImage(comments[widget.index].authorImageUrl),
                    fit: BoxFit.cover,
                  ),
                )),
              ),
              title: Text(
                comments[widget.index].authorName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(comments[widget.index].text),
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      liked = !liked;
                    });
                  },
                  icon: liked
                      ? Icon(Icons.favorite_outlined)
                      : Icon(Icons.favorite_border),
                  color: Colors.grey),
            )));
  }
}
