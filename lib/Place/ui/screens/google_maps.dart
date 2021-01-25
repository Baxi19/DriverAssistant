import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';



class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  UserBloc userBloc;
  MapType mapType = MapType.normal;

  TextEditingController locationController = TextEditingController();
  TextEditingController actualLocationController = TextEditingController();

  LatLng destineLocation = LatLng(19.47134, -90.64351);
  LatLng actualLocation = LatLng(10.47134, -84.64351);

  GoogleMapController _mapController;
  bool searching = false;
  String header = "";

  /*
  final Set<Polyline> polyline = {};
  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline = new  GoogleMapPolyline(apiKey:  Secrets.API_KEY);

  getRoutePoints() async {
    var permission = await Permission.getPermissionsStatus([PermissionName.Location]);
    if(permission[0].permissionStatus == PermissionStatus.notAgain){
      var askPermission = await Permission.requestPermissions([PermissionName.Location]);
    }else {
      routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
          origin: actualLocation,
          destination: destineLocation,
          mode: RouteMode.driving
      );
    }
  }
*/

  @override
  void initState(){
    getUserLocation();
    super.initState();
    //getRoutePoints();

  }

  void getMoveCamera() async {
    showUserLocation();
    List<Placemark> placemark =  await Geolocator().placemarkFromCoordinates(destineLocation.latitude, destineLocation.longitude);
    locationController.text = placemark[0].name;
    setState(() {
      header = placemark[0].name.toString();
    });
  }

  void getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =  await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    destineLocation = LatLng(position.latitude, position.longitude);
    locationController.text = placemark[0].name;
    actualLocationController.text = placemark[0].name;
    _mapController.animateCamera(CameraUpdate.newLatLng(destineLocation));
  }

  void showUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =  await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    actualLocation = LatLng(position.latitude, position.longitude);
    actualLocationController.text = placemark[0].name;
  }

  void onCreated(GoogleMapController controller){
    _mapController = controller;
    /*setState(() {
      polyline.add(Polyline(
        polylineId: PolylineId('route1'),
        visible: true,
        points: routeCoords,
        width: 4,
        color: Colors.cyan,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap
      ));
    });*/
  }

  void onCameraMove(CameraPosition position) async {
    setState(() {
      //searching = false;
    });
    searching = false;
    destineLocation = position.target;
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: destineLocation, zoom: 15.86,
              ),
              mapType: mapType,
              //minMaxZoomPreference: MinMaxZoomPreference(10.5, 16.8),
              zoomControlsEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onCameraMove: onCameraMove,
              onMapCreated: onCreated,
              //polylines: polyline,
              onCameraIdle: () async {
                searching = true;
                setState(() {
                  getMoveCamera();
                });
              },
            ),
            Align(alignment: Alignment.center,
              child: Image.asset(
                  "assets/img/destination.png",
                  height: 80
              ),
            ),
            searching == true
            ? Positioned(
            //top: MediaQuery.of(context).size.height / 2.8,
            top: ((MediaQuery.of(context).size.height / 2)-140),
            //left: MediaQuery.of(context).size.width / 3.62,
            left: ((MediaQuery.of(context).size.width /2 )-100),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.black.withOpacity(0.75),
              ),
              width: 200,
              height: 40,
              child: Center(
                child: Text("${header}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13
                  ),
                ),
              ),
            ),)
            :
            Positioned(
              top: ((MediaQuery.of(context).size.height / 2)-140),
              left: ((MediaQuery.of(context).size.width /2 )-25),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.black.withOpacity(0.75),
                ),
                width: 50,
                height: 40,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ),
            Positioned(
                top: 10,
                //top:  ((MediaQuery.of(context).size.height / 4) * 2) + 30,
                right: 10,
                child: FloatingActionButton(
                  onPressed: getUserLocation,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.gps_fixed,
                    color: Color(0xFF584CD1),
                    size: 32,
                  ),
                ),
            ),
            Positioned(
              bottom: 0,
              //right: MediaQuery.of(context).size.width / 40,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color(0xFF4268D3),
                          Color(0xFF584CD1)
                        ],
                        begin: FractionalOffset(0.2, 0.0),
                        end: FractionalOffset(1.0, 0.6),
                        stops: [0.0,0.6],
                        tileMode: TileMode.clamp
                    ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width - 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        //height: 38.0,
                        height: ((MediaQuery.of(context).size.height / 4)/4),
                        child: TextField(
                          enabled: false,
                          controller: actualLocationController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.gps_fixed_outlined, color: Colors.white,),
                            hintText: "Your Location",
                            hintStyle: TextStyle(
                              //color: Colors.black26,
                              color: Colors.white,
                              fontSize: 14.5,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),Container(
                        //height: 38.0,
                        height: ((MediaQuery.of(context).size.height / 4)/4),
                        child: TextField(
                          enabled: false,
                          controller: locationController,
                          decoration: InputDecoration(
                            //icon: Icon(Icons.drive_eta_outlined, color: Colors.white,),
                            icon: Icon(Icons.location_on, color: Colors.white,),
                            hintText: "Picture Location",
                            hintStyle: TextStyle(
                              //color: Colors.black26,
                              color: Colors.white,
                              fontSize: 14.5,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text("Save Location",
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.white,
                            ),
                          ),
                          color: Color(0xFF584CD1),
                           onPressed: (){
                              Navigator.pop(context, destineLocation);
                           },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
