

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/departure_screen.dart';
import 'package:shipili_start_app/screens/create_trip_screens/feature_screen.dart';

import '../../model/trip_order.dart';
import '../../providers/trip_managemant/trip_provider.dart';
import '../../screens/tab_screen.dart';
import '../../providers/map_managemant/map_provider.dart';

class EditValidationTripScreen extends StatefulWidget {



  static const routeName = '/Edit-orderTrip';
  @override
  _EditValidationTripScreenState createState() => _EditValidationTripScreenState();
}

class _EditValidationTripScreenState extends State<EditValidationTripScreen> {


  bool _init=true;
  var _initValues = {};
  String? tripItemId;
  //
  // @override
  // void dispose() {
  //
  //
  //   Provider.of<TripProvider>(context,listen: false).setItemIdEdit(null);
  //   print('dispose');
  //   // TODO: implement dispose
  //   super.dispose();
  // }


  @override
  void didChangeDependencies() {

    if(_init){

      final args = ModalRoute.of(context)!.settings.arguments;
      // get the id of item on case editing
      tripItemId = args!=null
          ? ModalRoute.of(context)!.settings.arguments as String
          :null; // retreive the trip id ,


      final tripInitProvider = Provider.of<TripProvider>(context);
      final mapInitProvider  = Provider.of<MapProvider>(context);

      // maybe navigate from the add screen/
      if(tripInitProvider.itemIdEdit==null)
      tripInitProvider.setItemIdEdit(tripItemId);

      print('tripItemId=============> $tripItemId');
      print('tripItemId=== frmo Provider==========> ${tripInitProvider.itemIdEdit}');


      if(tripItemId != null) {


        // if the trip item is exist , first we get the trip item by its id
        final tripItems = tripInitProvider.tripItems;
        var _tripItem = Provider.of<TripProvider>(context).findTripItemById(tripItemId);

        print('ediiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiit new item');



        _initValues = {

          'id'               : _tripItem.id,
          'departure'        : _tripItem.departure,
          'arrival'          : _tripItem.arrival,
          'interStations'    : mapInitProvider.checkpointsList ,

          'categoryItem'     : _tripItem.categoryItems,

          'startTime'        : _tripItem.startTime.toString(),
          'startHourTime'    : _tripItem.startHourTime.toString(),

          'priceTrip'        : _tripItem.price,
          'weightItem'       : _tripItem.weightItem,
          'volumeItem'       : _tripItem.volumeItem,

        };

        mapInitProvider.setTextAdress(_tripItem.departure, 'start');
        mapInitProvider.setTextAdress(_tripItem.arrival,   'arrival');
        tripInitProvider.setCategories(_tripItem.categoryItems);
        tripInitProvider.setDateHour(DateTime.parse(_tripItem.startTime.toString()), _tripItem.startHourTime);

        tripInitProvider.setVolume(_tripItem.volumeItem);
        tripInitProvider.setWeight(_tripItem.weightItem);
        tripInitProvider.setPrice(_tripItem.price);

      }else{

        print('add new item');
        // add new item trip

        _initValues = {
          'id'               : ''                                    ,
          'departure'        : mapInitProvider.departureAdress       ,
          'arrival'          : mapInitProvider.arrivalAdress         ,

          'startTime'        : tripInitProvider.startDate.toString() ,
          'startHourTime'    : tripInitProvider.startHour.toString() ,

          'priceTrip'        : tripInitProvider.price         ,
          'weightItem'       : tripInitProvider.weight        ,
          'volumeItem'       : tripInitProvider.volume        ,

          'categoryItem'     : tripInitProvider.categoryItems        ,
          'interStations'    : mapInitProvider.checkpointsList       ,
        };

      }


    }

    _init=false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(

            children: [

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(

                  "Check your trip order ?",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DepartureScreen()),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.location_on, color: Colors.blue,),
                  title: Text(_initValues['departure']),
                ),
              ),
              Divider(
                color: Colors.blue,
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue,),
                title: Text(_initValues['arrival']),
              ),

              Divider(
                color: Colors.blue,
              ),
              Container(

                height: 150,
                child: ListView.builder(

                    itemCount: _initValues['interStations'].length,
                    itemBuilder: (context, index){
                      return Row(

                        children: [

                          Column(
                            children: [
                              index == 0  || index ==_initValues['interStations'].length-1
                                  ?  Icon(
                                Icons.location_on_rounded,
                              ) : Icon(
                                Icons.pause_circle_outline,

                                color: Colors.grey,
                              ),
                              if(index !=_initValues['interStations'].length-1)
                              Row(
                                children: [
                                  Container(
                                    // margin: EdgeInsets.symmetric(vertical:  2),
                                    height: 50,
                                    width:2 ,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 3,),
                                  Container(
                                    // margin: EdgeInsets.symmetric(vertical:  2),
                                    height: 50,
                                    width: 2,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),

                            ],
                          ),

                          Column(

                            children: [
                              Text(_initValues['interStations'].keys.toList()[index]),
                            ],
                          ),

                          Spacer(),
                          //Text('${ DateFormat.yMd().format(tripItemProprieties.startDate)}  ${tripItemProprieties.startHour}'),

                        ],
                      );
                    }),
              ),

              Divider(
                color: Colors.blue,
              ),
              GestureDetector(

                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeatureScreen()),
                  );
                },
                child: ListTile(

                  title:  Text('Volume'),
                  subtitle: _initValues['volumeItem']!=null
                      ? Text('${_initValues['volumeItem']}')
                      : Text('Volume not selected, Set a Volume') ,
                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.blue,),
                ),
              ),
              Divider(
                color: Colors.blue,
              ),
              ListTile(

                  title: Text('Weight'),
                  subtitle: _initValues['weightItem']!= null ? Text('${_initValues['weightItem']}'): Text('Weight not selected') ,
                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.blue,),
              ),

              Divider(
                color: Colors.blue,
              ),

              ListTile(

                title: Text('price'),
                subtitle: _initValues['priceTrip']!= null ? Text('${_initValues['priceTrip']}'): Text('Price not selected') ,
                trailing: Icon(Icons.arrow_forward_ios,color: Colors.blue,),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: _buildChoiceList(_initValues['categoryItem']),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: (){

                      var tripOrder = Trip(
                        id             : '',
                        userId         : 'user',

                        departure      : _initValues['departure'],
                        arrival        : _initValues['arrival'],
                        checkpointsList: _initValues['interStations'],

                        startTime      : DateTime.parse(_initValues['startTime']),
                        startHourTime  : _initValues['startHourTime'],

                        timeCreate     : DateTime.now(),


                        categoryItems : _initValues['categoryItem'] ,
                        weightItem    : _initValues['weightItem'],
                        volumeItem    : _initValues['volumeItem'],
                        price         : _initValues['priceTrip'],

                      );

                      // call add void
                      if(Provider.of<TripProvider>(context,listen: false).itemIdEdit==null)
                        {
                          // add new order

                          Provider.of<TripProvider>(context, listen: false).addTripOrder(tripOrder);
                        }else{

                        Provider.of<TripProvider>(context, listen: false).editTripOrder(Provider.of<TripProvider>(context,listen :false).itemIdEdit,tripOrder);

                      }


                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TabScreen()),
                      );

                      // Navigator.of(context)
                      //     .pushNamedAndRemoveUntil('/tab-screen', (Route<dynamic> route) => false);


                    },

                    child: Container(
                      height: 45,

                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          Provider.of<TripProvider>(context).itemIdEdit==null ? "Confirmation":"Edit",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),
              ),

            ],

          ),
        ),
      ),

    );
  }

  _buildChoiceList( List<String> categoryPickedItems) {

    print(categoryPickedItems);
    List<Widget> choices = [];
    if(categoryPickedItems!=null)
      categoryPickedItems.forEach((item) {

        choices.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(item),
            selected: false,
          ),
        ));

      });

    return choices;
  }
}
