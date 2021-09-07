

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/trip_managemant/trip_provider.dart';
import '../../screens/create_trip_screens/edit_validation_screen.dart';


class TripOrderScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final tripItemProprieties =  Provider.of<TripProvider>(context);

    return Scaffold(

      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(left:20, top:40.0),
              child: Text("Your Trips" , style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,color: Colors.blueGrey,)),
            ),
            ListView.builder(
              
              shrinkWrap: true,
              itemCount: tripItemProprieties.tripItems.length,
              itemBuilder: (context, index){

                return   Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text( 
                              '${DateFormat.yMd().format(tripItemProprieties.tripItems[index].startTime)} '
                              '${tripItemProprieties.tripItems[index].startHourTime}' ,
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.grey,)),
                          SizedBox(height: 20,),

                          Row(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Column(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.blue,
                                  ),

                                  Row(
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.symmetric(vertical:  2),
                                        height: 50,
                                        width:2 ,
                                        color: Colors.blueGrey,
                                      ),
                                      SizedBox(width: 3,),
                                      Container(
                                        // margin: EdgeInsets.symmetric(vertical:  2),
                                        height: 50,
                                        width: 2,
                                        color: Colors.blueGrey,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),


                              Column(
                                children: [
                                  Text(tripItemProprieties.tripItems[index].departure, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.blueGrey)),
                                  SizedBox(height: 50,),
                                  Text(tripItemProprieties.tripItems[index].arrival, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.blueGrey)),
                                ],
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,color: Colors.blue),
                                onPressed: (){

                                  Navigator.of(context).pushNamed(EditValidationTripScreen.routeName, arguments:tripItemProprieties.tripItems[index].id );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel,color: Colors.red,),
                                onPressed: (){
                                  print('tripItemProprieties.tripItems[index].id');
                                  print(tripItemProprieties.tripItems[index].id);
                                  tripItemProprieties.removerTripOrder(tripItemProprieties.tripItems[index].id);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },


            ),
          ],
        ),
      ),
    );
  }
}
