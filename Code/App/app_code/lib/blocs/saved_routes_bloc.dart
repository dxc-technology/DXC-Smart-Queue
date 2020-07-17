import 'dart:async';

import 'package:mtahackathon/api/api_response.dart';
import 'package:mtahackathon/models/saved_route.dart';
import 'package:mtahackathon/repositories/saved_routes_repository.dart';

class SavedRouteBloc {


  SavedRoutesRepository _savedRoutesRepository;

  StreamController _savedRoutesController;

  StreamSink<ApiResponse<List<SavedRoute>>> get savedRoutesSink =>
      _savedRoutesController.sink;

  Stream<ApiResponse<List<SavedRoute>>> get savedRoutesStream =>
      _savedRoutesController.stream;

  SavedRouteBloc() {
    _savedRoutesController = StreamController<ApiResponse<List<SavedRoute>>>.broadcast();
    _savedRoutesRepository = SavedRoutesRepository();
  }


  Future<void> getSavedRoutes() async {
    savedRoutesSink.add(ApiResponse.loading('Fetching saved routes..'));
    try {
      // List<Reservation> movies = await _reservationsRepository.fetchMovieList();

      List<SavedRoute> savedRoutes = await _getDummySavedRoutes();
      savedRoutesSink.add(ApiResponse.completed(savedRoutes));
    } catch (e) {
      savedRoutesSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  Future<List<SavedRoute>> _getDummySavedRoutes() async {

    SavedRoute route1 = SavedRoute(id: 1, fromStation: 'Queens Blvd', toStation: 'St. Columbus Cir');
    SavedRoute route2 = SavedRoute(id: 1, fromStation: 'Queens Blvd', toStation: 'St. Columbus Cir');
    SavedRoute route3 = SavedRoute(id: 1, fromStation: 'Queens Blvd', toStation: 'St. Columbus Cir');

    return Future.delayed(Duration(seconds: 3), () {
      return Future<List<SavedRoute>>.value(
          ([route1, route2, route3]));
    });
  }

  void dispose() {
    _savedRoutesController.close();
  }

}

final savedRouteBloc = SavedRouteBloc();