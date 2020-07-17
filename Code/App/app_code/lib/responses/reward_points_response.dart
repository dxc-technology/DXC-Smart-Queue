import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/models/reward_point.dart';

class RewardPointsResponse {
  int totalResults;
  List<RewardPoint> results;

  RewardPointsResponse.fromJson(Map<String, dynamic> json) {
    totalResults = json['total_results'];
    if (json['results'] != null) {
      results = new List<RewardPoint>();
      json['results'].forEach((v) {
        results.add(new RewardPoint.fromJson(v));
      });
    }
  }
}