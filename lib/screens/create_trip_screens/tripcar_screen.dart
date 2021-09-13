

// list of add cars

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipili_start_app/providers/trip_managemant/trip_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/add_car_screen.dart';

class TripCarScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final tripInitProvider = Provider.of<TripProvider>(context);

    return Scaffold(

      body: Column(

        children: [


          ListView.builder(

            shrinkWrap: true,
              itemCount: tripInitProvider.carItems.length,
              itemBuilder: (context,index){

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(


                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 3,

                    child: ListTile(
                      leading: tripInitProvider.carItems[index].type!.icon,
                      title: Text(tripInitProvider.carItems[index].type!.name),
                      trailing:FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          children: [
                            IconButton(icon: Icon(Icons.edit), color: Colors.black, onPressed: (){

                              Navigator.of(context).pushNamed(AddCarScreen.routeName, arguments: tripInitProvider.carItems[index].id);

                            }),
                            IconButton(icon: Icon(Icons.delete),  color:  Colors.red, onPressed: (){

                              Provider.of<TripProvider>(context,listen: false).removerCar(tripInitProvider.carItems[index].id);
                            }),
                          ],
                        ),
                      ) ,
                      subtitle:Text(tripInitProvider.carItems[index].model),

                    ),
                  ),
                );
              }),
        ],
      )
    );
  }
}
