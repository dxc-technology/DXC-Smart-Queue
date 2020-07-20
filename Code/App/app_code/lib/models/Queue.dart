import 'package:mtahackathon/utils/general_utils.dart';

class Queue {

  String queueId;

  String startTime;

  String endTime;

  num maxCapacity;

  num addressId;

  String address;

  String destination;

  num rewardPoints;

  num queuePercentage;

  num trainPercentage;

  num resourceID;

  Queue(
      {this.queueId,
      this.startTime,
      this.endTime,
      this.maxCapacity,
      this.addressId,
      this.address,
      this.destination,
      this.rewardPoints,
      this.queuePercentage,
      this.trainPercentage,
      this.resourceID});

  factory Queue.fromJson(Map<String, dynamic> json) => Queue()
    ..queueId = json['queue_id']
    ..startTime = json['start_time']
    ..endTime = json['end_time']
    ..maxCapacity = json['max_capacity']
    ..addressId = json['address_id']
    ..address = json['address']
    ..resourceID = json['resource_id']
    ..destination = json['destination']
    ..rewardPoints = GeneralUtils.convertRewardPoints(json['reward'])
    ..queuePercentage = json['queue_percentage']
    ..trainPercentage = json['train_percentage'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
