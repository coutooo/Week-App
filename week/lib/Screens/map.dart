import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class mapScreen extends StatefulWidget {
  mapScreen({Key? key}) : super(key: key);

  @override
  State<mapScreen> createState() => _mapScreenState();
}

class _mapScreenState extends State<mapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text('Maps')),
      body: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(40.64427,-8.64554),
          minZoom: 10.0
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            attributionBuilder: (_) {
              return Text("© OpenStreetMap contributors");
        },
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 45.0,
                height: 45.0,
                point: new LatLng(40.64427,-8.64554),
                builder: (context) => new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45.0,
                    onPressed: () {
                      print('Marker tapped');  
                    },
                  ),
                ),
              )
            ]
          ),
        ],
      ),
    );
  }
}