import 'package:clima/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/services/weatherData.dart';
import 'package:get/get.dart';

class Properties {
  RxInt condition = 0.obs;
  RxInt msg = 0.obs;
  RxString temp = ''.obs;
  RxString city = ''.obs;
  RxDouble lat = 0.0.obs;
  RxDouble lon = 0.0.obs;
}

class PropertiesController extends GetxController {
  var properties = Properties(); // object creation
  void updateProperties(WeatherData weatherdata) {
    properties.condition.value = weatherdata.weather[0].id;
    properties.msg.value = weatherdata.main.temp.toInt();
    properties.temp.value = weatherdata.main.temp.toString();
    properties.city.value = weatherdata.name;
    properties.lat.value = weatherdata.coord.lat.toDouble();
    properties.lon.value = weatherdata.coord.lon.toDouble();
  }
}

//appInitializer
/*class AppInitializer {
  static void init() {
    Get.put(PropertiesController());
  }
}*/
class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final PropertiesController propertiesController =
      Get.put(PropertiesController());
  late Map<String, dynamic> weatherdata;
  late WeatherData weatherDataNew;
  String? cityName;
  late WeatherModel weather;

  @override
  initState() {
    super.initState();
    weather = WeatherModel();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final arguments = Get.arguments['weatherdata'];
      weatherDataNew = arguments;
      propertiesController.updateProperties(weatherDataNew);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/map', arguments: {
                        'latitude': propertiesController.properties.lat.value,
                        'longitude': propertiesController.properties.lon.value
                      });
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/city')?.then((result) async {
                        if (result != null && result is Map<String, dynamic>) {
                          cityName = result['cityName'];
                          print(cityName);
                          try {
                            var argumentsCityScreen =
                                await fetchWeatherCity(cityName);
                            setState(() {
                              weatherDataNew = argumentsCityScreen;
                            });
                            propertiesController
                                .updateProperties(argumentsCityScreen);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Error fetching weather data'),
                            ));
                            throw Exception('Error fetching weather data: $e');
                          }
                          ;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('result is null'),
                          ));
                          throw Exception('result is null');
                        }
                      });
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    //temp

                    Obx(
                      () => Text(
                        propertiesController.properties.temp.value + '°',
                        style: kTempTextStyle,
                      ),
                    ),
                    Obx(
                      () => Text(
                        weather.getWeatherIcon(
                            propertiesController.properties.condition.value),
                        style: kConditionTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Obx(
                  () => Text(
                    weather.getMessage(
                            propertiesController.properties.msg.value) +
                        ' in ' +
                        propertiesController.properties.city.value,
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
