import 'package:geolocator/geolocator.dart';

class Location {
   late double latitude;
   late double longitude;

  // Fetches the current location with error handling
  Future<Map<String, double>> getLocation() async {
    try {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      latitude = position.latitude;
      longitude = position.longitude;

      return {
        'latitude': latitude,
        'longitude': longitude,
      };
    } catch (e) {
      throw Exception('Could not fetch location: $e');
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}

class FetchLocation {
  late double latitude;
  late double longitude;
  Future<void> fetchLocation() async {
    Location location = Location();
    var position = await location.getLocation();
    latitude = position['latitude']!;
    longitude = position['longitude']!;
  }
}
