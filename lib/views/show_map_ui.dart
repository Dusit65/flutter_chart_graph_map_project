// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, avoid_unnecessary_containers, sized_box_for_whitespace, unused_element, avoid_print, must_call_super, annotate_overrides, unnecessary_new, prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ShowMapUI extends StatefulWidget {
  const ShowMapUI({super.key});

  @override
  State<ShowMapUI> createState() => _ShowMapUiState();
}

class _ShowMapUiState extends State<ShowMapUI> {
  // double lat = 15.5770928;
  // double lng = 100.1246566;

  bool _isNormalMap = true;
  LatLng? newPosition;
  LatLng? initPosition = LatLng(15.5770928, 100.1246566);
  void _toggleMapType() {
    setState(() {
      _isNormalMap = !_isNormalMap;
    });
  }
   //ตัวแปรเก็บ Marker
  Marker? marker;

  //Method change marker
  // changeMarker(LatLng position) {
  //   setState(() {
  //     Marker(
  //       width: 80,
  //       height: 80,
  //       point: position,
  //       child: Icon(
  //         Icons.location_on,
  //         color: Colors.red,
  //         size: 40,
  //       ),
  //     );
  //   });
  // }

  // method ดึงตําแหน่งปัจจุบัน
  void getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        initPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }
  //Move Map
  MapController mapController = new MapController();

 Future<void> _animateMapMove(LatLng destLocation, double destZoom) async {
    final startLat = 13.7076197;
    final startLng = 100.3569401;
    final startZoom = 15.0;

    final latDelta = (destLocation.latitude - startLat) / 50;
    final lngDelta = (destLocation.longitude - startLng) / 50;
    final zoomDelta = (destZoom - startZoom) / 50;

    for(int i = 1; i <= 50; i++) {
      final nextLat  = startLat + latDelta * i;
      final nextLng  = startLng + lngDelta * i;
      final nextZoom = startZoom + zoomDelta * i;

      mapController.move(LatLng(nextLat, nextLng), nextZoom);
      await Future.delayed(Duration(milliseconds: 20));
    }
  }

//=====================================================================================================
  @override
 void initState() {
   getCurrentLocation();
   super.initState();
 }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            "Show Map UI",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: newPosition == null ? initPosition! : newPosition!,
                initialZoom: 13.0,
                onLongPress: (tapPosition, point) {
                  setState(() {
                    newPosition = point;
                    _animateMapMove(point,15);
                    // changeMarker(point);
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: _isNormalMap
                      ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                      : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: newPosition == null 
                      ? initPosition! 
                      : newPosition!,
                      radius: 500,
                      useRadiusInMeter: true,
                      color: Colors.blue.withOpacity(0.5),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                         Marker(
                            width: 80,
                            height: 80,
                            point: newPosition == null 
                            ? initPosition! 
                            : newPosition!,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          )
                    //35.36153410828155, 138.7275515282281
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 10.0, // Positioned at the bottom
              right: 10.0, // Positioned at the right
              child: FloatingActionButton(
                onPressed: _toggleMapType,
                child: Icon(Icons.map),
              ),
            ),
          ],
        ));
  }
}
