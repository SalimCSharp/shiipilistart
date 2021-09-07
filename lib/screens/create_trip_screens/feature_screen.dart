
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipili_start_app/providers/trip_managemant/trip_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/edit_validation_screen.dart';


 class FeatureScreen extends StatefulWidget {
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

   bool _init =true;
   var _initValues = {};


   @override
   void didChangeDependencies() async{

     if(_init){

       final tripInitProvider = Provider.of<TripProvider>(context);

       if(tripInitProvider.itemIdEdit!=null){ // we r on editing state

         var _tripItem = Provider.of<TripProvider>(context).findTripItemById(tripInitProvider.itemIdEdit);


         _weightController.text =  _tripItem.weightItem.toString();
         _volumeController.text =  _tripItem.volumeItem.toString();
         _priceController.text =  _tripItem.price.toString();

         selectedChoices       =_tripItem.categoryItems!;

       }else{


       }


     }else{
       _init= false;
     }

     // TODO: implement didChangeDependencies
     super.didChangeDependencies();
   }

   @override
   Widget build(BuildContext context) {



     final tripItemProprieties =  Provider.of<TripProvider>(context);

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
               children:  _buildChoiceList( tripItemProprieties.initialCategoryItems),
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

            tripItemProprieties.setVolume(_volume);
            tripItemProprieties.setWeight(_weight);
            tripItemProprieties.setPrice(_price);

            tripItemProprieties.setCategories(selectedChoices);

           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => EditValidationTripScreen()),
           );

           // if(tripItemProprieties.itemIdEdit!=null){
           //
           //   Navigator.push(
           //     context,
           //     MaterialPageRoute(builder: (context) => EditValidationTripScreen()),
           //   );
           // }else{
           //   Navigator.push(
           //     context,
           //     MaterialPageRoute(builder: (context) => EditValidationTripScreen()),
           //   );
           // }

          // tripItemProprieties.savePackageDetails(selectedChoices,_weight,_volume);

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
