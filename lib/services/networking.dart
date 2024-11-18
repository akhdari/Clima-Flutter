import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:clima/services/weatherData.dart';

const apiKey = 'f4c55b6165dc0e840333054a3a638034';
const String openWeatherMapURL =
    'https://api.openweathermap.org/data/2.5/weather';

class Networking {
  final String url;
  Networking(this.url);
  Future getData() async {
    try {
      final response = await http.get(Uri.parse(url));
      print('API response: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('API response body: ${response.body}');
        try {
          Map<String, dynamic> data = json.decode(response.body);
          print('JSON data: $data');
          return WeatherData.fromJson(data);
        } catch (e) {
          print('Error parsing JSON: $e');
          throw Exception('Failed to parse weather data');
        }
      } else {
        print('API request failed with status code ${response.statusCode}');
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      //catch any other enexcepted errors
      print('Error fetching data: $e');
      throw Exception('Error fetching weather data: $e');
    }
  }
}

Future<WeatherData> fetchWeather(double latitude, double longitude) async {
  Networking networking = Networking(
      '$openWeatherMapURL?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
  return await networking.getData();
}

Future<WeatherData> fetchWeatherCity(String? city) async {
  Networking networking = Networking(
      '$openWeatherMapURL?q=$city&appid=$apiKey&units=metric');
  return await networking.getData();
}
