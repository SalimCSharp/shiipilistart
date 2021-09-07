
import 'package:flutter/cupertino.dart';
import 'package:shipili_start_app/model/trip_order.dart';


class TripProvider with ChangeNotifier{

  List<Trip> _tripItems = [];

   double? _volume;
   double? _weight;
   double?  _price;

   String? _itemIdEdit;
  get itemIdEdit  => _itemIdEdit;
  void setItemIdEdit(String? itemId){
    _itemIdEdit=itemId;
  }

  void setVolume(double? volumeValue) =>  _volume = volumeValue;
  void setWeight(double? weightValue) =>  _weight = weightValue;
  void setPrice(double?  priceValue) =>   _price = priceValue;

  void setCategories(List<String>? categoriesItem) =>  _catgories = categoriesItem!;

  get volume  => _volume;
  get weight  => _weight;
  get price   => _price;

  late DateTime _startDate;
  late String   _startHour;

  get startDate => _startDate;
  get startHour => _startHour;

  //--------------------- set categoy items-----------------------------------------//
  List<String> _initialCategories = ["Papers","Phones","Medicament","Luggage"];
  List<String> get initialCategoryItems{
    return [..._initialCategories];
  }

  List<String> _catgories = [];

  List<String> get categoryItems{
    return [..._catgories];
  }


  void setDateHour(DateTime dateTripStart, String hourTripStart)
  {
    _startDate = dateTripStart;
    _startHour = hourTripStart;
  }
  //--------------------- set categoy items-----------------------------------------//

  List<Trip> get tripItems{
    return [..._tripItems];
  }


  Trip findTripItemById(String? id){
    return _tripItems.firstWhere((item) => item.id == id );
  }

  Future<void> fetchTripOrder() async
  {

    try{

      print('load trip orders');
      final List<Trip> loadedShipOrders = _tripItems; // get all user products
      // to range order from newest to oaldes
      _tripItems=loadedShipOrders.reversed.toList();
      notifyListeners();

    }catch(error){
      print(error);
    }

  }


  Future<void> addTripOrder(Trip tripItem)async
  {
    print('add TripOrder');
    final timestamp = DateTime.now();

    try{

      final newOrderItem =  Trip(

        id:          timestamp.toString(),
        // id         :   json.decode(reponse.body)['name'],
        userId     :   tripItem.userId,
        timeCreate :   timestamp,

        departure  : tripItem.departure ,
        arrival    : tripItem.arrival,

        checkpointsList: tripItem.checkpointsList,

        startTime      : tripItem.startTime,
        startHourTime  : tripItem.startHourTime,
        categoryItems  : tripItem.categoryItems,


        volumeItem     :    tripItem.volumeItem,
        weightItem     :    tripItem.weightItem ,

        price : tripItem.price,
      );

      print('addddddddddd');
      print(newOrderItem.categoryItems);
      _tripItems.add(newOrderItem);
      notifyListeners();



    }catch(error){
      print(error);
    }

  }


  Future<void> editTripOrder(String id , Trip newTripItem)async
  {
    // first we get the item index on list
    final itemIndex = _tripItems.indexWhere((item) => item.id == id);

    if(itemIndex >= 0)
    {

      _tripItems[itemIndex] = newTripItem;
      _itemIdEdit = null;
      notifyListeners();

    }else{
      print('there is no id for update the ordership');
    }

  }


  Future<void> removerTripOrder(String id)async{

    int itemIndex = _tripItems.indexWhere(( orderTripItem) => orderTripItem.id == id);

    if(itemIndex >= 0)
    {
      _tripItems.removeAt(itemIndex);
      print(_tripItems);
      notifyListeners();
    }

  }



}