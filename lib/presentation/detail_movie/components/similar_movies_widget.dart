// similar_movies_widget.dart
import 'package:flutter/material.dart';
import 'package:movie_app/constants.dart';

class SimilarMoviesWidget extends StatelessWidget {
  final List similarMovies;
  final String imageBaseUrl;

  const SimilarMoviesWidget({
    super.key,
    required this.similarMovies,
    required this.imageBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Similar Movie",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "See All",
                style: TextStyle(color: orangeColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: similarMovies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 0.5, // Adjusted for the height of 250
          ),
          itemBuilder: (context, index) {
            var similarMovie = similarMovies[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: similarMovie.posterPath != null
                      ? Image.network(
                          '$imageBaseUrl${similarMovie.posterPath}',
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/placeholder.png',
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 5),
                Text(
                  similarMovie.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
