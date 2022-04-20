import 'package:flutter/material.dart';
import 'package:week/models/post_model.dart';

class PostScreen extends StatefulWidget {
  final Post post;
  PostScreen({required this.post});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
