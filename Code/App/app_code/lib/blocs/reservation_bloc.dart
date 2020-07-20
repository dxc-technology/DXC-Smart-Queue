import 'dart:async';

import 'package:mtahackathon/api/api_response.dart';
import 'package:mtahackathon/models/Queue.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/repositories/reservations_repository.dart';
import 'package:mtahackathon/utils/constants.dart';

class ReservationBloc {


  List<Reservation> reservations = [];

  ReservationsRepository _reservationsRepository;

  StreamController _movieListController;

  StreamSink<ApiResponse<List<Reservation>>> get reservationListSink =>
      _movieListController.sink;

  Stream<ApiResponse<List<Reservation>>> get reservationListStream =>
      _movieListController.stream;

  ReservationBloc() {
    _movieListController = StreamController<ApiResponse<List<Reservation>>>.broadcast();
    _reservationsRepository = ReservationsRepository();
  }

  fetchReservationsList() async {
    reservationListSink.add(ApiResponse.loading('Fetching Reservations..'));
    try {
      reservations = await _reservationsRepository.fetchReservationList(Constants.personId);

      // List<Reservation> movies = await _getDummyReservations();
      reservationListSink.add(ApiResponse.completed(reservations));
    } catch (e) {
      reservationListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  Future<dynamic> makeReservation(Queue queue) async {

    Map<String, dynamic> makeReserveBody = {
      "person_id": Constants.personId,
      "proof_of_purchase": "",
      "occupants": 1,
      "queue_id": queue.queueId
    };

    dynamic result =  await _reservationsRepository.makeReservation(makeReserveBody);

    return result;
  }

  Future<dynamic> cancelReservation(Reservation reservation) async {

    Map<String, String> cancelBody = {
      "person_id": Constants.personId,
      "queue_id": reservation.queueId
    };

    List<dynamic> result =  await _reservationsRepository.cancelReservation(cancelBody);

    reservations.removeWhere((element) => element.queueId == reservation.queueId);

    reservationListSink.add(ApiResponse.completed(reservations));

    return result;
  }

  Future<dynamic> completeReservation(Reservation reservation) async {
    Map<String, String> completeBody = {
      "person_id": Constants.personId,
      "queue_id": reservation.queueId
    };

    List<dynamic> result =  await _reservationsRepository.completeReservation(completeBody);

    reservations.forEach((element) {
      if (element.id == reservation.id) {
        element..reservationState = "ReservationState.COMPLETED";
      }
    });

    reservationListSink.add(ApiResponse.completed(reservations));

    return result;
  }

  num getTotalRewardPoints() {
    int totalPoints = 0;
    getCompletedReservations().forEach((element) {
      totalPoints+= element.pointsWorth;
    });

    return totalPoints;
  }


  List<Reservation> getActiveReservations() {
    return reservations.where((element) => element.reservationState == "ReservationState.RESERVED").toList();
  }

  List<Reservation> getCompletedReservations() {
    return reservations.where((element) => element.reservationState == "ReservationState.COMPLETED").toList();
  }

//  Future<List<Reservation>> _getDummyReservations() async {
//    Reservation reservation1 = Reservation(
//      arrivalStation: 'St. Columbus Cir',
//      departureStation: 'Queens Blvd',
//      trainId: '8 Avenue Express',
//      queueOpenMillis: 1594276200000,
//      queueCloseMillis: 1594276560000,
//      etaMillis: 1594276680000,
//      id: 1234,
//      pointsWorth: 100,
//      queueOccupancyPercentage: 56,
//      trainOccupancyPercentage: 78
//    );
//    Reservation reservation2 = Reservation(
//        arrivalStation: 'Queens Blvd',
//        departureStation: 'St. Columbus Cir',
//        trainId: 'Lexington Avenue Express',
//        queueOpenMillis: 1594293000000,
//        queueCloseMillis: 1594293360000,
//        etaMillis: 1594293480000,
//        id: 1432,
//        pointsWorth: 350,
//        queueOccupancyPercentage: 32,
//        trainOccupancyPercentage: 55
//    );
//
//    return Future.delayed(Duration(seconds: 3), () { return Future<List<Reservation>>.value(([reservation1, reservation2, reservation1, reservation2])); });
//
//  }

  dispose() {
    _movieListController?.close();
  }

}

final reservationBloc = ReservationBloc();