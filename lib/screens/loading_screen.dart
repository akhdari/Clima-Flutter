import 'package:clima/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/weatherData.dart';
import 'package:clima/utilities/constants.dart';
import 'package:get/get.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLoading = false;
  late WeatherData weatherdata; // Made nullable
  late double latitude;
  late double longitude;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {
      FetchLocation fetchLocation = FetchLocation();
      await fetchLocation.fetchLocation();
      setState(() {
        latitude = fetchLocation.latitude;
        longitude = fetchLocation.longitude;
      });
      print('latitude: $latitude');
      print('longitude: $longitude');
      weatherdata = await fetchWeather(latitude, longitude);
    } catch (e) {
      print('error fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/city_background.jpg'),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: isLoading
              ? spinkit
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await loadWeather();
                    Get.toNamed('/location', arguments: {
                      'source': 'loading_screen',
                      'weatherdata': weatherdata,
                    });
                    setState(() {
                      isLoading =
                          false; 
                    });
                  },
                  child: Text('Get Location'),
                ),
        ),
      ),
    );
  }
}
