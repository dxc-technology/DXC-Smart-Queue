import 'dart:convert';

import 'package:mtahackathon/api/api_base_helper.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/responses/reservation_response.dart';
import 'package:mtahackathon/utils/constants.dart';

class ReservationsRepository {

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Reservation>> fetchReservationList(String userID) async {

    final response = await _helper.post('${Constants.reservationsUrl}', jsonEncode({'person_id': userID}));

    print('response : $response');

    return ReservationResponse.fromJson(response).results;

  }

  Future<dynamic> makeReservation(Map<String, dynamic> body) async {
    final response = await _helper.post('${Constants.makeReservationUrl}', jsonEncode(body));

    print('response : $response');

    return response;
  }

  Future<dynamic> cancelReservation(Map<String, String> body) async {
    final response = await _helper.post('${Constants.reservationCancellationUrl}', jsonEncode(body));

    print('response : $response');

    return response;
  }

  Future<dynamic> completeReservation(Map<String, String> body) async {
    final response = await _helper.post('${Constants.completeReservationUrl}', jsonEncode(body));

    print('response : $response');

    return response;
  }

}
