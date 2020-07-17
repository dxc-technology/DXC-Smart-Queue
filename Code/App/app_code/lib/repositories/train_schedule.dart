import 'dart:convert';

import 'package:mtahackathon/api/api_base_helper.dart';
import 'package:mtahackathon/models/Queue.dart';
import 'package:mtahackathon/models/location.dart';
import 'package:mtahackathon/utils/constants.dart';

class TrainScheduleRepository {

  ApiBaseHelper _helper = ApiBaseHelper();


  Future<List<Queue>> fetchTrainQueues(Map<String, dynamic> payLoad) async {

    print('search payload $payLoad');

    final response = await _helper.post(Constants.queueSearch, jsonEncode(payLoad));

    List<Queue> results = [];
    response.forEach((res) => results.add(Queue.fromJson(res)));

    return results;
  }

  Future<List<Location>> getLocations() async {
    final response = await _helper.get(Constants.locationsUrl);

    List<Location> results = [];
    response.forEach((res) => results.add(Location.fromJson(res)));

    return results;
  }
}
