import 'package:flutter/material.dart';
import 'package:week/models/outfit_model.dart';

class ListItemWidget extends StatelessWidget {
  final Clothing item;
  final Animation<double> animation;
  final VoidCallback? onClicked;

  const ListItemWidget(
      {required this.item,
      required this.animation,
      required this.onClicked,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => SizeTransition(
        key: ValueKey(item.clothType),
        sizeFactor: animation,
        child: buildItem(),
      );

  Widget buildItem() => Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Icon(Icons.insert_emoticon),
          title: Text(
            item.clothType,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          trailing: IconButton(
              onPressed: onClicked,
              icon: Icon(Icons.delete, color: Colors.red, size: 32)),
        ),
      );
}
