import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/outfit_model.dart';
import 'package:week/models/posts_model.dart';
import 'package:week/screens/postScreen.dart';
import 'package:week/utils/action_button.dart';
import 'package:week/utils/bottom_nav_bar_widget.dart';
import 'package:week/utils/expandable_fab.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({Key? key}) : super(key: key);

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  final columns = ['Type', 'Color', 'Season', 'Brand', 'Store', 'Date'];

  bool loading = true;

  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();

  List<Clothing> items = [];
  var dbHelper;

  var currUser;
  var pubPhoto;
  var pubUser;
  var randomPub;

  int? sortColumnIndex;
  bool isAscending = false;

  bool ready = false;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    getUserData();
    getList();
    selectRandomPost();
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

  void selectRandomPost() async {
    final SharedPreferences sp = await _pref;
    var currUser = await dbHelper.getUserInfo(sp.getString("user_id")!);
    var pub = await dbHelper.getRandomPost(sp.getString("user_id")!);
    var photo;
    var pubUser;

    if (pub != null) {
      debugPrint('Got random pub');
      pubUser = await dbHelper.getUserInfo(pub.user_id);
      if (pubUser != null) {
        photo = await dbHelper.getPhoto(pub.photoId.toString());
      }
    }

    setState(() {
      this.currUser = currUser;
      pubPhoto = photo;
      this.pubUser = pubUser;
      randomPub = pub;
      ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'One';
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
                  child: Container(
                    child: Column(
                      children: [
                        Row(children: [
                          DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: <String>['One', 'Two', 'Free', 'Four']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ]),
                        buildDataTable(items),
                      ],
                    ),
                  )),
            ),
      floatingActionButton: ExpandableFab(
        inCloset: true,
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () {
              selectRandomPost();

              if (ready) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PostScreen(
                            user: pubUser,
                            pub: randomPub,
                            photo: pubPhoto,
                            currentUser: currUser)));
              }
              setState(() {
                ready = false;
              });
            },
            icon: const Icon(
              Icons.abc,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () {},
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () {},
            icon: const Icon(Icons.camera),
          ),
          ActionButton(
            onPressed: () {
              _showMyDialog();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final TextEditingController _textEditingControllerCol =
            TextEditingController();
        final TextEditingController _textEditingControllerTerm =
            TextEditingController();
        return AlertDialog(
          title: const Text('Sort term'),
          content: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: ListBody(
              children: [
                TextFormField(
                  controller: _textEditingControllerCol,
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      if (columns.contains(value)) {
                        return null;
                      }
                    }
                    return "Invalid Field";
                  },
                  decoration: const InputDecoration(hintText: "Column"),
                ),
                TextFormField(
                  controller: _textEditingControllerTerm,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Invalid Field";
                  },
                  decoration: const InputDecoration(hintText: "Search term"),
                ),
              ],
            ),
          )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildDataTable(List<Clothing> clothing) {
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
