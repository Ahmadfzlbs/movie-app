import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/movies.dart';

/// Controller responsible for managing and fetching the user's favorite movies.
/// Uses GetX for state management and handles API interactions.
class FavMovieController extends GetxController {
  /// Indicates whether the controller is currently loading data.
  RxBool isLoading = false.obs;

  /// The base URL for the API, loaded from environment variables.
  var api = '${dotenv.env['API_URL']}';

  /// The list of favorite movies, stored in reactive state.
  var favMovie = Rx<Movies?>(null);

  /// Fetches the list of favorite movies for the current user.
  ///
  /// This method retrieves the account ID from local storage and makes an
  /// API request to fetch the user's favorite movies. The [favMovie] observable
  /// is updated with the data if the request is successful.
  Future<void> fetchFavoriteMovie() async {
    final prefs = await SharedPreferences.getInstance();
    final accountId = prefs.getInt('account_id');
    isLoading.value = true;

    if (accountId == null) {
      isLoading.value = false;
      Get.snackbar("Error", "Account ID not found.");
      return;
    }

    var url = Uri.https(api, '/3/account/$accountId/favorite/movies');
    var headers = {
      'Authorization': '${dotenv.env['ACCESS_TOKEN']}',
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        favMovie.value = Movies.fromJson(jsonResponse);
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
