import 'package:driver_assistant/AI/bloc/singleton.dart';
import 'package:driver_assistant/Place/repository/networking.dart';
import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Map extends StatefulWidget {
  final LatLng destineLocation;
  Map({Key key, @required this.destineLocation});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  var mapType = MapType.normal;
  UserBloc userBloc;

  changeMapType(){
    if(mapType == MapType.hybrid){
      setState(() {
        mapType = MapType.satellite;
      });
    }else if(mapType == MapType.satellite){
      setState(() {
        mapType = MapType.normal;
      });
    }else if(mapType == MapType.normal){
      setState(() {
        mapType = MapType.terrain;
      });
    }else if(mapType == MapType.terrain){
      setState(() {
        mapType = MapType.hybrid;
      });
    }
  }

  GoogleMapController mapController;

  final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  var data;

  LatLng _actualLocation = LatLng(10.361549177929692, -84.50968244515698);
  LatLng _destineLocation = LatLng(10.472303367455607, -84.64510908165832);


  void _onMapCreated(GoogleMapController controller) {
    _destineLocation = widget.destineLocation;
    mapController = controller;
    setMarkers();
  }

  setMarkers() {
    if(Singleton().allPlacesList.isNotEmpty){
      for(int i =0; i < Singleton().allPlacesList.length; i++){
        markers.add(
          Marker(
            markerId: MarkerId(i.toString()),
            position: LatLng(Singleton().allPlacesList[i].lat, Singleton().allPlacesList[i].lon),
            infoWindow: InfoWindow(
              title: Singleton().allPlacesList[i].name,
              snippet: Singleton().allPlacesList[i].description,
            ),
            //TODO: create onTap
          ),
        );
      }
      setState(() {});
    }else{

      markers.add(
        Marker(
          markerId: MarkerId("Home"),
          position: _actualLocation,
          infoWindow: InfoWindow(
            title: "Home",
            snippet: "Home Sweet Home",
          ),

        ),
      );

      /*
      markers.add(Marker(
        markerId: MarkerId("Destination"),
        position: _destineLocation,
        infoWindow: InfoWindow(
          title: "Fortuna",
          snippet: "5 star ratted place",
        ),
      ));
      setState(() {});
       */
    }
  }

  void getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format
    NetworkHelper network = NetworkHelper(
      startLat: _actualLocation.latitude,
      startLng: _actualLocation.longitude,
      endLat: _destineLocation.latitude,
      endLng: _destineLocation.longitude,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      // We can reach to our desired JSON data manually as following
      LineString ls =
      LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }
    } catch (e) {
      print(e);
    }
  }

  setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      //color: Colors.lightBlue,
      color: Color(0xFF584CD1),
      points: polyPoints,
    );
    polyLines.add(polyline);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getJsonData();
  }

  void updateActualPosition()async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _actualLocation = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(_actualLocation));
  }

  void getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng destineLocation = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(destineLocation));
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    updateActualPosition();
    Widget myMap(){
      return Scaffold(
        body: SafeArea(
          child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _actualLocation,
                    zoom: 15,
                  ),
                  markers: markers,
                  polylines: polyLines,
                  mapType: mapType,
                ),

                Positioned(
                  top: 10,
                  //top:  ((MediaQuery.of(context).size.height / 4) * 2) + 30,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: getUserLocation,
                    //mini: true,
                    //backgroundColor: Colors.white,
                    backgroundColor: Color(0xFF11DA53),
                    child: Icon(
                      Icons.gps_fixed,
                      //color: Color(0xFF584CD1),
                      size: 32,
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  //top:  ((MediaQuery.of(context).size.height / 4) * 2) + 30,
                  right: 10,
                  child: FloatingActionButton(
                    //mini: true,
                    onPressed: changeMapType,
                    //backgroundColor: Colors.white,
                    backgroundColor: Color(0xFF11DA53),
                    child: Icon(
                      Icons.map,
                      //color: Color(0xFF584CD1),
                      size: 32,
                    ),
                  ),
                ),
              ]
          ),
        ),
      );
    }

    //TODO: Check values
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: userBloc.placesStream,
        builder: (context, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return  Center(
                  child: CircularProgressIndicator()
              );
            default:
              //TODO: make better vars, also make a fx() if is necesary
              var data = userBloc.buildPlaces(snapshot.data.documents, context, userBloc.user, (){});
              return myMap();
          }
        }
      ),
    );
  }
}

//Create a new class to hold the Co-ordinates we've received from the response data
class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}