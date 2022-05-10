import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week/DatabaseHandler/DbHelper.dart';
import 'package:week/Screens/visiting_profile.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}


class _CreateScreenState extends State<CreateScreen> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  var dbHelper;

  String qrString = "wait";

  String scanned = "wait";

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
          ElevatedButton(
              onPressed: () {
                //print("tapped on scan QR button.");
                scanQR();
                /*Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ScanScreen(),
                  ),
                );*/
              },
              style: ElevatedButton.styleFrom(
              primary: Colors.purple, // Background color
              onPrimary: Colors.white, // Text Color (Foreground color)
            ),
              child: Text("Scan QR"),
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
  Future<void> scanQR() async {
    //print("entrei");
    try {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                  "#6a0dad", 
                                                  "Cancel", 
                                                  true, 
                                                  ScanMode.QR);
    //FlutterBarcodeScanner.scanBarcode("#2A99CF", "Cancel", true, ScanMode.QR)
    //    .then((value) {
    //print(barcodeScanRes);
    setState(() {
      scanned = barcodeScanRes;
      getUserScannedData();
    });
     // });
    } catch (e) {
      setState(() {
        //print("ja bateste");  
        scanned = "unable to read the qr";
      });
    }
  }

  Future<void> getUserScannedData() async {
    final SharedPreferences sp = await _pref;
    final res = await dbHelper.getUserInfo(scanned);
    if (res != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) =>
                  VisitingProfile(idVisiting: qrString, user: res))));
    }
  }
}