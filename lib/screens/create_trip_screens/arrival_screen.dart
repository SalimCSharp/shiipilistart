
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/map_managemant/address_search.dart';
import '../../providers/map_managemant/map_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/checkpoints_screen.dart';
import 'package:uuid/uuid.dart';

class ArrivalScreen extends StatefulWidget {
  @override
  _ArrivalScreenState createState() => _ArrivalScreenState();
}

class _ArrivalScreenState extends State<ArrivalScreen> {

  final arrivalAddressController        = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(
        leading: Icon(
          Icons.close,
          size: 30,
          color: Colors.blue,
        ),


        backgroundColor: Colors.white,
        elevation: 0.0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(

          children: [
            Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(

                    "Where are you going ?",
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),

                TextFormField(
                  controller: arrivalAddressController,

                  onTap: ()async{

                    // generate a new token here
                    final sessionToken = Uuid().v4();

                    final Suggestion  result = await showSearch(
                      context: context,
                      delegate: AddressSearch(sessionToken),
                    );

                    Provider.of<MapProvider>(context, listen: false).setTextAdress(result.description, 'arrival');
                    // set the start point
                    await Provider.of<MapProvider>(context, listen: false).getPlaceLocationFromId(result.placeId , sessionToken,'arrive').then(
                            (value) {
                              arrivalAddressController.text = result.description;
                        });



                  },

                  decoration: InputDecoration(

                    filled: true,

                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                    ),

                    prefixIcon: const Icon(Icons.search),
                    hintText: 'ex: Alger , sidi mhamed',

                  ),

                  textInputAction: TextInputAction.next,


                  // we can trig validation each keystrock by enabling onVaoldation to true on form or manuall by _form_currentsatate.validate()
                  validator: (value){
                    if(value!.isEmpty)
                    {
                      return 'Please add start location';
                    }
                    return null; // return false
                  },

                ),



              ],
            ),

            Positioned(

              bottom: 0.0,
              right: 0.0,
              child: GestureDetector(

                onTap: (){

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckPointScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),

                  child: Icon(
                    Icons.navigate_next,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}
