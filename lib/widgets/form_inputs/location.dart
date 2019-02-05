import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_training/models/location_data.dart';
import 'package:flutter_training/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:map_view/map_view.dart';
import 'package:location/location.dart' as geolocation;


class LocationInput extends StatefulWidget {

  final Product product;
  final Function setLocation;

  LocationInput(this.product, this.setLocation);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

  GoogleMapController _mapController;
  LocationData _locationData;

  TextEditingController _addressInputController = TextEditingController();
  final FocusNode _addressInputFocusNode = FocusNode();

  final String mapKey = "AIzaSyCOtid3XsnFaN3hGD7sQytFACLjiNAE5bo";
  final String mapUrl = 'maps.googleapis.com';
  final String mapPath = '/maps/api/geocode/json';


  @override
  void initState() {

//    _addressInputFocusNode.addListener(_updateLocation);
    _addressInputController.addListener(_updateLocation);

    if(widget.product != null){
      _getMap(widget.product.location.address, geocode: false);
    }

    super.initState();
  }


  @override
  void dispose() {
//    _addressInputFocusNode.removeListener(_updateLocation);
    _addressInputController.removeListener(_updateLocation);
    super.dispose();
  }



  Future<String> _getAddress(double lat, double lng) async {

    final Uri mapUri = Uri.https(
      mapUrl,
        mapPath,
      {
        'latlng': '${lat.toString()},${lng.toString()}', 'key': mapKey
      }
    );

    http.Response response = await http.get(mapUri);
    final decodedResponse = json.decode(response.body);
    print("decodedResponse $decodedResponse");

    final formattedAddress = decodedResponse['result'][0]['formattedAddress'];
    return formattedAddress;
  }



  void _getUserLocation() async {

    final location = geolocation.Location();
    final currentLocation = await location.getLocation();
    print("currentLocation $currentLocation");

    final address = await _getAddress(currentLocation['latitude'], currentLocation['longitude']);
    _getMap(address, geocode: false, lat: currentLocation['latitude'], lng: currentLocation['longitude']);
  }



  void _updateLocation(){
    if(!_addressInputFocusNode.hasFocus){
      _getMap(_addressInputController.text);
    }
  }



  void _getMap(String address, {bool geocode = true, double lat, double lng}) async {

    if(address.isEmpty){
      setState(() {
        _addressInputController.text = null;
      });
      widget.setLocation(null);
      return;
    }

//    if(lat == null && lng == null){
    if(geocode){

      final Uri mapUri = Uri.https(
        mapUrl,
        mapPath,
        {
          'address': address, 'key': mapKey
        }
      );


      final http.Response response = await http.get(mapUri);
      final decodedResponse = json.decode(response.body);
      print("decodedResponse $decodedResponse");

      final formattedAddress = decodedResponse['results'][0]['formatted_address'];
      final Map<String, dynamic> coordinates = decodedResponse['results'][0]['geometry']['location'];

      _locationData = LocationData(
        address: formattedAddress,
        latitude: coordinates['lat'],
        longitude: coordinates['lng']
      );
    }

    else if (lat == null && lng == null){
//      _locationData = LocationData(address: address, latitude: lat, longitude: lng);
      _locationData = widget.product.location;
    }
    else{
       _locationData = LocationData(address: address, latitude: lat, longitude: lng);

    }

    widget.setLocation(_locationData);

    if(mounted){
      setState(() {
        _addressInputController.text = _locationData.address;
      });

      try{
        _mapController.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _locationData.latitude,
              _locationData.longitude
            ),
            zoom: 16.5
          )
        ));

        _mapController.addMarker(
          MarkerOptions(
            position: LatLng(
              _locationData.latitude,
              _locationData.longitude
            )
          )
        );
      }
      catch (NoSuchMethodError){
        print('NoSuchMethodError');
      }
    }
  }



  void _onMapCreated(GoogleMapController controller){
    _mapController = controller;
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
//          focusNode: _addressInputFocusNode,
          controller: _addressInputController,
          decoration: InputDecoration(
            labelText: 'Address'
          ),
          validator: (String value){
            if(_locationData == null || value.isEmpty){
              return 'No valid location found.';
            }
          },
        ),
        FlatButton(
          child: Text('Locate user'),
          onPressed: _getUserLocation,
        ),
        SizedBox(height: 10,),
        widget.product != null || _addressInputController.text.isNotEmpty
          ? SizedBox(
            width: 500,
            height: 300,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: LatLng(41.40338, 2.17403)),
              mapType: MapType.hybrid,
            ),
          )
          : Container()
      ],
    );
  }
}
