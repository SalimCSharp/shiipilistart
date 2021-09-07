

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipili_start_app/providers/map_managemant/address_search.dart';
import 'package:shipili_start_app/providers/map_managemant/map_provider.dart';
import 'package:shipili_start_app/screens/result_screen.dart';
import 'package:uuid/uuid.dart';


class SearchScreen extends StatefulWidget {

  static const routeName = '/search-screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {

  final startAddressController        = TextEditingController();
  final arrivalAddressController      = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: Colors.white,


      body: Padding(
        padding: const EdgeInsets.all(20.0),

           child:  Stack(
             
             children: [

               Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Text(

                        "Where are you going  ?",
                        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                    ),

                    TextFormField(
                      controller: startAddressController,

                      onTap: ()async{

                        // generate a new token here
                        final sessionToken = Uuid().v4();

                        final Suggestion  result = await showSearch(
                          context: context,
                          delegate: AddressSearch(sessionToken),
                        );

                        startAddressController.text = result.description;
                      },

                      decoration: InputDecoration(

                        filled: true,

                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)
                        ),

                        prefixIcon: const Icon(Icons.search),
                        hintText: 'ex: Djelfa , fid albtoma',

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

                    SizedBox(height: 20,),

                    TextFormField(
                      controller: arrivalAddressController,

                      onTap: ()async{

                        // generate a new token here
                        final sessionToken = Uuid().v4();

                        final Suggestion  result = await showSearch(
                          context: context,
                          delegate: AddressSearch(sessionToken),
                        );

                        arrivalAddressController.text = result.description;
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


                      // we can trig validation each keystrock by enabling onVaoldation to true on form or manuall by _form_currentsatate.validate()
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Please add start location';
                        }
                        return null; // return false
                      },

                    ),


                    SizedBox(
                      height: 10,
                    ),

                    Divider(
                      color: Colors.blue,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Text('Today, 14:00',
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color:Theme.of(context).primaryColor),),

                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.blue,
                    ),


                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          onTap: (){

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ResultScreen()),
                            );

                          },

                          child: Container(
                            height: 45,

                            width: width*0.5,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Search",
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

               Positioned(

                 left: width*0.7,
                 top:  height*0.17,

                 child: Card(

                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(25.0),
                   ),
                   shadowColor: Colors.grey,
                   elevation: 5,
                   child: Container(
                     height: 50,
                     width: 50,
                     child: Icon(Icons.compare_arrows, color: Colors.blue),
                   ),
                 ),
               ),
             ],
           ),

      ),

    );
  }
}
