import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipili_start_app/providers/trip_managemant/trip_provider.dart';
import 'package:shipili_start_app/screens/create_trip_screens/arrival_screen.dart';
import 'package:shipili_start_app/screens/create_trip_screens/checkpoints_screen.dart';
import 'package:shipili_start_app/screens/create_trip_screens/departure_screen.dart';
import 'package:shipili_start_app/screens/create_trip_screens/edit_validation_screen.dart';
import 'package:shipili_start_app/screens/create_trip_screens/feature_screen.dart';
import 'package:shipili_start_app/screens/search_screen.dart';
import 'providers/map_managemant/map_provider.dart';
import '../screens/tab_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(


      providers: [
        ChangeNotifierProvider(
          create:(ctx) => MapProvider(),
        ),

        ChangeNotifierProvider(
          create:(ctx) => TripProvider(),
        ),
      ],



      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,

        ),
        home: TabScreen(),

        routes: {

          EditValidationTripScreen.routeName : (ctx) => EditValidationTripScreen(),
          DepartureScreen.routeName : (ctx) => DepartureScreen(),
          ArrivalScreen.routeName : (ctx) => ArrivalScreen(),
          CheckPointScreen.routeName : (ctx) => CheckPointScreen(),
          FeatureScreen.routeName : (ctx) => FeatureScreen(),

          TabScreen.routeName : (ctx) => TabScreen(),
        },
      ),
    );
  }
}

