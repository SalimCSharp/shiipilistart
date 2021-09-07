

import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:provider/provider.dart';
import 'package:shipili_start_app/providers/trip_managemant/trip_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/edit_validation_screen.dart';
import '../../providers/map_managemant/map_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/date_time_screen.dart';

class CheckPointScreen extends StatefulWidget {
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

  @override
  void didChangeDependencies() async{

    if(_init){

      await Provider.of<MapProvider>(context, listen: false).calculateDistance().then((value){

        setState(() {
          _isLoading = false;
        });
      });
    }else{
      _init= false;
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {


    final tripItemProprieties =  Provider.of<TripProvider>(context);

    staticData = [
      {
        'algeria':LatLng(111,222)
      },

      {
        'oran':LatLng(111,222)
      }
    ];

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
        onPressed: () {


          print('----------------------------');
          print(tripItemProprieties.itemIdEdit);
          if(tripItemProprieties.itemIdEdit!=null)
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditValidationTripScreen()),
              );
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
