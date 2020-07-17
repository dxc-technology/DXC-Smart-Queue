import 'package:mtahackathon/models/train_schedule.dart';

class TrainScheduleResponse {
  int totalResults;
  List<TrainSchedule> results;

  TrainScheduleResponse.fromJson(Map<String, dynamic> json) {
    totalResults = json['total_results'];
    if (json['results'] != null) {
      results = new List<TrainSchedule>();
      json['results'].forEach((v) {
        results.add(new TrainSchedule.fromJson(v));
      });
    }
  }
}