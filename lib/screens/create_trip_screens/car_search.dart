
import 'package:flutter/material.dart';


class CarDataSearch extends SearchDelegate<String> {
  final allCars = [
    "Abarth",
    "Alfa Romeo",
    "Aston Martin",
    "Audi",
    "Bentley",
    "BMW",
    "Bugatti",
    "Cadillac",
    "Chevrolet",
    "Chrysler",
    "Citroën",
    "Dacia",
    "Daewoo",
    "Daihatsu",
    "Dodge",
    "Donkervoort",
    "DS",
    "Ferrari",
    "Fiat",
    "Fisker",
    "Ford",
    "Honda",
    "Hummer",
    "Hyundai",
    "Infiniti",
    "Iveco",
    "Jaguar",
    "Jeep",
    "Kia",
    "KTM",
    "Lada",
    "Lamborghini",
    "Lancia",
    "Land Rover",
    "Landwind",
    "Lexus",
    "Lotus",
    "Maserati",
    "Maybach",
    "Mazda",
    "McLaren",
    "Mercedes-Benz",
    "MG",
    "Mini",
    "Mitsubishi",
    "Morgan",
    "Nissan",
    "Opel",
    "Peugeot",
    "Porsche",
    "Renault",
    "Rolls-Royce",
    "Rover",
    "Saab",
    "Seat",
    "Skoda",
    "Smart",
    "SsangYong",
    "Subaru",
    "Suzuki",
    "Tesla",
    "Toyota",
    "Volkswagen",
    "Volvo"
  ];
  var recentCars = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
         // close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        child: Card(
          color: Colors.grey,
          child: Center(child: Text(query)),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentCars
        : allCars.where((p) => p.toLowerCase().startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          close(context, suggestionList[index]);
          //showResults(context);
        },

        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].substring(0, query.length),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
              ),
            ],
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
