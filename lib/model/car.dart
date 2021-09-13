

import 'package:flutter/material.dart';

class Car{

  final String id;
  final String brand;
  final String model;
  final CarItem? type;
  final String regNumber;
  final String year;



  Car({required this.id,required this.brand,required this.model, this.type, required this.regNumber,required this.year});
}

class CarItem {
  const CarItem(this.name,this.icon);
  final String name;
  final Icon icon;
}