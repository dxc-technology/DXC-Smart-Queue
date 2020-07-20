import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:mtahackathon/api/api_response.dart';
import 'package:mtahackathon/models/Queue.dart';
import 'package:mtahackathon/models/location.dart';
import 'package:mtahackathon/models/train_schedule.dart';
import 'package:mtahackathon/repositories/train_schedule.dart';
import 'package:rxdart/rxdart.dart';

class TrainSearchBloc extends Validators {

  List<Location> locations = [];
  List<Queue> queues = [];

  TrainScheduleRepository _trainScheduleRepository;

  StreamController _trainScheduleListController;
  StreamController _locationsController;
  StreamController _locationsSearchController;

  StreamSink<ApiResponse<List<Queue>>> get queueListSink =>
      _trainScheduleListController.sink;

  Stream<ApiResponse<List<Queue>>> get queueListStream =>
      _trainScheduleListController.stream;

  StreamSink<ApiResponse<List<Location>>> get locationsSink =>
      _locationsController.sink;

  Stream<ApiResponse<List<Location>>> get locationsStream =>
      _locationsController.stream;

  StreamSink<ApiResponse<List<Location>>> get locationsSearchSink =>
      _locationsController.sink;

  Stream<ApiResponse<List<Location>>> get locationsSearchStream =>
      _locationsController.stream;

  TrainSearchBloc() {
    _trainScheduleListController = StreamController<ApiResponse<List<Queue>>>.broadcast();
    _locationsController = StreamController<ApiResponse<List<Location>>>.broadcast();
    _locationsSearchController = StreamController<ApiResponse<List<Location>>>.broadcast();
    _trainScheduleRepository = TrainScheduleRepository();
    getLocations();
  }

  final BehaviorSubject _fromController = BehaviorSubject<Location>();
  final BehaviorSubject _toController = BehaviorSubject<Location>();
  final BehaviorSubject _dateController = BehaviorSubject<DateTime>();
  final BehaviorSubject _timeController = BehaviorSubject<TimeOfDay>();

  TextEditingController fromTextEditController = new TextEditingController();
  TextEditingController toTextEditController = new TextEditingController();

  Function(Location) get changeFrom => _fromController.sink.add;
  Function(Location) get changeTo => _toController.sink.add;
  Function(DateTime) get changeDate => _dateController.sink.add;
  Function(TimeOfDay) get changeTime => _timeController.sink.add;

  Stream<Location> get from => _fromController.stream.transform(validateFrom);
  Stream<Location> get to => _toController.stream.transform(validateTo);
  Stream<DateTime> get date => _dateController.stream.transform(validateDate);
  Stream<TimeOfDay> get time => _timeController.stream.transform(validateTime);

  void setSavedStations(Location from, Location to) {
    fromTextEditController.text = from.address;
    toTextEditController.text = to.address;
  }

  Future<void> searchTrains() async {
    queueListSink.add(ApiResponse.loading('Fetching train options..'));
    try {

      Map<String, dynamic> queueSearchPayload = {
        'resource_id': 1,
        'address': _fromController.value.address,
        'destination': _toController.value.address,
        'address_id': _fromController.value.addressId,
        'datetime': _getFormattedDateTime(_dateController?.value ?? DateTime.now(), _timeController?.value ?? TimeOfDay.now()),
        'sort_bestqueue': false
      };

      queues = await _trainScheduleRepository.fetchTrainQueues(queueSearchPayload);

      // List<TrainSchedule> movies = await _getDummyReservations();
      queueListSink.add(ApiResponse.completed(queues));
    } catch (e) {
      queueListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  Future<void> sortQueues() async {
    queueListSink.add(ApiResponse.loading('Sorting queues..'));
    try {

      queues.sort((q1, q2) => q1.rewardPoints.compareTo(q2.rewardPoints));

      // List<TrainSchedule> movies = await _getDummyReservations();
      queueListSink.add(ApiResponse.completed(queues));
    } catch (e) {
      queueListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  String _getFormattedDateTime(DateTime date, TimeOfDay time) {
    String dateStr = DateFormat('yyyy/MM/dd').format(date);
    String timeStr = '${_getFormattedHour(time.hour)}${_getFormattedHour(time.minute)}';

    return '$dateStr $timeStr';
  }

  String _getFormattedHour(num hour) {
    if (hour == 0) {
      return '00';
    } else if (hour < 10) {
      return '0$hour';
    } else return hour.toString();
  }

  void dispose() {
    _trainScheduleListController.close();
    _fromController.close();
    _toController.close();
    _dateController.close();
    _timeController.close();
    _locationsController.close();
    _locationsSearchController.close();
  }

  Future<void> getLocations() async {

    if (locations != null && locations.isNotEmpty) {
      locationsSink.add(ApiResponse.completed(locations));
    } else {
      locationsSink.add(ApiResponse.loading('Loading locations..'));

      List<Location> results = await _trainScheduleRepository.getLocations();

      List<num> addedIds = [];
      locations.clear();
      results.forEach((element) {
        if (!addedIds.contains(element.addressId)) {
          addedIds.add(element.addressId);
          locations.add(element);
        }
      });

      print('locations loaded : $locations');
      locationsSink.add(ApiResponse.completed(locations));
    }
  }

  filterLocations(String searchTerm) async {
    locationsSearchSink.add(ApiResponse.loading('Loading...'));
    if (locations != null) {
      List<Location> results;
      if (searchTerm == null || searchTerm.isEmpty) {
        results = locations;
      } else {
        results = locations.where((element) =>
        (_getRegExp(searchTerm).hasMatch(element.address))).toList() ?? [];
      }
      results.sort((a, b) => a.address.compareTo(b.address));
      locationsSearchSink.add(ApiResponse.completed(results));
    } else {
      getLocations();
    }
  }

  Queue getBestQueue(List<Queue> queuesList) {
    Queue bestQueue;
    queuesList.forEach((element) {
      if (bestQueue == null) {
        bestQueue = element;
      } else if (bestQueue.rewardPoints < element.rewardPoints) {
        bestQueue = element;
      }
    });

    return bestQueue;
  }


  Future<List<TrainSchedule>> _getDummyReservations() async {

//    TrainSchedule reservation1 = TrainSchedule(
//        arrivalStation: 'St. Columbus Cir',
//        departureStation: 'Queens Blvd',
//        trainId: '8 Avenue Express',
//        queueOpenMillis: 1594276200000,
//        queueCloseMillis: 1594276560000,
//        etaMillis: 1594276680000,
//        id: 1234,
//        pointsWorth: 100,
//        queueOccupancyPercentage: 56,
//        trainOccupancyPercentage: 78);
//
//    TrainSchedule reservation2 = TrainSchedule(
//        arrivalStation: 'Queens Blvd',
//        departureStation: 'St. Columbus Cir',
//        trainId: 'Lexington Avenue Express',
//        queueOpenMillis: 1594293000000,
//        queueCloseMillis: 1594293360000,
//        etaMillis: 1594293480000,
//        id: 1432,
//        pointsWorth: 350,
//        queueOccupancyPercentage: 32,
//        trainOccupancyPercentage: 55);
//
//    return Future.delayed(Duration(seconds: 3), () {
//      return Future<List<TrainSchedule>>.value(
//          ([reservation1, reservation2, reservation1, reservation2]));
//    });
  }

}

class Validators {
  final validateFrom = StreamTransformer<Location, Location>.fromHandlers(
      handleData: (Location from, EventSink<Location> sink) {
    if (from != null && from.address.isNotEmpty) {
      sink.add(from);
    } else {
      sink.addError('From is a required field');
    }
  });

  final validateTo = StreamTransformer<Location, Location>.fromHandlers(
      handleData: (Location to, EventSink<Location> sink) {
    if (to != null && to.address.isNotEmpty) {
      sink.add(to);
    } else {
      sink.addError('To is a required field');
    }
  });

  final validateDate = StreamTransformer<DateTime, DateTime>.fromHandlers(
      handleData: (DateTime date, EventSink<DateTime> sink) {
    sink.add(date);
  });

  final validateTime = StreamTransformer<TimeOfDay, TimeOfDay>.fromHandlers(
      handleData: (TimeOfDay time, EventSink<TimeOfDay> sink) {
    sink.add(time);
  });

  /// Regular expression to filter meal items in the search page.
  /// the search query is matched with the beginning of the words in the entire sentence.
  RegExp _getRegExp(query) => RegExp(
    "\\b$query[a-zA-Z]*\\b",
    caseSensitive: false,
    multiLine: false,
  );

}

final trainSearchBloc = TrainSearchBloc();
