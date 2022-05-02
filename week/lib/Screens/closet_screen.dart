import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/outfit_model.dart';
import 'package:week/utils/bottom_nav_bar_widget.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({Key? key}) : super(key: key);

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  bool loading = true;

  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();

  List<Clothing> items = [];
  var dbHelper;

  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserData();
    getList();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;
    setState(() {
      _conUserId.text = sp.getString("user_id")!;
    });
  }

  void getList() async {
    final SharedPreferences sp = await _pref;

    debugPrint('getting list');
    var res = await dbHelper.getAllClothingFromUser(sp.getString("user_id")!);
    if (res != null) {
      debugPrint('got clothes: ' + res.length.toString());
      setState(() {
        items = res;
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF0F6),
      appBar: AppBar(
        title: const Text(
          'Closet',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          tooltip: 'Go back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: buildDataTable(items),
              ),
            ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget buildDataTable(List<Clothing> clothing) {
    final columns = ['clothType', 'color', 'season', 'brand', 'store', 'date'];
    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(clothing),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(label: Text(column), onSort: onSort))
      .toList();

  List<DataRow> getRows(List<Clothing> clothing) =>
      clothing.map((Clothing cloth) {
        final cells = [
          cloth.clothType,
          cloth.color,
          cloth.season,
          cloth.brand,
          cloth.store,
          cloth.date
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      items.sort((user1, user2) =>
          compareString(ascending, user1.clothType, user2.clothType));
    } else if (columnIndex == 1) {
      items.sort(
          (user1, user2) => compareString(ascending, user1.color, user2.color));
    } else if (columnIndex == 2) {
      items.sort((user1, user2) =>
          compareString(ascending, user1.season, user2.season));
    } else if (columnIndex == 3) {
      items.sort(
          (user1, user2) => compareString(ascending, user1.brand, user2.brand));
    } else if (columnIndex == 4) {
      items.sort(
          (user1, user2) => compareString(ascending, user1.store, user2.store));
    } else if (columnIndex == 5) {
      items.sort(
          (user1, user2) => compareString(ascending, user1.date, user2.date));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
