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
        buildOutfit()
      ],
    ));
  }

  Widget buildOutfit() => Container(
      margin: const EdgeInsets.all(10.0),
      width: double.infinity,
      height: 400.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          image: DecorationImage(
              image: flag
                  ? AssetImage('assets/images/default_image.png')
                  : AssetImage('assets/images/default_image.png'),
              fit: BoxFit.fitWidth)));

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
