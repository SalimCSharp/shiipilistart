
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/map_managemant/address_search.dart';
import '../../providers/map_managemant/map_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/arrival_screen.dart';
import 'package:uuid/uuid.dart';

class DepartureScreen extends StatefulWidget {

  static const routeName = '/departure-screen';
  @override
  _DepartureScreenState createState() => _DepartureScreenState();
}

class _DepartureScreenState extends State<DepartureScreen> {

  final startAddressController        = TextEditingController();

  // using on case edititng state
  String? tripItemId;

  bool _init= true;

  @override
  void didChangeDependencies() async{

    if(_init){

      final args = ModalRoute.of(context)!.settings.arguments;

      // get the id of item on case editing
      tripItemId = args!=null
          ? ModalRoute.of(context)!.settings.arguments as String
          :null; // retreive the trip id ,

    }
    _init= false;


    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {


    print('departe screen              $tripItemId');
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

                    "Where are you going from ?",
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

                    Provider.of<MapProvider>(context, listen: false).setTextAdress(result.description, 'start');
                    // set the start point
                    Provider.of<MapProvider>(context, listen: false).getPlaceLocationFromId(result.placeId , sessionToken,'start').then(
                            (value) {
                              startAddressController.text = result.description;
                            });
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



              ],
            ),

            Positioned(

              bottom: 0.0,
              right: 0.0,
                child: GestureDetector(
                  onTap: (){

                    Navigator.of(context).pushNamed(ArrivalScreen.routeName, arguments:tripItemId );

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
