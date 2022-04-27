import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:week/models/outfit_model.dart';
import 'list_item_widget.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({Key? key}) : super(key: key);

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  final listKey = GlobalKey<AnimatedListState>();
  final List<Clothing> items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedList(
          key: listKey,
          initialItemCount: items.length,
          itemBuilder: (context, index, animation) => ListItemWidget(
                item: items[index],
                animation: animation,
                onClicked: () => removeItem(index),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => insertItem('10', '11', 'asd', 'dress', 'zara',
            'spring', 'zara aveiro', 'white'),
        child: const Icon(Icons.add),
      ),
    );
  }

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
}
