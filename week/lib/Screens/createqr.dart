import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}


class _CreateScreenState extends State<CreateScreen> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  var dbHelper;

  String qrString = "wait";

  @override
  void initState() {
    super.initState();
    getUserData();

    dbHelper = DbHelper.instance;
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      qrString = sp.getString("user_id")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 100, 6, 113),
        title: Text("Generate QR Code"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // qr code
          BarcodeWidget(
            color: Colors.purple,
            data: qrString,
            height: 250,
            width: 250,
            barcode: Barcode.qrCode(),
          ),
          // link
          /*  usava para gerar outros qrs consoante o q a pessoa queria
          Container(
            width: MediaQuery.of(context).size.width * .8,
            child: TextField(
              onChanged: (val) {
                setState(() {
                  qrString = val;
                });
              },
              decoration: InputDecoration(
                hintText: "Enter you data here",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          */
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}