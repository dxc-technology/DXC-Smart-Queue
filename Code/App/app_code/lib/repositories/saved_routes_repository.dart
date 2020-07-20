import 'package:mtahackathon/api/api_base_helper.dart';
import 'package:mtahackathon/models/saved_route.dart';
import 'package:mtahackathon/responses/saved_routes_response.dart';
import 'package:mtahackathon/utils/constants.dart';

class SavedRoutesRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<SavedRoute>> fetchSavedRoutes() async {
    final response = await _helper.get(Constants.apiBaseUrl);
    return SavedRoutesResponse.fromJson(response).results;
  }
}