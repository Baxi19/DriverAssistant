import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchTrips extends StatefulWidget {
  @override
  _SearchTripsState createState() => _SearchTripsState();
}

class _SearchTripsState extends State<SearchTrips> {
  GoogleMapController _controller;

  final CameraPosition _initialPosition = CameraPosition(target: LatLng(10.365885,-84.511857), zoom: 15);
  final List<Marker> markers = [];

  addMarker(cordinate){
    int id = Random().nextInt(100);
    setState(() {
      markers.add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              onMapCreated: (controller){
                setState(() {
                  _controller = controller;
                });
              },
              markers: markers.toSet(),
              onTap: (cordinate){
                _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
                addMarker(cordinate);
              },
            ),
            Align(alignment: Alignment.center,
              child: Image.asset("assets/img/user.png", height: 50),
            )
          ],
        ),
      ),
      
    );
  }
}
