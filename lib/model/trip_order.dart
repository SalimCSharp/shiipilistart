import 'package:latlng/latlng.dart';

class Trip {
  final String? id;
  final String? userId;
  final DateTime? timeCreate;

  final String? departure;
  final String? arrival;
  final Map<String, LatLng>? checkpointsList;
  final List<String>? categoryItems;

  final DateTime? startTime;
  final String? startHourTime;

  final double? weightItem;
  final double? volumeItem;
  final double? price;

  Trip(
      {
         this.id,
         this.userId,

         this.timeCreate,

         this.departure,
         this.arrival,
         this.checkpointsList,

        this.categoryItems,

         this.startTime,
         this.startHourTime,

        this.weightItem,
        this.volumeItem,
        this.price

      });
}
