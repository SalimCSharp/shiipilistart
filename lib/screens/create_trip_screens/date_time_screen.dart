

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shipili_start_app/providers/trip_managemant/trip_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/feature_screen.dart';

class DateTimeScreen extends StatefulWidget {
  @override
  _DateTimeScreenState createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {



  // date picker settings ---------------------------------------------
  final startDateTimeController = TextEditingController();
  String  _dateTimeStart  ='';
  String _selectedTime='';


  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // Refer step 1
      firstDate: DateTime(2021),
      lastDate:  DateTime(4000),
      initialDatePickerMode: DatePickerMode.day,
      fieldLabelText: 'Traveling date',
      fieldHintText: 'Month/Date/Year',
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;

      });
  }


  // We don't need to pass a context to the _show() function
  // You can safety use context as below
  Future<void> _show() async {
    final TimeOfDay? result = await showTimePicker(
        context: context, initialTime: TimeOfDay.now() );
    if (result != null) {
      setState(() {
        _selectedTime = result.format(context);
      });
    }
  }

  //----------------------------

  // int _n = 0;
  //
  // void add() {
  //   setState(() {
  //     _n++;
  //   });
  // }
  //
  // void minus() {
  //   setState(() {
  //     if (_n != 0)
  //       _n--;
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    final tripItemProprieties =  Provider.of<TripProvider>(context);

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(

                "When you will start  your trip ?",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            TextFormField(

              controller: startDateTimeController,

              onTap: () async{

                await _selectDate(context);
                await _show();


                setState(() {
                  _dateTimeStart = '${DateFormat.yMd().format(selectedDate)} ' ' $_selectedTime';
                  startDateTimeController.text = _dateTimeStart;
                });

                print('$_dateTimeStart');
              },

              decoration: InputDecoration(

                filled: true,
                prefixIcon:  const Icon(Icons.date_range) ,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20)
                ),

                // icon: const Icon(Icons.date_range),
                hintText: 'start date',

              ),

              textInputAction: TextInputAction.next,


              onSaved: (value){  // the entred value , set to the current product (update)

                //_phoneNumber =int.parse(value);
              },

              // we can trig validation each keystrock by enabling onVaoldation to true on form or manuall by _form_currentsatate.validate()
              validator: (value){

                if(value!.isEmpty)
                {
                  return 'Please select date and time';
                }
                return null; // return false
              },

            ),

            SizedBox(
              height: 20,
            ),

            // Padding(
            //   padding: const EdgeInsets.all(30.0),
            //   child: Text(
            //
            //     "Volume ",
            //     style: TextStyle(fontSize: 25.0,color: Colors.grey),
            //   ),
            // ),
            // Container(
            //   child: new Center(
            //     child: new Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: <Widget>[
            //         new FloatingActionButton(
            //           onPressed: add,
            //           child: new Icon(Icons.add, color: Colors.white,),
            //           backgroundColor: Colors.blue,),
            //
            //         new Text('$_n',
            //             style: new TextStyle(fontSize: 60.0)),
            //
            //         new FloatingActionButton(
            //           onPressed: minus,
            //           child: new Icon(Icons.remove, color: Colors.white,),
            //           backgroundColor: Colors.blue,),
            //       ],
            //     ),
            //   ),
            // ),

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {

          tripItemProprieties.setDateHour(selectedDate, _selectedTime);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeatureScreen()),
          );
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
