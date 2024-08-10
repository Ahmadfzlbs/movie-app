import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/detail_movie.dart';
import '../../../models/movies.dart';

/// Controller responsible for managing the details of a specific movie and fetching similar movies.
/// Utilizes GetX for state management and handles API interactions.
class DetailMovieController extends GetxController {
  /// The base URL for the API, loaded from environment variables.
  var api = '${dotenv.env['API_URL']}';

  /// Stores the detailed information of a specific movie.
  var detailMovie = Rx<DetailMovie?>(null);

  /// Stores the list of movies similar to the current movie.
  var similarMovie = Rx<Movies?>(null);

  /// Fetches detailed information for a specific movie by its [id].
  ///
  /// This method sends a GET request to the movie detail endpoint and updates the [detailMovie] observable with the response data.
  Future<void> fetchDetailMovie(String id) async {
    var url = Uri.https(api, '/3/movie/$id');

    var headers = {
      'Authorization': '${dotenv.env['ACCESS_TOKEN']}',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      detailMovie.value = DetailMovie.fromJson(jsonResponse);
    } else {
      Get.snackbar("Error", "Fetch data failed.");
    }
  }

  /// Fetches a list of movies similar to the movie with the given [id].
  ///
  /// This method sends a GET request to the similar movies endpoint and updates the [similarMovie] observable with the response data.
  Future<void> fetchSimilarMovie(String id) async {
    var url = Uri.https(api, '3/movie/$id/similar');

    var headers = {
      'Authorization': '${dotenv.env['ACCESS_TOKEN']}',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      similarMovie.value = Movies.fromJson(jsonResponse);
    } else {
      Get.snackbar("Error", "Fetch data failed.");
    }
  }
}
