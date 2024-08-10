import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import 'components/similar_movies_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'controllers/detail_movie.controller.dart';

class DetailMovieScreen extends GetView<DetailMovieController> {
  const DetailMovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String movieId = Get.arguments;

    controller.fetchDetailMovie(movieId);
    controller.fetchSimilarMovie(movieId);

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.detailMovie.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.similarMovie.value == null) {
            return const SizedBox.shrink();
          }

          var movie = controller.detailMovie.value!;
          var similarMovies = controller.similarMovie.value!.results;
          var imageBaseUrl = '${dotenv.env['IMAGE_BASE_URL']}';

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          color: Colors.amber,
                          height: 150,
                          width: 100,
                          child: Image.network(
                            '$imageBaseUrl${movie.posterPath}',
                            fit: BoxFit.cover,
                          )),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 10),
                          // Genre Containers
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: movie.genres.map((genre) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: orangeColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  genre.name,
                                  style: const TextStyle(
                                      fontSize: 16, color: whiteColor),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Synopsis",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  movie.overview,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),

                // Similar Movies
                SimilarMoviesWidget(
                  similarMovies: similarMovies,
                  imageBaseUrl: imageBaseUrl,
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
