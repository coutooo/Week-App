import 'dart:io';

import 'package:flutter/material.dart';
import 'package:week/models/UserModel.dart';

class Stories extends StatefulWidget {
  final UserModel user;
  const Stories({Key? key, required this.user}) : super(key: key);

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 60,
      height: 60,
      decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(color: Colors.black45, offset: Offset(0, 2), blurRadius: 6)
      ]),
      child: CircleAvatar(
          child: ClipOval(
        child: Image(
          height: 60,
          width: 60,
          image: FileImage(File(widget.user.imagePath.toString())),
          fit: BoxFit.cover,
        ),
      )),
    );
  }
}
