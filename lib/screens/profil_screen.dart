
import 'package:flutter/material.dart';
import 'package:shipili_start_app/screens/create_trip_screens/tripcar_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [



            ListTile(
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TripCarScreen()),
                );

              },
              title: Text("Your Cars"),
            ),
            Divider(),
            ListTile(
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TripCarScreen()),
                );

              },
              title: Text("Your Cars"),
            ),
            Divider(),
          ],
        ),
      ),

    );;
  }
}
