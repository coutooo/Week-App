import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/models/outfit_model.dart';
import 'package:week/models/user.dart';
import 'package:week/utils/list_item_widget.dart';
import 'package:week/utils/user_preferences.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../DatabaseHandler/DbHelper.dart';
import '../models/posts_model.dart';

class OutfitWidget extends StatefulWidget {
  const OutfitWidget({Key? key}) : super(key: key);

  @override
  State<OutfitWidget> createState() => _OutfitWidgetState();
}

class _OutfitWidgetState extends State<OutfitWidget> {
  User user = UserPreferences.myUser;
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();
  late List<bool> values;

  late int count;
  var photo;
  bool flag = true;
  bool clicked = false;
  var initialDay;
  var pid;

  final listKey = GlobalKey<AnimatedListState>();
  List<Clothing> items = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var commentWidgets = <Widget>[];

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserData();

    values = List.filled(7, false);
    DateTime dateTime = DateTime.now();
    var date = DateTime.parse(dateTime.toString());
    var currentWeekDay = 0;
    if (date.weekday != 7) {
      currentWeekDay = date.weekday;
    }
    values[currentWeekDay] = true;
    count = currentWeekDay;
    clicked = false;
    initialDay = currentWeekDay;
    getPhotos(dateTime, 1);
    getList();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;
    setState(() {
      _conUserId.text = sp.getString("user_id")!;
    });
  }

  Future getPhotos(DateTime dateTime, int duration) async {
    final SharedPreferences sp = await _pref;

    var currDate = DateFormat("yyyy-MM-dd").format(dateTime);
    final nextDay = dateTime.add(Duration(days: duration));
    var res = await dbHelper.photoToday(sp.getString("user_id")!, currDate,
        DateFormat("yyyy-MM-dd").format(nextDay));
    if (res != null) {
      var bytes = await File(res.image).readAsBytes();

      var img64 = Photo.base64String(bytes.buffer.asUint8List());
      print("Photo ID: " + res.photoId.toString());
      setState(() {
        photo = img64;
        pid = (int.parse(res.photoId) - 1).toString();
      });
      getList();
      flag = false;
      print('Got a photo today');
    } else {
      photo = null;
      pid = null;
      print('No photos today!!!!!!');
    }
  }

  Future getPhotos2(DateTime dateTime, int duration) async {
    if (duration >= 0) {
      print('diff: ' + duration.toString());
      var goalDay = dateTime.subtract(Duration(days: duration));
      var currDate = DateFormat("yyyy-MM-dd").format(goalDay);
      final nextDay = goalDay.add(const Duration(days: 1));
      var res = await dbHelper.photoToday(
          _conUserId.text, currDate, DateFormat("yyyy-MM-dd").format(nextDay));
      if (res != null) {
        var bytes = await File(res.image).readAsBytes();

        var img64 = Photo.base64String(bytes.buffer.asUint8List());
        setState(() {
          photo = img64;
          pid = (int.parse(res.photoId) - 1).toString();
        });
        getList();
        flag = false;
        print('Got a photo today');
      } else {
        setState(() {
          photo = null;
          pid = null;
        });
        print('No photos today');
      }
    } else {
      setState(() {
        photo = null;
        pid = null;
      });
    }
  }

  void getList() async {
    if (pid != null) {
      print('getting list');
      var res = await dbHelper.getClothing(_conUserId.text, pid);
      if (res != null) {
        print('got clothes: ' + res.length.toString());
        setState(() {
          items = res;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        WeekdaySelector(
          onChanged: (int day) {
            setState(() {
              final index = day % 7;
              if (index != count) {
                items = <Clothing>[];
                pid = null;
                var diff = initialDay - index;
                values[count] = false;
                values[index] = !values[index];
                count = index;
                print('here');
                getPhotos2(DateTime.now(), diff);
                getList();
              }
            });
          },
          values: values,
        ),
        buildOutfit(context, photo),
        Container(
          height: 400,
          child: items.isNotEmpty
              ? AnimatedList(
                  key: listKey,
                  initialItemCount: items.length,
                  itemBuilder: (context, index, animation) => ListItemWidget(
                        item: items[index],
                        animation: animation,
                        onClicked: () => {},
                      ))
              : const Text('No clothing pieces'),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
        ),
      ],
    ));
  }

  void addTag(BuildContext context, TapUpDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    var btn = Positioned(
        left: localOffset.dx,
        top: localOffset.dy,
        child: Container(
          width: 100,
          child: Card(
              child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
            },
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, maxWidth: 130),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  ListTile(
                    title: Text(
                      'VESTIDO MIDI DRAPEADO',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Zara',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ])),
          )),
        ));

    setState(() {
      clicked = !clicked;

      if (commentWidgets.isEmpty) {
        commentWidgets.add(btn);
      } else {
        commentWidgets = [];
      }
    });
  }

  Widget buildOutfit(BuildContext context, var photo) {
    return Stack(
      children: <Widget>[
        GestureDetector(
            //onTapUp: (TapUpDetails details) => addTag(context, details),
            child: /*clicked
                    ? Container(
                        margin: const EdgeInsets.all(10.0),
                        width: double.infinity,
                        height: 400.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            image: DecorationImage(
                              image: photo != null
                                  ? Image.memory(
                                          Photo.dataFromBase64String(photo))
                                      .image
                                  : AssetImage('assets/images/placeholder.jpg'),
                              fit: BoxFit.fitWidth,
                              opacity: 100,
                            )))
                    :*/
                Container(
                    margin: const EdgeInsets.all(10.0),
                    width: double.infinity,
                    height: 400.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        image: DecorationImage(
                          image: photo != null
                              ? Image.memory(Photo.dataFromBase64String(photo))
                                  .image
                              : const AssetImage(
                                  'assets/images/placeholder.jpg'),
                          fit: BoxFit.fitWidth,
                          opacity: 1,
                        )))),
      ] /*+
          commentWidgets*/
      ,
    );
  }

/*
  Widget buildOutfit() => GestureDetector(
      
      onTapUp: (detail) => addTag(detail),
      child: clicked
          ? Stack(
              children: [
                Container(
                    margin: const EdgeInsets.all(10.0),
                    width: double.infinity,
                    height: 400.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        image: DecorationImage(
                          image: flag
                              ? AssetImage('assets/images/modelo1.png')
                              : AssetImage('assets/images/modelo1.png'),
                          fit: BoxFit.fitWidth,
                          opacity: 100,
                        ))),
                commentWidgets[0]
              ],
            )
          : Container(
              margin: const EdgeInsets.all(10.0),
              width: double.infinity,
              height: 400.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  image: DecorationImage(
                    image: flag
                        ? AssetImage('assets/images/modelo1.png')
                        : AssetImage('assets/images/modelo1.png'),
                    fit: BoxFit.fitWidth,
                    opacity: 1,
                  ))));*/

  /*
          Row(
            children: [
              Expanded(
                  child: GridView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0),
                children: const [
                  Image(
                    image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                  ),
                  Image(
                    image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                  ),
                  Image(
                    image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                  ),
                  Image(
                    image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                  )
                ],
              )),
            ],
          )*/

}
