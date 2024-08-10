import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/movies.dart';

/// Controller responsible for managing and fetching the list of movies in the user's watchlist.
/// Utilizes GetX for state management and handles API interactions.
class WatchlistController extends GetxController {
  /// Loading state observable to indicate if the data is currently being fetched.
  RxBool isLoading = false.obs;

  /// The base URL for the API, loaded from environment variables.
  var api = '${dotenv.env['API_URL']}';

  /// Stores the list of movies in the user's watchlist.
  var watchlistMovie = Rx<Movies?>(null);

  /// Fetches the list of movies in the user's watchlist.
  ///
  /// This method retrieves the account ID from shared preferences and sends a GET request to the watchlist endpoint.
  /// The response is then deserialized and stored in the [watchlistMovie] observable.
  Future<void> fetchWatchlistMovie() async {
    final prefs = await SharedPreferences.getInstance();
    final accountId = prefs.getInt('account_id');
    isLoading.value = true;

    if (accountId == null) {
      isLoading.value = false;
      Get.snackbar("Error", "Account ID not found.");
      return;
    }

    var url = Uri.https(api, '/3/account/$accountId/watchlist/movies');
    var headers = {
      'Authorization': '${dotenv.env['ACCESS_TOKEN']}',
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        watchlistMovie.value = Movies.fromJson(jsonResponse);
      } else {
        Get.snackbar("Error", "Failed to fetch data.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
