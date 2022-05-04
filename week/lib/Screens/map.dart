import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';


class mapScreen extends StatefulWidget {
  mapScreen({Key? key}) : super(key: key);

  @override
  State<mapScreen> createState() => _mapScreenState();
}

class _mapScreenState extends State<mapScreen> {


  var latitudee;
  var longitudee;
  bool loading = true;

  
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }


  void getCurrentLocation() async {


    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;

    print(lat.toString()+":::::"+long.toString());

    setState(() {
      latitudee = lat;
      longitudee = long;
      loading = false;
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title:  Text('Maps'),
      backgroundColor: Color.fromARGB(255, 100, 6, 113),
      ),
      body: loading ? Center(child: CircularProgressIndicator(),):
          FlutterMap(
        options:  MapOptions(
          center:  LatLng(latitudee,longitudee),
          minZoom: 10.0
        ),
        layers: [
           TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            attributionBuilder: (_) {
              return Text("© OpenStreetMap contributors");
        },
          ),
           MarkerLayerOptions(
            markers: [
              // Aveiro In
               Marker(
                width: 45.0,
                height: 45.0,
                point: LatLng(40.64366757852991, -8.652807819262454),
                builder: (context) => Container(
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
              Marker(
                width: 45.0,
                height: 45.0,
                point: LatLng(40.64006292784546, -8.649616391615382),
                builder: (context) => Container(
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
              Marker(
                width: 45.0,
                height: 45.0,
                point: LatLng(40.642806116240486, -8.64720790497876),
                builder: (context) => Container(
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
              Marker(
                width: 45.0,
                height: 45.0,
                point: LatLng(40.64236578487401, -8.650131417273986),
                builder: (context) => Container(
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
              Marker(
                width: 45.0,
                height: 45.0,
                point: LatLng(40.64113153256018, -8.651569071310467),
                builder: (context) => Container(
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
              Marker(
                width: 45.0,
                height: 45.0,
                point: LatLng(40.642581934017045, -8.647033780725312),
                builder: (context) => Container(
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