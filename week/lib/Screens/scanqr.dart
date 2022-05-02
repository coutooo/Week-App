import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/Screens/visiting_profile.dart';

import '../DatabaseHandler/DbHelper.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  String qrString = "Not Scanned";
  var stories;

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 100, 6, 113),
        title: Text("Scan QR Code"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            qrString,
            style: TextStyle(color: Colors.purple, fontSize: 30),
          ),
          ElevatedButton(
            onPressed: scanQR,
            style: ElevatedButton.styleFrom(
              primary: Colors.purple, // Background color
              onPrimary: Colors.white, // Text Color (Foreground color)
            ),
            child: Text("Scan QR Code"),
          ),
          SizedBox(width: width),
          ElevatedButton(
            onPressed: getUserScannedData,
            style: ElevatedButton.styleFrom(
              primary: Colors.purple, // Background color
              onPrimary: Colors.white, // Text Color (Foreground color)
            ),
            child: Text("Visit Profile"),
          ),
        ],
      ),
    );
  }

  Future<void> scanQR() async {
    try {
      FlutterBarcodeScanner.scanBarcode("#2A99CF", "Cancel", true, ScanMode.QR)
          .then((value) {
        setState(() {
          qrString = value;
        });
      });
    } catch (e) {
      setState(() {
        qrString = "unable to read the qr";
      });
    }
  }

  Future<void> getUserScannedData() async {
    final SharedPreferences sp = await _pref;
    final res = await dbHelper.getUserInfo(qrString);
    if (res != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) =>
                  VisitingProfile(idVisiting: qrString, user: res))));
    }
  }
}
