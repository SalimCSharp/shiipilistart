
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipili_start_app/model/car.dart';
import 'package:shipili_start_app/providers/trip_managemant/trip_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/car_search.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:fluttericon/linecons_icons.dart';

class AddCarScreen extends StatefulWidget {
  static const routeName = '/AddCar-Screen';

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {

  final _form = GlobalKey<FormState>();

   var _editCar     = Car(id: '', brand: '', model: '',type: null, regNumber: '' ,year: '' );

  final _carBrandFocusNode          = FocusNode(); // to jump from txt firl to another when click next on keyboard
  final _carModelFocusNode          = FocusNode();
  final _carRegNumFocusNode         = FocusNode();
  final _carYearFocusNode           = FocusNode();


  final _carBrandController       = TextEditingController();
  final _carModelController       = TextEditingController();
  final _carRegNumController      = TextEditingController();
  final _carYearController        = TextEditingController();

  var selectedCategory;

  List<CarItem> carItems = <CarItem>[
    const CarItem('Taxi',Icon(Icons.android,color:  const Color(0xFF167F67),)),
    const CarItem('Bus',Icon(Icons.flag,color:  const Color(0xFF167F67),)),
    const CarItem('Personal Car',Icon(Icons.format_indent_decrease,color:  const Color(0xFF167F67),)),
    const CarItem('Van',Icon(Icons.mobile_screen_share,color:  const Color(0xFF167F67),)),
  ];


  late  String _brandValue;
  late  String _modelValue;
  late  CarItem _typeValue;
  late  String _regNumberValue;
  late  String _yearValue;



  //-------------------------------- to get values for editing ---------------//
  var _initValues = {  };
  bool _init=true;
  String? tripItemId;


  @override
  void didChangeDependencies() {

    if(_init){

      final args = ModalRoute.of(context)!.settings.arguments;
      // get the id of item on case editing
      tripItemId = args!=null
          ? ModalRoute.of(context)!.settings.arguments as String
          :null; // retreive the trip id ,

      if(tripItemId != null) {

        final tripInitProvider = Provider.of<TripProvider>(context);
        var _carItem = tripInitProvider.findCarItemById(tripItemId);

         _initValues = {
          'id'         : _carItem.id,
          'Brand'      : _carItem.brand,
          'Model'      : _carItem.model,
          'Type'       : _carItem.type!.name,
          'RegNum'     : _carItem.regNumber,
           'Year'      : _carItem.year,
        };

        _carBrandController.text = _carItem.brand;

        //------------------------------------------------------------------------------
        var index  =carItems.indexWhere((element) => element==_carItem.type);
        print(index);
        selectedCategory = carItems[index] ;
      }

    }

    _init = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }


  Future<void> _saveForm() async {  // bcz save include methode ich is async , we can add also here async

    final _isValid = _form.currentState!.validate(); // if there is no error , its retrun true
    if (!_isValid) {
      return;
    }

    _form.currentState!.save();
    try {

     // _editCar     = Car(id: '', brand: _brandValue, model: _modelValue,type: _typeValue, regNumber: _regNumberValue ,year: _yearValue );
     //  _editCar     = Car(
     //      id:        _initValues['id'],
     //      brand:     _initValues['Brand'],
     //      model:     _initValues['Model'],
     //      type:      _initValues['Type'],
     //      regNumber: _initValues['RegNum'] ,
     //      year:      _initValues['Year'] ,
     //  );

      print(tripItemId);

      if(tripItemId!= null){
        Provider.of<TripProvider>(context,listen: false).editCar(tripItemId!,_editCar);
      }else{

        Provider.of<TripProvider>(context,listen: false).addCar(_editCar);
      }


      // set the car object
    }catch(error)
    {
      await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(

            title: Text("An error Occured"),
            content: Text("Something went Wrong"),
            actions: [
              FlatButton(
                onPressed: (){
                  Navigator.of(ctx).pop();
                },

                child: Text("Okay"),
              ),
            ],
          )
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    print('builddddddddddddddddd');
    return Scaffold(

      body:SingleChildScrollView(

        child: Padding(

          padding: const EdgeInsets.all(20.0),

          child: Form(

            key:_form,

            child: Column(

              children: [

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(

                    "Add your car characteristics ?",
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 10,),
                TextFormField(

                  //initialValue: _initValues['Brand'],

                  focusNode: _carBrandFocusNode,
                  controller: _carBrandController,

                  onTap: () async{

                    final   result =  await showSearch(
                      context: context,
                      delegate: CarDataSearch(),
                    );

                    _carBrandController.text = result!;

                    print(_initValues['Brand']);

                  },

                  decoration: InputDecoration(

                    filled: true,
                    prefixIcon:  const Icon(Linecons.calendar) ,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20)
                    ),


                    hintText: 'Car Brand',

                  ),

                  textInputAction: TextInputAction.next,


                  onSaved: (value){  // the entred value , set to the current product (update)

                    _brandValue = value!;
                    _editCar     = Car(
                        id: _editCar.id,
                        brand: _brandValue,
                        model: _editCar.model,
                        type: _editCar.type,
                        regNumber:_editCar.regNumber
                        ,year: _editCar.year
                    );
                  },

                  // we can trig validation each keystrock by enabling onVaoldation to true on form or manuall by _form_currentsatate.validate()
                  validator: (value){

                    if(value!.isEmpty)
                    {
                      return 'Please your car brand';
                    }
                    return null; // return false
                  },

                ),

                SizedBox(height: 20,),
                TextFormField(

                  initialValue: _initValues['Model'],
                  focusNode: _carModelFocusNode,
                  //controller: _carModelController,
                  onTap: () async{


                  },

                  decoration: InputDecoration(

                    filled: true,
                    prefixIcon:  const Icon(Icons.location_on) ,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20)
                    ),

                    // icon: const Icon(Icons.date_range),
                    hintText: 'Car model',

                  ),

                  textInputAction: TextInputAction.next,


                  onSaved: (value){  // the entred value , set to the current product (update)

                    _modelValue =value!;

                    _editCar     = Car(
                        id: _editCar.id,
                        brand: _editCar.brand,
                        model: _modelValue,
                        type: _editCar.type,
                        regNumber:_editCar.regNumber
                        ,year: _editCar.year
                    );

                  },

                  // we can trig validation each keystrock by enabling onVaoldation to true on form or manuall by _form_currentsatate.validate()
                  validator: (value){

                    if(value!.isEmpty)
                    {
                      return 'Please your car model';
                    }
                    return null; // return false
                  },

                ),


                SizedBox(height: 20,),

                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(

                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),

                  // dropdown below..
                  child:  DropdownButtonFormField<CarItem>(



                    //value: _initValues['Type'],
                    value: selectedCategory,

                    onSaved: (newValue){
                      _editCar     = Car(
                          id:    _editCar.id,
                          brand: _editCar.brand,
                          model: _editCar.model,
                          type:  newValue,
                          regNumber:_editCar.regNumber,
                          year: _editCar.year
                      );

                    },

                    onChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                        _typeValue= newValue;
                        // get cat id  to insert new product
                      });
                    },

                    validator: (value) => value == null
                        ? 'Please Choose your car type' : null,

                    icon: Icon(Icons.arrow_drop_down),


                    // underline: Container(
                    //   height:3,
                    //   color: Colors.blueAccent,
                    // ),
                    // iconSize: 25,

                    style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold),

                    isExpanded: true,
                    hint:Text('Select your car type '),

                    items: carItems.map((CarItem value) {
                      return DropdownMenuItem<CarItem>(


                        value: value,
                        child: Row(
                          children: <Widget>[

                            value.icon,
                            SizedBox(width: 10,),
                            Text(
                              value.name,
                              style:  TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                  ),
                ),

                SizedBox(height: 20,),
                TextFormField(

                  initialValue: _initValues['RegNum'],
                  focusNode: _carRegNumFocusNode,
                 // controller: _carRegNumController,
                  onTap: () async{


                  },

                  decoration: InputDecoration(

                    filled: true,
                    prefixIcon:  const Icon(Icons.location_on) ,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20)
                    ),

                    // icon: const Icon(Icons.date_range),
                    hintText: 'Registration Number',

                  ),

                  textInputAction: TextInputAction.next,


                  onSaved: (value){  // the entred value , set to the current product (update)

                    _regNumberValue =value!;

                    _editCar     = Car(
                        id:    _editCar.id,
                        brand: _editCar.brand,
                        model: _editCar.model,
                        type:  _editCar.type,
                        regNumber:_regNumberValue,
                        year: _editCar.year
                    );
                  },

                  // we can trig validation each keystrock by enabling onVaoldation to true on form or manuall by _form_currentsatate.validate()
                  validator: (value){

                    if(value!.isEmpty)
                    {
                      return 'Please enter your car registration number';
                    }
                    return null; // return false
                  },

                ),
                SizedBox(height: 20,),
                TextFormField(


                  initialValue: _initValues['Year'],
                  focusNode: _carYearFocusNode,
                  //controller: _carYearController,

                  onTap: () async{

                  },

                  decoration: InputDecoration(

                    filled: true,
                    prefixIcon:  const Icon(Icons.location_on) ,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20)
                    ),

                    // icon: const Icon(Icons.date_range),
                    hintText: 'year',

                  ),

                  textInputAction: TextInputAction.next,


                  onSaved: (value){  // the entred value , set to the current product (update)

                    _yearValue =value!;

                    _editCar     = Car(
                        id:    _editCar.id,
                        brand: _editCar.brand,
                        model: _editCar.model,
                        type:  _editCar.type,
                        regNumber:_editCar.regNumber,
                        year:_yearValue,
                    );
                  },

                  // we can trig validation each keystrock by enabling onVaoldation to true on form or manuall by _form_currentsatate.validate()
                  validator: (value){

                    if(value!.isEmpty)
                    {
                      return 'Please enter your car year';
                    }
                    return null; // return false
                  },

                ),

                SizedBox(height: 20,),

                Container(
                  decoration: BoxDecoration(

                    border: Border.all(color: Colors.blueAccent),
                    color: Colors.grey[200],

                  ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async{

          await _saveForm();
          Navigator.of(context).pop();
        },

        child: Icon(Icons.navigate_next, color: Colors.white, size: 50,),
        backgroundColor: Colors.blue,
        tooltip: 'Capture Picture',
        elevation: 5,
        splashColor: Colors.grey,
      ),

    );
  }
}
