import 'package:mtahackathon/models/saved_route.dart';

class SavedRoutesResponse {
  int totalResults;
  List<SavedRoute> results;

  SavedRoutesResponse.fromJson(Map<String, dynamic> json) {
    totalResults = json['total_results'];
    if (json['results'] != null) {
      results = new List<SavedRoute>();
      json['results'].forEach((v) {
        results.add(new SavedRoute.fromJson(v));
      });
    }
  }
}
