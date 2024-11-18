import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; //works with latitude and longitude
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

@override
Widget build(BuildContext context) {
  return MyMap();
}

class MyMap extends StatefulWidget {
  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  var latitude = 0.0;
  var longitude = 0.0;
  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    if (arguments != null) {
      try {
        print('arguments not null');
        print('arguments: $arguments');
        latitude = arguments['latitude'];
        longitude = arguments['longitude'];
        print('latitude:' + arguments['latitude']);
        print('longitude:' + arguments['longitude']);
      } catch (e) {
        print(e);
      }
    } else {
      print('argument is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        //flutter map
        FlutterMap(
          //MarkerLayerOptions(markers: []),
          options: MapOptions(
            initialCenter: LatLng(latitude,
                longitude), // Center the map over the current location
            initialZoom: 9.2,
          ),

          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png', 
              userAgentPackageName: 'com.example.app',
            ),
            //Tile Layer
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(latitude, longitude),
                  child: Icon(
                    Icons.location_on,size: 35,color: Colors.red,),
                )
              ],
            ),

            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(Uri.parse(
                      'https://openstreetmap.org/copyright')), 
                ),
              ],
            ),
            //
          ], //children
        ),
        //
        Positioned(
          top: 10,
          right: 10,
          child: TextButton(
            onPressed: () {
              Get.toNamed('/LoadingScreen');
            },
            child: Icon(
              Icons.arrow_forward_ios,
              size: 50.0,
            ),
          ),
        ),
      ]),
    );
  }
}
