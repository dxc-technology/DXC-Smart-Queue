import 'package:json_annotation/json_annotation.dart';
import 'package:mtahackathon/utils/general_utils.dart';

//part 'Reservation.g.dart';

@JsonSerializable()
class Reservation {
  String id;

  String queueId;

  String state;

  String reservationState;

  String location;

  String arrivalStation;

  String departureStation;

  String etaMillis;

  String queueOpenMillis;

  String queueCloseMillis;

  num queueOccupancyPercentage;

  num trainOccupancyPercentage;

  num trainId;

  num pointsWorth;

  num queueNum;

  Reservation(
      {this.id,
      this.location,
        this.reservationState,
      this.arrivalStation,
      this.departureStation,
      this.etaMillis,
      this.queueOpenMillis,
      this.queueCloseMillis,
      this.queueOccupancyPercentage,
      this.trainOccupancyPercentage,
      this.trainId,
      this.queueId,
      this.pointsWorth,
      this.queueNum});

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
      id: json['reservation_id'],
      trainId: json['resource'],
      reservationState: json['reservation_state'],
      location: json['location'],
      queueOpenMillis: json['start_time'],
      queueCloseMillis: json['end_time'],
      pointsWorth: GeneralUtils.convertRewardPoints(json['reward_points']),
      queueId: json['queue_id'],
      queueOccupancyPercentage: json['queue_percentage'] * 100,
      trainOccupancyPercentage: json['train_percentage'] * 100,
      arrivalStation: json['destination'],
      departureStation: json['address']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
