import 'package:latlng/latlng.dart';

class Trip {
  final String id;
  final String userId;
  final DateTime timeCreate;

  final String departure;
  final String arrival;
  final Map<String, LatLng> checkpointsList;
  final List<String>? categoryItems;

  final DateTime startTime;
  final String startHourTime;

  final double? weightItem;
  final double? volumeItem;
  final double? price;

  Trip(
      {
        required this.id,
        required this.userId,
        required this.timeCreate,

        required this.departure,
        required this.arrival,
        required this.checkpointsList,

        this.categoryItems,

        required this.startTime,
        required this.startHourTime,

        this.weightItem,
        this.volumeItem,
        this.price

      });
}
