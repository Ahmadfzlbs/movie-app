import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/movies.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller responsible for managing the home screen's data, including
/// fetching and storing movies, handling favorites and watchlists, and
/// managing interactions with external APIs. Uses GetX for state management.
class HomeController extends GetxController {
  /// A set of favorite movie IDs, stored in reactive state.
  var favoriteMovies = <int>{}.obs;

  /// A set of watchlist movie IDs, stored in reactive state.
  var watchlistMovies = <int>{}.obs;

  /// The base URL for the API, loaded from environment variables.
  var api = '${dotenv.env['API_URL']}';

  /// The currently playing movies, stored in reactive state.
  var nowPlaying = Rx<Movies?>(null);

  /// The popular movies, stored in reactive state.
  var popularMovie = Rx<Movies?>(null);

  @override
  void onInit() {
    super.onInit();
    loadFavoriteMoviesFromLocalStorage();
    loadWatchlistMoviesFromLocalStorage();
    loadDataFromLocalStorage();
    fetchNowPlaying();
    fetchPopular();
  }

  /// Checks whether a movie with the given [movieId] is in the favorites list.
  ///
  /// Returns `true` if the movie is a favorite, otherwise `false`.
  bool isFavoriteMovie(int movieId) {
    return favoriteMovies.contains(movieId);
  }

  /// Checks whether a movie with the given [movieId] is in the watchlist.
  ///
  /// Returns `true` if the movie is in the watchlist, otherwise `false`.
  bool isWatchlistMovie(int movieId) {
    return watchlistMovies.contains(movieId);
  }

  /// Loads the favorite movies from local storage (SharedPreferences).
  ///
  /// Updates the [favoriteMovies] set with the loaded data.
  Future<void> loadFavoriteMoviesFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteMovieIds = prefs
            .getStringList('favoriteMovies')
            ?.map((id) => int.parse(id))
            .toSet() ??
        <int>{};

    // Update the observable set with the new data
    favoriteMovies
      ..clear()
      ..addAll(favoriteMovieIds);
  }

  /// Loads the watchlist movies from local storage (SharedPreferences).
  ///
  /// Updates the [watchlistMovies] set with the loaded data.
  Future<void> loadWatchlistMoviesFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final watchlistMovieIds = prefs
            .getStringList('watchlistMovies')
            ?.map((id) => int.parse(id))
            .toSet() ??
        <int>{};

    // Update the observable set with the new data
    watchlistMovies
      ..clear()
      ..addAll(watchlistMovieIds);
  }

  /// Saves the current [favoriteMovies] to local storage (SharedPreferences).
  ///
  /// Converts the set of movie IDs to a list of strings before saving.
  Future<void> saveFavoriteMoviesToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'favoriteMovies', favoriteMovies.map((id) => id.toString()).toList());
  }

  /// Saves the current [watchlistMovies] to local storage (SharedPreferences).
  ///
  /// Converts the set of movie IDs to a list of strings before saving.
  Future<void> saveWatchlistMoviesToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'watchlistMovies', watchlistMovies.map((id) => id.toString()).toList());
  }

  /// Adds a movie with the given [movieId] to the favorites list.
  ///
  /// Sends a request to the API to mark the movie as a favorite and
  /// updates the local state and storage if successful.
  Future<void> addFavoriteMovie(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('session_id');
    final accountId = prefs.getInt('account_id');

    if (sessionId == null || accountId == null) {
      Get.snackbar("Error", "Session ID or Account ID not found");
      return;
    }

    var url = Uri.https(
        api, '3/account/$accountId/favorite', {'session_id': sessionId});

    var headers = {
      'Authorization': '${dotenv.env['ACCESS_TOKEN']}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      'media_id': movieId,
      'media_type': 'movie',
      'favorite': true,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        favoriteMovies.add(movieId); // Add to local favorites list
        saveFavoriteMoviesToLocalStorage(); // Save updated list
        Get.snackbar("Success", "Movie added to favorites");
      } else {
        var errorResponse = json.decode(response.body);
        Get.snackbar("Error",
            "Failed to add movie to favorites: ${errorResponse['status_message']}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  /// Adds a movie with the given [movieId] to the watchlist.
  ///
  /// Sends a request to the API to add the movie to the watchlist and
  /// updates the local state and storage if successful.
  Future<void> addWatchlistMovie(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('session_id');
    final accountId = prefs.getInt('account_id');

    if (sessionId == null || accountId == null) {
      Get.snackbar("Error", "Session ID or Account ID not found");
      return;
    }

    var url = Uri.https(
        api, '3/account/$accountId/watchlist', {'session_id': sessionId});

    var headers = {
      'Authorization': '${dotenv.env['ACCESS_TOKEN']}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      'media_id': movieId,
      'media_type': 'movie',
      'watchlist': true,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        watchlistMovies.add(movieId); // Add to local watch list
        saveWatchlistMoviesToLocalStorage(); // Save updated list
        Get.snackbar("Success", "Movie added to watchlist");
      } else {
        var errorResponse = json.decode(response.body);
        Get.snackbar("Error",
            "Failed to add movie to watchlist: ${errorResponse['status_message']}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  /// Removes a movie with the given [movieId] from the favorites list.
  ///
  /// Sends a request to the API to remove the movie from favorites and
  /// updates the local state and storage if successful.
  Future<void> removeFavoriteMovie(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('session_id');
    final accountId = prefs.getInt('account_id');

    if (sessionId == null || accountId == null) {
      Get.snackbar("Error", "Session ID or Account ID not found");
      return;
    }

    var url = Uri.https(
        api, '3/account/$accountId/favorite', {'session_id': sessionId});

    var headers = {
      'Authorization': '${dotenv.env['ACCESS_TOKEN']}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      'media_id': movieId,
      'media_type': 'movie',
      'favorite': false,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        favoriteMovies.remove(movieId); // Remove from local favorites list
        saveFavoriteMoviesToLocalStorage(); // Save updated list
        Get.snackbar("Success", "Movie removed from favorites");
      } else {
        var errorResponse = json.decode(response.body);
        Get.snackbar("Error",
            "Failed to remove movie from favorites: ${errorResponse['status_message']}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  /// Removes a movie with the given [movieId] from the watchlist.
  ///
  /// Sends a request to the API to remove the movie from the watchlist and
  /// updates the local state and storage if successful.
  Future<void> removeWatchlistMovie(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('session_id');
    final accountId = prefs.getInt('account_id');

    if (sessionId == null || accountId == null) {
      Get.snackbar("Error", "Session ID or Account ID not found");
      return;
    }

    var url = Uri.https(
        api, '3/account/$accountId/watchlist', {'session_id': sessionId});

    var headers = {
      'Authorization': '${dotenv.env['ACCESS_TOKEN']}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      'media_id': movieId,
      'media_type': 'movie',
      'watchlist': false,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        favoriteMovies.remove(movieId); // Remove from local watch list
        saveWatchlistMoviesToLocalStorage(); // Save updated list
        Get.snackbar("Success", "Movie removed from watchlist");
      } else {
        var errorResponse = json.decode(response.body);
        Get.snackbar("Error",
            "Failed to remove movie from watchlist: ${errorResponse['status_message']}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  /// Fetches the list of now playing movies from the API.
  ///
  /// Updates the [nowPlaying] observable and saves the data to local storage.
  Future<void> fetchNowPlaying() async {
    var url = Uri.https(api, '${dotenv.env['URL_NOW_PLAYING']}');
    var headers = {'Authorization': '${dotenv.env['ACCESS_TOKEN']}'};

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        nowPlaying.value = Movies.fromJson(jsonResponse);
        saveDataToLocalStorage('nowPlaying', jsonResponse);
      } else {
        Get.snackbar("Error", "Failed to fetch data");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  /// Fetches the list of popular movies from the API.
  ///
  /// Updates the [popularMovie] observable and saves the data to local storage.
  Future<void> fetchPopular() async {
    var url = Uri.https(api, '${dotenv.env['URL_POPULAR']}');
    var headers = {'Authorization': '${dotenv.env['ACCESS_TOKEN']}'};

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        popularMovie.value = Movies.fromJson(jsonResponse);
        saveDataToLocalStorage('popularMovie', jsonResponse);
      } else {
        Get.snackbar("Error", "Failed to fetch data");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  /// Saves movie data to local storage (SharedPreferences).
  ///
  /// [key] is the key under which the data is stored.
  /// [data] is the JSON data to be saved.
  Future<void> saveDataToLocalStorage(
      String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  /// Loads movie data from local storage (SharedPreferences).
  ///
  /// Updates the [nowPlaying] and [popularMovie] observables if data is found.
  Future<void> loadDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final nowPlayingData = prefs.getString('nowPlaying');
    final popularMovieData = prefs.getString('popularMovie');

    if (nowPlayingData != null) {
      nowPlaying.value = Movies.fromJson(jsonDecode(nowPlayingData));
    }

    if (popularMovieData != null) {
      popularMovie.value = Movies.fromJson(jsonDecode(popularMovieData));
    }
  }
}
