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
      appBar: new AppBar(title: new Text('Maps'),
      backgroundColor: Color.fromARGB(255, 100, 6, 113),
      ),
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
              // Aveiro In
              new Marker(
                width: 45.0,
                height: 45.0,
                point: new LatLng(40.64366757852991, -8.652807819262454),
                builder: (context) => new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.purple,
                    iconSize: 35.0,
                    onPressed: () {
                      print('Aveiro In'); 
                      _onButtonPressed('Aveiro In'); 
                    },
                  ),
                ),
              ),
              // the north face aveiro
              new Marker(
                width: 45.0,
                height: 45.0,
                point: new LatLng(40.64006292784546, -8.649616391615382),
                builder: (context) => new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.purple,
                    iconSize: 35.0,
                    onPressed: () {
                      print('the north face aveiro');
                      _onButtonPressed('The North Face Aveiro');  
                    },
                  ),
                ),
              ),
              // Lefties
              new Marker(
                width: 45.0,
                height: 45.0,
                point: new LatLng(40.642806116240486, -8.64720790497876),
                builder: (context) => new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.purple,
                    iconSize: 35.0,
                    onPressed: () {
                      print('Lefties');
                      _onButtonPressed('Lefties');
                    },
                  ),
                ),
                
              ),
              
              // Ana Sousa
              new Marker(
                width: 45.0,
                height: 45.0,
                point: new LatLng(40.6421339222342, -8.649997402499066),
                builder: (context) => new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.purple,
                    iconSize: 35.0,
                    onPressed: () {
                      print('Ana Sousa');  
                      _onButtonPressed('Ana Sousa');
                    },
                  ),
                ),
              ),
              // Quebra Mar Forum Aveiro
              new Marker(
                width: 45.0,
                height: 45.0,
                point: new LatLng(40.64113153256018, -8.651569071310467),
                builder: (context) => new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.purple,
                    iconSize: 35.0,
                    onPressed: () {
                      print('Quebra Mar Forum Aveiro');
                      _onButtonPressed('Quebra Mar Forum Aveiro');  
                    },
                  ),
                ),
              ),
              // XTREME - OITA
              new Marker(
                width: 45.0,
                height: 45.0,
                point: new LatLng(40.642581934017045, -8.647033780725312),
                builder: (context) => new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.purple,
                    iconSize: 30.0,
                    onPressed: () {
                      print('XTREME - OITA');  
                      _onButtonPressed('XTREME - OITA');
                    },
                  ),
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }


void _onButtonPressed(String text) {
  showModalBottomSheet(
    context: context, 
    builder: (context) {
      return Container(
        color: Color(0xFF737373),
        child: Container(
          height: 60,
          child: _buildBottomNavigationMenu(text),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            )
          ),
        ),
      );
    });
}

Column _buildBottomNavigationMenu(String text) {
  return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.add_business_sharp),
          title: Text(text),
        ),
      ],
    );
}
}