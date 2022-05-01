import 'package:flutter/material.dart';
import 'package:week/Screens/scanqr.dart';

import 'createqr.dart';


class qrScreen extends StatefulWidget {
  const qrScreen({Key? key}) : super(key: key);

  @override
  State<qrScreen> createState() => _qrScreen();
}

class _qrScreen extends State<qrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 100, 6, 113),
        title: Text('Qr Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                print("tapped on create QR button.");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => CreateScreen(),
                  ),
                );
              },
              child: Text("Generate QR"),
            ),
            ElevatedButton(
              onPressed: () {
                print("tapped on scan QR button.");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ScanScreen(),
                  ),
                );
              },
              child: Text("Scan QR"),
            ),
          ],
        ),
      ),
    );
  }
}