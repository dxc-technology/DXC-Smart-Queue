

class SavedRoute {

  num id;

  String fromStation;

  String toStation;

  SavedRoute({this.id, this.fromStation, this.toStation});

  SavedRoute.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }

}