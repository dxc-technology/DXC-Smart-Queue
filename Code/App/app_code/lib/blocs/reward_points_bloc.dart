import 'dart:async';

import 'package:mtahackathon/api/api_response.dart';
import 'package:mtahackathon/models/reward_point.dart';
import 'package:mtahackathon/repositories/reward_points_repository.dart';

class RewardPointsBloc {
  RewardPointsRepository _rewardPointsRepository;

  StreamController _rewardPointsController;

  StreamSink<ApiResponse<List<RewardPoint>>> get rewardPointsSink =>
      _rewardPointsController.sink;

  Stream<ApiResponse<List<RewardPoint>>> get rewardPointsStream =>
      _rewardPointsController.stream;

  RewardPointsBloc() {
    _rewardPointsController = StreamController<ApiResponse<List<RewardPoint>>>.broadcast();
    _rewardPointsRepository = RewardPointsRepository();
  }

  fetchRewardsList() async {
    rewardPointsSink.add(ApiResponse.loading('Fetching Reward points data..'));
    try {
      // List<Reservation> movies = await _reservationsRepository.fetchMovieList();

      List<RewardPoint> movies = await _getDummyRewardPoints();
      rewardPointsSink.add(ApiResponse.completed(movies));
    } catch (e) {
      rewardPointsSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  Future<List<RewardPoint>> _getDummyRewardPoints() async {
    RewardPoint point1 = RewardPoint.name(123, 100, '1594297220000');
    RewardPoint point2 = RewardPoint.name(123, 250, '1594124420000');
    RewardPoint point3 = RewardPoint.name(123, 300, '1593951620000');

    return Future.delayed(Duration(seconds: 3), () {
      return Future<List<RewardPoint>>.value(
          ([point1, point2, point3, point2]));
    });
  }

  dispose() {
    _rewardPointsController?.close();
  }
}

final rewardPointsBloc = RewardPointsBloc();
