class Location {

  Location();

  String id;

  String address;

  num addressId;

  num maxCapacity;

  factory Location.fromJson(Map<String, dynamic> json) => Location()
      ..id = json['id']
      ..address = json['address']
      ..addressId = json['address_id']
      ..maxCapacity = json['max_capacity'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }

}