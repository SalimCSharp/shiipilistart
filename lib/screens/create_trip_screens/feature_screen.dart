
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipili_start_app/model/trip_order.dart';
import 'package:shipili_start_app/providers/map_managemant/map_provider.dart';
import 'package:shipili_start_app/providers/trip_managemant/trip_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/edit_validation_screen.dart';


 class FeatureScreen extends StatefulWidget {


   static const routeName = '/Feature-screen';

   @override
   _FeatureScreenState createState() => _FeatureScreenState();
 }

 class _FeatureScreenState extends State<FeatureScreen> {

   final _volumeFocusNode           = FocusNode(); // to jump from txt firl to another when click next on keyboard
   final _weightFocusNode           = FocusNode();

    double? _weight ;
    double? _volume  ;
    double? _price  ;

   final _weightController        = TextEditingController();
   final _volumeController        = TextEditingController();
   final _priceController        = TextEditingController();

   bool              isSelected = false;
   List<String> selectedChoices = [];


   var _initValues = {};
   bool _init= true;
   bool _isLoading =true;

   // using on case edititng state
   String? tripItemId;

   @override
   void didChangeDependencies() async{

     if(_init){

       final tripInitProvider = Provider.of<TripProvider>(context);
       final args = ModalRoute.of(context)!.settings.arguments;

       // get the id of item on case editing
       tripItemId = args!=null
           ? ModalRoute.of(context)!.settings.arguments as String
           :null; // retreive the trip id ,

       if(tripItemId!=null){ // we r on editing state

         _weightController.text = tripInitProvider.weight.toString();
         _volumeController.text = tripInitProvider.volume.toString();
         _priceController.text  = tripInitProvider.price.toString();
         selectedChoices        = tripInitProvider.categoryItems;

       }

     }
       _init= false;

     // TODO: implement didChangeDependencies
     super.didChangeDependencies();
   }

   @override
   Widget build(BuildContext context) {



     final tripInitProvider =  Provider.of<TripProvider>(context);
     final mapInitProvider  = Provider.of<MapProvider>(context);

     return Scaffold(

       body: Padding(
         padding: const EdgeInsets.all(20.0),
         child: Column(

           crossAxisAlignment: CrossAxisAlignment.start,
           children: [

             Padding(
               padding: const EdgeInsets.all(20.0),
               child: Text(

                 "Select your items characteristics ?",
                 style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
               ),
             ),

             Wrap(
               children:  _buildChoiceList( tripInitProvider.initialCategoryItems),
             ),

             SizedBox(height: 25,),

             TextFormField(


               controller: _volumeController,
               onTap: () async{

               },

               decoration: InputDecoration(
                 filled: true,
                 prefixIcon:  const Icon(Icons.date_range) ,
                 border: OutlineInputBorder(
                     borderSide: BorderSide.none,
                     borderRadius: BorderRadius.circular(20)
                 ),

                 hintText: 'Volume',
               ),

               keyboardType: TextInputType.number,
               textInputAction: TextInputAction.next,


               onSaved: (value){  // the entred value , set to the current product (update)
                 //_phoneNumber =int.parse(value);
               },

               // we can trig validation each keystrock by enabling onVaoldation to true on form or manuall by _form_currentsatate.validate()
               validator: (value){
                 if(value!.isEmpty)
                 {
                   return 'Please select arrive date and time';
                 }
                 return null; // return false
               },
             ),

             SizedBox(height: 25,),
             TextFormField(



               controller: _weightController,

               onTap: () async{

               },

               decoration: InputDecoration(

                 filled: true,
                 prefixIcon:  const Icon(Icons.input) ,
                 border: OutlineInputBorder(
                     borderSide: BorderSide.none,
                     borderRadius: BorderRadius.circular(20)
                 ),

                 // icon: const Icon(Icons.date_range),
                 hintText: 'Weight',

               ),

               keyboardType: TextInputType.number,
               textInputAction: TextInputAction.done,


               onSaved: (value){  // the entred value , set to the current product (update)

                 //_phoneNumber =int.parse(value);
               },

               // we can trig validation each keystrock by enabling onVaoldation to true on form or manuall by _form_currentsatate.validate()
               validator: (value){

                 if(value!.isEmpty)
                 {
                   return 'Please select weight';
                 }
                 return null; // return false
               },

             ),


             SizedBox(height: 25,),
             TextFormField(


               controller: _priceController,
               decoration: InputDecoration(

                 filled: true,
                 prefixIcon:  const Icon(Icons.input) ,
                 border: OutlineInputBorder(
                     borderSide: BorderSide.none,
                     borderRadius: BorderRadius.circular(20)
                 ),

                 // icon: const Icon(Icons.date_range),
                 hintText: 'Price',
               ),

               keyboardType: TextInputType.number,
               textInputAction: TextInputAction.done,
             ),
             Align(
               alignment: AlignmentDirectional.bottomEnd,
                 child: Text("Sugessted Price : 1500DA" ,
                   style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),)
             ),
           ],
         ),
       ),

       floatingActionButton: FloatingActionButton(
         onPressed: () {


           if(_volumeController.text.isNotEmpty)
           _volume =double.parse(_volumeController.text);

           if(_weightController.text.isNotEmpty)
           _weight =double.parse(_weightController.text);


           if(_priceController.text.isNotEmpty)
             _price =double.parse(_priceController.text);

           tripInitProvider.setVolume(_volume);
           tripInitProvider.setWeight(_weight);
           tripInitProvider.setPrice(_price);

           tripInitProvider.setCategories(selectedChoices);

            if(tripItemId!=null){

              var tripOrder = Trip(
                id             : tripItemId!,
                userId         : 'user',

                departure      : mapInitProvider.departureAdress,
                arrival        : mapInitProvider.arrivalAdress,
                checkpointsList: mapInitProvider.checkpointsList,

                startTime      : tripInitProvider.startDate,
                startHourTime  : tripInitProvider.startHour,

                timeCreate     : DateTime.now(),

                categoryItems : tripInitProvider.categoryItems,
                weightItem    : tripInitProvider.weight,
                volumeItem    : tripInitProvider.volume,
                price         : tripInitProvider.price,

              );

              tripInitProvider.editTripOrder(tripItemId!,tripOrder).then((_)
              {

                Navigator.of(context).pushNamed(
                    EditValidationTripScreen.routeName, arguments:tripItemId);

              });

            }else{

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditValidationTripScreen()),
              );
            }


         },

         child: Icon(Icons.navigate_next, color: Colors.white, size: 50,),
         backgroundColor: Colors.blue,
         tooltip: 'Capture Picture',
         elevation: 5,
         splashColor: Colors.grey,
       ),
     );
   }


   //------------------------------------------------------------------
   //-------------------------    Widgets:   --------------------------
   //------------------------------------------------------------------



   _buildChoiceList(List<String> selectedCategories) {

     List<Widget> choices = [];
     final categoryData = selectedCategories;

     print('_buildChoiceList ------> selectedChoices');

     categoryData.forEach((item) {
       print(selectedChoices);
       choices.add(Container(
         padding: const EdgeInsets.all(2.0),
         child: ChoiceChip(
           label: Text(item),
           selected: selectedChoices.contains(item),
           onSelected: (selected) {
             setState(() {
               selectedChoices.contains(item)
                   ? selectedChoices.remove(item)
                   : selectedChoices.add(item);
             });
           },

         ),
       ));
     });
     return choices;
   }
 }
