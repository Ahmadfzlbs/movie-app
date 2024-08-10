import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'components/watchlist_movies_widget.dart';

import 'controllers/watchlist.controller.dart';

class WatchlistScreen extends GetView<WatchlistController> {
  const WatchlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    controller.fetchWatchlistMovie();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // If no favorite movies are found (empty state)
        if (controller.watchlistMovie.value == null ||
            controller.watchlistMovie.value!.results.isEmpty) {
          return const Center(child: Text("No Watchlist Movies found"));
        }

        // Display watchlist movies
        var watchlistMovies = controller.watchlistMovie.value!.results;
        var imageBaseUrl = '${dotenv.env['IMAGE_BASE_URL']}';

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: WatchlistMoviesWidget(
            watchlistMovies: watchlistMovies,
            imageBaseUrl: imageBaseUrl,
          ),
        );
      }),
    );
  }
}
