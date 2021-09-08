

import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:provider/provider.dart';
import 'package:shipili_start_app/model/trip_order.dart';
import 'package:shipili_start_app/providers/trip_managemant/trip_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/edit_validation_screen.dart';
import '../../providers/map_managemant/map_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/date_time_screen.dart';

class CheckPointScreen extends StatefulWidget {
  static const routeName = '/CheckPoint-screen';
  @override
  _CheckPointScreenState createState() => _CheckPointScreenState();
}

class _CheckPointScreenState extends State<CheckPointScreen> {




  List<Map<String,LatLng>> staticData = [];

  List<String> intermediateStations=[];

  Map<int, bool> selectedFlag = {};
  bool isSelectionMode = false;

  bool _init= true;
  bool _isLoading =true;

  // using on case edititng state
  String? tripItemId;

  @override
  void didChangeDependencies() async{

    if(_init){

      final args = ModalRoute.of(context)!.settings.arguments;

      // get the id of item on case editing
      tripItemId = args!=null
          ? ModalRoute.of(context)!.settings.arguments as String
          :null; // retreive the trip id ,

      await Provider.of<MapProvider>(context, listen: false).calculateDistance().then((value){
        setState(() {
          _isLoading = false;
        });
      });

    }
    _init= false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {



    final tripInitProvider = Provider.of<TripProvider>(context);
    final mapInitProvider  = Provider.of<MapProvider>(context);



    staticData =  Provider.of<MapProvider>(context, listen: false).middleList;

    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(

        elevation: 0.0,
        leading: Icon(
          Icons.close,
          size: 30,
          color: Colors.blue,
        ),
        backgroundColor: Colors.white ,
      ),
      body: SingleChildScrollView(


        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(

            children: [

              Text(

                "Where could you prefer provide items on your way ?",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 20,
              ),
              _isLoading ? Center(child: CircularProgressIndicator()):ListView.builder(
                shrinkWrap: true,
                itemBuilder: (builder, index) {


                  // For the first time selectedFlag[index] will be null
                  // so, for that time we will initialize with false
                  selectedFlag[index] = selectedFlag[index] ?? false;
                  bool? isSelected = selectedFlag[index];

                  return ListTile(


                    onTap: () => onTap(isSelected!, index),

                    title: Text("${staticData[index].keys.first}"),
                    //subtitle: Text("hhhh"),
                    // leading: CircleAvatar(
                    //   child: Text('${data['id']}'),
                    // ),
                    leading: _buildSelectIcon(isSelected!, staticData[index]),
                  );
                },
                itemCount: staticData.length,
              ),
            ],
          ),


        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async{


          print('----------------------------');
          print(tripItemId);

          if(tripItemId!=null)
            {

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




              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => EditValidationTripScreen()),
              // );
              //

            }else  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DateTimeScreen()),
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

  void onTap(bool isSelected, int index) {

      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });

  }



  Widget _buildSelectIcon(bool isSelected, Map data) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    } else {
      return Icon(
        Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    }
  }

  Widget? _buildSelectAllButton() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    if (isSelectionMode) {
      return FloatingActionButton(
        onPressed: _selectAll,
        child: Icon(
          isFalseAvailable ? Icons.done_all : Icons.remove_done,
        ),
      );
    } else {
      return null;
    }
  }

  void _selectAll() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    // If false will be available then it will select all the checkbox
    // If there will be no false then it will de-select all
    selectedFlag.updateAll((key, value) => isFalseAvailable);
    setState(() {
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }
}
