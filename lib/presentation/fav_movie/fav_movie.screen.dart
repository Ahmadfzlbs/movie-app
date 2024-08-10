import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'components/fav_movies_widget.dart';
import 'controllers/fav_movie.controller.dart';

class FavMovieScreen extends GetView<FavMovieController> {
  const FavMovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchFavoriteMovie();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movie'),
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // If no favorite movies are found (empty state)
        if (controller.favMovie.value == null || controller.favMovie.value!.results.isEmpty) {
          return const Center(child: Text("No Favorite Movies found"));
        }

        // Display favorite movies
        var favMovies = controller.favMovie.value!.results;
        var imageBaseUrl = '${dotenv.env['IMAGE_BASE_URL']}';

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: FavMoviesWidget(
            favMovies: favMovies,
            imageBaseUrl: imageBaseUrl,
          ),
        );
      }),
    );
  }
}
