import 'package:mtahackathon/api/api_base_helper.dart';
import 'package:mtahackathon/models/reward_point.dart';
import 'package:mtahackathon/responses/reward_points_response.dart';
import 'package:mtahackathon/utils/constants.dart';

class RewardPointsRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<RewardPoint>> fetchRewardPoints() async {
    final response = await _helper.get(Constants.apiBaseUrl);
    return RewardPointsResponse.fromJson(response).results;
  }
}
