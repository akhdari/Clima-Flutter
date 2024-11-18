import 'package:flutter/material.dart';
import 'package:clima/screens/loading_screen.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:clima/screens/map.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/LoadingScreen',
      getPages: [
        GetPage(name: '/location', page: () => LocationScreen()),
        GetPage(name: '/map', page: () => MyMap()),
        GetPage(name: '/city', page: () => CityScreen()),
        GetPage(
            name: '/LoadingScreen',
            page: () => LoadingScreen()), // Include LoadingScreen
      ],
      theme: ThemeData.dark(),
    );
  }
}
