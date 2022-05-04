import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import 'package:week/Comm/comHelper.dart';
import 'package:week/Comm/genLoginSignupHeader.dart';
import 'package:week/Comm/genTextFormField.dart';
import 'package:week/Screens/notificationService.dart';
import 'package:week/Screens/postScreen.dart';
import 'package:week/models/posts_model.dart';
import 'package:week/screens/SignupForm.dart';
import 'package:week/models/UserModel.dart';
import '../DatabaseHandler/DbHelper.dart';
import 'feed.dart';
import 'dart:async';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final _formKey = GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();

  var dbHelper;
  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.instance;
    tz.initializeTimeZones();
  }

  login() async {
    String uid = _conUserId.text;
    String passwd = _conPassword.text;

    if (uid.isEmpty) {
      alertDialog(context, "Please Enter User ID");
    } else if (passwd.isEmpty) {
      alertDialog(context, "Please Enter Password");
    } else {
      await dbHelper.getLoginUser(uid, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            sendNotification();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => FeedPage()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Error: User Not Found");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  void sendNotification() async {
    var weather = (await getWeather()).toString();
    var res = await dbHelper.getClothingBySeason(weather);

    if (res != null) {
      Publication public = res;

      var idP = public.photoId;
      var idPP = public.user_id;

      Photo pho = await dbHelper.getPhoto(idP);

      var UserI = await dbHelper.getUserInfo(idPP);
      var UserII = await dbHelper.getUserInfo(_conUserId.text);
/*
     Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PostScreen(
                            user: UserI,
                            pub: public,
                            photo: pho,
                            currentUser: UserII)));
                            */

      NotificationService().showNotification(1, weather, "body", 6);
    }
  }

  Future<String> getWeather() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lat = position.latitude;
    var long = position.longitude;

    String key = '1387528fe461abcf9e77dbd8fdf23b68';
    WeatherFactory wf = WeatherFactory(key);

    Weather w = await wf.currentWeatherByLocation(lat, long);

    double? celsius = w.temperature?.celsius;

    String? weattherr = w.weatherDescription.toString().toLowerCase();

    print("AAAAAAAAAAAAAAAAAAAAAAa" + w.toString());
    print(weattherr.toString());
    print(celsius.toString());

    if (weattherr.contains("Thunderstorm")) {
      return "Winter";
    } else if (weattherr.contains("drizzle")) {
      return "Winter";
    } else if (weattherr.contains("drizzle")) {
      return "Winter";
    } else if (weattherr.contains("rain")) {
      return "Winter";
    } else if (weattherr.contains("snow")) {
      return "Winter";
    } else {
      if (celsius! > 20) {
        return "Summer";
      } else if (15 < celsius && celsius > 20) {
        return "Spring";
      } else if (10 < celsius && celsius < 15) {
        return "Autumn";
      } else if (celsius < 10) {
        return "Winter";
      }
    }
    return "No recommendations today!";
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("user_id", user.user_id);
    sp.setString("user_name", user.user_name);
    sp.setString("email", user.email);
    sp.setString("password", user.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 100, 6, 113),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                genLoginSignupHeader('Login'),
                genTextFormField(_conUserId, 'User ID', Icons.person, false,
                    TextInputType.text, false),
                const SizedBox(height: 10.0),
                genTextFormField(_conPassword, 'Password', Icons.lock, true,
                    TextInputType.text, false),
                Container(
                  margin: const EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: TextButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: login,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 100, 6, 113),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? '),
                    TextButton(
                      child: const Text(
                        'Signup',
                        style:
                            TextStyle(color: Color.fromARGB(255, 100, 6, 113)),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SignupForm()));
                      },
                    ),
                    /*
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                          },
                          child: const Text('Profile')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FeedPage()));
                          },
                          child: const Text('Feed'))*/
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
