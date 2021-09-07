

import 'package:flutter/material.dart';


import '../screens/create_trip_screens/departure_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/profil_screen.dart';
import '../screens/trips_screen.dart';
import '../screens/search_screen.dart';


class TabScreen extends StatefulWidget {

  static const routeName = '/tab-screen';
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {


  int _selectedPageIndex = 0;
  late List<Map<String,Widget>> _pagesMap;


  @override
  void initState() {

    _pagesMap=[
      {
        'page': SearchScreen(),
        //'title':'Home',
      },

      {
        // we can not use widget option on type declaretion which require use it within a void
        // we can the variable decalrtation and we iniate it with initState void
        'page': DepartureScreen(),
        //'title':'chat',
      },

      {
        // we can not use widget option on type declaretion which require use it within a void
        // we can the variable decalrtation and we iniate it with initState void
        'page': TripsScreen(),
        //'title':'Favorites',
      },

      {
        // we can not use widget option on type declaretion which require use it within a void
        // we can the variable decalrtation and we iniate it with initState void
        'page': ChatScreen(),
        //'title':'Favorites',
      },

      {
        // we can not use widget option on type declaretion which require use it within a void
        // we can the variable decalrtation and we iniate it with initState void
        'page': ProfileScreen(),
        //'title':'Favorites',
      },
    ];
    // TODO: implement initState
    super.initState();
  }

  void _selectPage(int index)
  {
    setState(() {
      _selectedPageIndex=index;
    });

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: _pagesMap[_selectedPageIndex]['page'],

      bottomNavigationBar: BottomNavigationBar(



        onTap: _selectPage,

        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.black,

        currentIndex: _selectedPageIndex,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search)    ,       title: Text("Search")),
          BottomNavigationBarItem(icon: Icon(Icons.add)      ,        title: Text("Create Order")),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)  ,       title: Text("your trips")),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline)  ,   title: Text("Messages")),
          BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle_outlined)  ,   title: Text("Profile")),
        ],

      ),


    );
  }
}
