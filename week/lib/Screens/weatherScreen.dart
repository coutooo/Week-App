import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';



// key    1387528fe461abcf9e77dbd8fdf23b68

class weatherScreen extends StatefulWidget {
  weatherScreen({Key? key}) : super(key: key);

  @override
  State<weatherScreen> createState() => _weatherScreenState();
}

class _weatherScreenState extends State<weatherScreen> {


  var latitudee;
  var longitudee;

  
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
      getWeather(latitudee,longitudee);
    });
}
  void getWeather(lat,lon) async {
    //double lat = latitudee;
    //double lon = longitudee;
    String key = '1387528fe461abcf9e77dbd8fdf23b68';
    //String cityName = 'Kongens Lyngby';
    WeatherFactory wf = WeatherFactory(key);

    Weather w = await wf.currentWeatherByLocation(lat, lon);

    double? celsius = w.temperature?.celsius;

    String? weattherr = w.weatherDescription;
    
    print("AAAAAAAAAAAAAAAAAAAAAAa"+w.toString());
    print(weattherr.toString());
    print(celsius.toString());
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}