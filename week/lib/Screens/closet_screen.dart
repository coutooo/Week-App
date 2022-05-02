import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/models/outfit_model.dart';
import 'package:week/screens/postScreen.dart';
import 'package:week/utils/action_button.dart';
import 'package:week/utils/bottom_nav_bar_widget.dart';
import 'package:week/utils/expandable_fab.dart';
import 'dart:math';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({Key? key}) : super(key: key);

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  final columns = <String>['Type', 'Color', 'Season', 'Brand', 'Store', 'Date'];
  final columns2 = <String>[
    'Type',
    'Color',
    'Season',
    'Brand',
    'Store',
    'Date',
    'Reset'
  ];

  bool loading = true;

  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _conUserId = TextEditingController();
  String dropdownValue1 = 'Type';

  List<Clothing> items = [];
  List<Clothing> auxItems = [];
  List<Clothing> allItems = [];
  var dbHelper;

  var currUser;
  var pubPhoto;
  var pubUser;
  var randomPub;

  var map;

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
        allItems = res;
      });
    }
    var aux = {
      "Type": [],
      "Brand": [],
      "Season": [],
      "Store": [],
      "Color": [],
      "Date": []
    };
    var temp1 = [];
    var temp2 = [];
    var temp3 = [];
    var temp4 = [];
    var temp5 = [];
    var temp6 = [];
    for (var i = 0; i < res.length; i++) {
      debugPrint(res[i].clothType);
      temp1.add(res[i].clothType);
      temp2.add(res[i].brand);
      temp3.add(res[i].season);
      temp4.add(res[i].store);
      temp5.add(res[i].color);
      temp6.add(res[i].date);
    }
    aux["Type"] = temp1;
    aux["Brand"] = temp2;
    aux["Season"] = temp3;
    aux["Store"] = temp4;
    aux["Color"] = temp5;
    aux["Date"] = temp6;
    setState(() {
      loading = false;
      map = aux;
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

  List<DropdownMenuItem<String>> menuItems = [];
  bool disabledDropDown = true;

  void populate(String key) {
    for (var item in map[key]) {
      debugPrint(item);
      menuItems.add(DropdownMenuItem(
        child: Text(item),
        value: item,
      ));
    }
    menuItems.add(const DropdownMenuItem(
      child: Text('Reset'),
      value: 'Reset',
    ));
  }

  void valueChanged(_value) {
    menuItems = [];
    if (_value == 'Reset') {
      setState(() {
        dropdownValue1 = _value;
        if (auxItems.isNotEmpty) {
          items = auxItems;
        } else {
          items = allItems;
        }
      });
    } else {
      populate(_value.toString());
      setState(() {
        dropdownValue1 = _value;
        disabledDropDown = false;
      });
    }
  }

  void secondValueChanged(_value) {
    if (_value == 'Reset') {
      setState(() {
        dropdownValue1 = _value;
        disabledDropDown = true;
        if (auxItems.isNotEmpty) {
          items = auxItems;
        } else {
          items = allItems;
        }
      });
    } else {
      var temp = <Clothing>[];
      if (auxItems.isNotEmpty) {
        setState(() {
          items = auxItems;
        });
      } else {
        setState(() {
          items = allItems;
        });
      }

      for (var i = 0; i < items.length; i++) {
        var t = items[i].toMap();
        debugPrint(t.toString());
        var s;
        if (dropdownValue1 == "Type") {
          s = "clothType";
        } else if (dropdownValue1 == "Brand") {
          s = "brand";
        } else if (dropdownValue1 == "Season") {
          s = "season";
        } else if (dropdownValue1 == "Store") {
          s = "store";
        } else if (dropdownValue1 == "Color") {
          s = "color";
        } else if (dropdownValue1 == "Date") {
          s = "date";
        }
        if (t[s] == _value) {
          temp.add(items[i]);
        }
      }

      setState(() {
        auxItems = items;
        items = temp;
      });
    }
  }

  void randomOutfit() {
    var temp = <Clothing>[];
    var rng = Random();
    var index;
    for (var i = 0; i < 5; i++) {
      index = rng.nextInt(allItems.length);

      if (!temp.contains(allItems[index])) {
        temp.add(allItems[index]);
      }
    }

    setState(() {
      items = temp;
    });
  }

  void randomOutfitFromTable() {
    var temp = <Clothing>[];
    var rng = Random();
    var index = rng.nextInt(items.length);

    temp.add(items[index]);

    setState(() {
      items = temp;
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
        actions: [
          DropdownButton<String>(
            value: dropdownValue1,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (_value) => valueChanged(_value),
            items: columns2.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          DropdownButton<String>(
            hint: const Text('Select One'),
            disabledHint: const Text("Select Column"),
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: disabledDropDown
                ? null
                : (_value) => secondValueChanged(_value),
            items: menuItems,
          )
        ],
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
            onPressed: () {
              randomOutfit();
            },
            icon: const Icon(Icons.add_location),
          ),
          ActionButton(
            onPressed: () {
              randomOutfitFromTable();
            },
            icon: const Icon(Icons.cabin),
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
