import 'package:mtahackathon/models/Reservation.dart';

class ReservationResponse {
  int totalResults;
  List<Reservation> results = [];

  ReservationResponse.fromJson(list) {
    print('Reservation.fromJson(res))');
    list.forEach((res) => results.add(Reservation.fromJson(res)));
  }
}