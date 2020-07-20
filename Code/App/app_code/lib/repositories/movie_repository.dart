/*
use a Repository class which going to act as the inter-mediator and
a layer of abstraction between the APIs and the BLOC.
        
The task of the repository is to deliver movies data
to the BLOC after fetching it from the API.
 */

import 'package:mtahackathon/api/api_base_helper.dart';
import 'package:mtahackathon/models/movie.dart';
import 'package:mtahackathon/responses/movie_response.dart';
import 'package:mtahackathon/utils/constants.dart';

class MovieRepository {

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Movie>> fetchMovieList() async {
    final response = await _helper.get(Constants.apiBaseUrl);
    return MovieResponse.fromJson(response).results;
  }
}
  