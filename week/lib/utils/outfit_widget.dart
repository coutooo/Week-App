import 'package:flutter/material.dart';
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
  late List<bool> values;
  late int count;
  late Photo photo;
  bool flag = true;
  bool clicked = false;

  var commentWidgets = <Widget>[];

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;

    values = List.filled(7, false);
    DateTime dateTime = DateTime.now();
    var date = DateTime.parse(dateTime.toString());
    var currentWeekDay = 0;
    if (date.weekday != 7) {
      currentWeekDay = date.weekday - 1;
    }
    values[currentWeekDay] = true;
    count = currentWeekDay;
    clicked = false;

    getPhotos(dateTime.toString());
  }

  Future getPhotos(String dateTime) async {
    var res;
    res = await dbHelper.photo(dateTime);
    if (res != null) {
      flag = false;
      photo = res;
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
                values[count] = false;
                values[index] = !values[index];
                count = index;
                getPhotos(DateTime.now().toString());
              }
            });
          },
          values: values,
        ),
        buildOutfit(context),
      ],
    ));
  }

  void addTag(BuildContext context, TapUpDetails details) {
    print('${details.globalPosition}');
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

  Widget buildOutfit(BuildContext context) {
    return Stack(
      children: <Widget>[
            GestureDetector(
                onTapUp: (TapUpDetails details) => addTag(context, details),
                child: clicked
                    ? Container(
                        margin: const EdgeInsets.all(10.0),
                        width: double.infinity,
                        height: 400.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            image: DecorationImage(
                              image: flag
                                  ? AssetImage('assets/images/placeholder.jpg')
                                  : AssetImage('assets/images/modelo2.jpg'),
                              fit: BoxFit.fitWidth,
                              opacity: 100,
                            )))
                    : Container(
                        margin: const EdgeInsets.all(10.0),
                        width: double.infinity,
                        height: 400.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            image: DecorationImage(
                              image: flag
                                  ? AssetImage('assets/images/placeholder.jpg')
                                  : AssetImage('assets/images/modelo2.jpg'),
                              fit: BoxFit.fitWidth,
                              opacity: 1,
                            )))),
          ] +
          commentWidgets,
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
