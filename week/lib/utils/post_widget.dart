import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../screens/postScreen.dart';

class PostWidget extends StatefulWidget {
  final int index;
  const PostWidget({Key? key, required this.index}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool liked = false;

  @override
  void initState() {
    super.initState();
    liked = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          width: double.infinity,
          height: 560,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ListTile(
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
                              image: AssetImage(
                                  posts[widget.index].authorImageUrl),
                              fit: BoxFit.cover,
                            ),
                          )),
                        ),
                        title: Text(
                          posts[widget.index].authorName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          posts[widget.index].timeAgo,
                        ),
                        trailing: IconButton(
                            color: Colors.black,
                            onPressed: () => print('More'),
                            icon: const Icon(
                              Icons.more_horiz,
                            ))),
                    InkWell(
                        onDoubleTap: () {
                          setState(() {
                            liked = !liked;
                          });
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PostScreen(
                                        post: posts[widget.index],
                                      )));
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
                                  image:
                                      AssetImage(posts[widget.index].imageUrl),
                                  fit: BoxFit.fitWidth)),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PostScreen(
                                              post: posts[widget.index],
                                            ),
                                          ));
                                    },
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
                            onPressed: () => print('Save Post'),
                            icon: const Icon(Icons.bookmark_border),
                            iconSize: 30,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
