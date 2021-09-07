

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';



import 'dart:math' show Random, asin, cos, sqrt;

import 'package:http/http.dart' as http;
import 'package:latlng/latlng.dart';
import 'secrets.dart';

class MapProvider with ChangeNotifier{


  late String _departureAdress;
  late String _arrivalAdress;
  get departureAdress =>  _departureAdress;
  get arrivalAdress   =>  _arrivalAdress;

  String setTextAdress(String adress, String type ){
    if(type == 'start'){
      _departureAdress= adress;
    }else{
      _arrivalAdress = adress;
    }
    return adress;
  }


  late LatLng _departurePosition;
  late LatLng _arrivalPosition;
  get departurePosition =>  _departurePosition;
  get arrivalPosition   =>  _arrivalPosition;

  List<LatLng> polylineCoordinates     = [];
  Map<String, LatLng> _checkpointsList = {};

  // List<String> _intermediateStations     = [];
  // get intermediateStations   =>  _intermediateStations;

  Map<String, LatLng>   get checkpointsList   => _checkpointsList;


  List<Map<String, LatLng>> _middleList = [];
  get middleList   => _middleList;

//------------------------------------------- this part including autoText Complete -----------------------------
  Future<List<Suggestion>> fetchSuggestions(String input, String lang, String sessionToken ) async {

    final String androidKey = Secrets.API_KEY;
    final String iosKey = 'YOUR_API_KEY_HERE';
    final apiKey = Platform.isAndroid ? androidKey : iosKey;

    // final request =
    //     'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:ch&key=$apiKey&sessiontoken=$sessionToken';

    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&offset=3&key=$apiKey&sessiontoken=$sessionToken';

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        print(result['predictions']);
        notifyListeners();
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<LatLng> getPlaceLocationFromId(String placeId, String sessionToken, [String? type]) async {
    // final request =
    //     'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';


    final apiKey = Secrets.API_KEY;

    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey&sessiontoken=$sessionToken';

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {

      final result = json.decode(response.body);

      if (result['status'] == 'OK') {

        final location = result['result']['geometry']['location'];
        print('//////////////////////////////');
        print(location);
        print(location['lat']);
        print(location['lng']);
        // build result
        final position = LatLng(double.parse(location['lat'].toString()), double.parse(location['lng'].toString()));
        // print('$location.longitude  $location.latitude');

        if(type =='start'){
          _departurePosition = position;
          print('_departurePosition ==========> $_departurePosition');
        }else{

          _arrivalPosition   = position;
          print('_arrivalPosition   ==========> $_arrivalPosition');
        }
        return position;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }


  Future<String?> getAddressFromLatLng( double lat, double lng) async {


    final apiKey = Secrets.API_KEY;
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$apiKey&latlng=$lat,$lng';
    if(lat != null && lng != null){

      var response = await http.get(Uri.parse(url));

      if(response.statusCode == 200) {
        Map data = jsonDecode(response.body);

        List test = data["results"][0]["address_components"] as List;
        print("${test.length} ");
        print("${data.toString().contains("locality, political")} ");

        // if(!data.values.contains("[locality, political]")){
        //   return null;
        // }

        if(test.length<5)
          {
            return null;
          }

        String _formattedAddress = data["results"][0]["address_components"][3]["long_name"];


        print(checkpointsList.keys.toString());

        print(checkpointsList.keys.toString().contains(_formattedAddress));

        if(!checkpointsList.keys.toString().contains(_formattedAddress)) {
          _checkpointsList.putIfAbsent(_formattedAddress, // <----
                  () => LatLng(lat, lng));
        }else{
          print("-***************************************************************-");
        }

        print("response ==== $_formattedAddress");
        print(" hhhh ${_checkpointsList.length}");

        return _formattedAddress;
      } else return null;
    } else return null;
  }

  // ---------------- get path information ------------------------------------------------------

//----------------------------------------
  // Method for calculating the distance between two places
  Future<bool> calculateDistance() async {


    List<Map<String, LatLng>> _interMediateList = [];

    // double startLatitude  =startLocation.latitude;
    // double startLongitude =startLocation.longitude;
    //
    // double destinationLatitude  = arriveLocation.latitude;
    // double destinationLongitude = arriveLocation.longitude;
    //
    // print(
    //   'START COORDINATES: ($startLatitude, $startLongitude)',
    // );
    // print(
    //   'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
    // );


   // await getDiffrentTrajectories(LatLng(startLatitude,startLongitude),LatLng(destinationLatitude,destinationLongitude));


    await getDiffrentTrajectories(_departurePosition,_arrivalPosition);


    double totalDistance = 0.0;
    print('polylineCoordinates.length: ${polylineCoordinates.length} ');
    // Calculating the total distance by adding the distance
    // between small segments

    for (int i = 0; i < polylineCoordinates.length - 1; i++) {


      // List<Placemark> middleplaces = await placemarkFromCoordinates(
      //     polylineCoordinates[i].latitude,  polylineCoordinates[i].longitude);

      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i+1].latitude,
        polylineCoordinates[i+1].longitude,
      );

      print(' $i >---->  ${i+1}  = ${_coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i+1].latitude,
        polylineCoordinates[i+1].longitude,
      )}');

      print('$i ----------->  $totalDistance');

      await getAddressFromLatLng(polylineCoordinates[i].latitude,polylineCoordinates[i].longitude);

      i=i+50;
      // Placemark placeonWay = middleplaces[0];
      //
      // _checkpointsList.add({
      //   "administrativeArea": placeonWay.administrativeArea,
      //   "country": placeonWay.country,
      // });
      //
      // log('data: ' "${placeonWay.name},"
      //       "${placeonWay.street}, "
      //       "${placeonWay.isoCountryCode}, "
      //       "${placeonWay.postalCode}, "
      //       "${placeonWay.subLocality}, "
      //       "${placeonWay.locality}, "
      //       "${placeonWay.thoroughfare}, "
      //       "${placeonWay.subThoroughfare}, "
      //       "${placeonWay.subAdministrativeArea}, "
      //       "${placeonWay.administrativeArea}, "
      //       "${placeonWay.country}",  );
    }

    _checkpointsList.forEach((key, value) {
      _interMediateList.add({key:value});
    });


    _middleList = _interMediateList;
    notifyListeners();
    return true;
    return false;
  }


  Future<void> getDiffrentTrajectories(LatLng l1, LatLng l2)async
  {
    final url = "https://maps.googleapis.com/maps/api/"
        "directions/json?"
        "origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude}, ${l2.longitude}&alternatives=true&key=${Secrets.API_KEY}";

    try{

      http.Response response = await http.get(Uri.parse(url));
      Map values = jsonDecode(response.body);
      _drawTrajectory(values,0);
      notifyListeners();

    }catch(error){
      print(error);
    }
  }

  Future<void> _drawTrajectory(Map values, int i)async
  {
    //polylineCoordinates.clear();
    print(' -----------> $i');
    var listLocation =_convertToLatLng(_decodePoly(values["routes"][i]["overview_polyline"]["points"]));

    print('using http request');
    print('--------------------> $i');
    print(listLocation);
    List<LatLng> polylineCoordinatestwo=[];
    if (listLocation.isNotEmpty) {
      listLocation.forEach((element) {

        polylineCoordinatestwo.add(
            LatLng(
                element.latitude,
                element.longitude
            ));
        print('${element.latitude.toStringAsFixed(3)}' +'------->'+ ' ${element.latitude.toStringAsFixed(3)}');

      });
      polylineCoordinates = polylineCoordinatestwo;
    }

  }






  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
  //-------------------------------- Extrat / manual methods ---------------------------------------------

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = [];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  //---- DECODE POLY --------------------------------------------------------------------------------------
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;


      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    print(lList.toString());

    return lList;
  }

}


class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

// class Place {
//   String streetNumber;
//   String street;
//   String city;
//   String zipCode;
//   Place({
//     this.streetNumber,
//     this.street,
//     this.city,
//     this.zipCode,
//   });
//
//   @override
//   String toString() {
//     return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
//   }
// }