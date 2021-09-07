
import 'package:flutter/material.dart';


class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(



        body: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left:20, top:40.0),
                child: Text("Current Trips" , style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,color: Colors.blueGrey,)),
              ),

              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListView(

                  shrinkWrap: true,
                  children: [

                    Stack(
                      children: [

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),

                          elevation: 3,

                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(

                              children: [

                                Row(

                                  children: [
                                    Container(
                                      height: height*0.09,
                                      width:  width*0.185,
                                      child: CircleAvatar(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:  AssetImage("assets/images/user.jpg"),
                                                fit: BoxFit.cover
                                            ),

                                            borderRadius: BorderRadius.circular(74.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Text('Gharbi Oussama', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.black)),
                                    Spacer(),
                                    Text('15 min ago', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.grey)),
                                  ],
                                ),

                                SizedBox(height: 10,),
                            
                                Row(

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.only(left:2.0),
                                      child: Column(

                                        children: [
                                          Icon(
                                            Icons.circle_outlined,
                                            size: 10,
                                            color: Colors.blueGrey,
                                          ),

                                          Row(
                                            children: [
                                              Container(
                                                // margin: EdgeInsets.symmetric(vertical:  2),
                                                height: 50,
                                                width:3 ,
                                                color: Colors.blueGrey,
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.circle_outlined,
                                            size: 10,
                                            color: Colors.blueGrey,
                                          ),
                                        ],
                                      ),
                                    ),

                                    Column(
                                      children: [
                                        Text('Ain Maabed, Djelfa', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.black)),
                                        SizedBox(height: 35,),
                                        Text('Hamdania, Media', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.black)),
                                      ],
                                    ),


                                  ],
                                ),


                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Icon(Icons.star, color: Colors.blueGrey),
                                        Text('4.5', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.blueGrey)),
                                      ],
                                    ),
                                    Text('1500 DA', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.black)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned(

                          top: 10,
                          right: width*0.7,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 12.0,
                            child: Icon(
                              Icons.car_rental_outlined,
                              size: 20.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
