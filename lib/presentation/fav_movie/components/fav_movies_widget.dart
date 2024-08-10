import 'package:flutter/material.dart';

class FavMoviesWidget extends StatelessWidget {
  final List favMovies;
  final String imageBaseUrl;

  const FavMoviesWidget({
    super.key,
    required this.favMovies,
    required this.imageBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: favMovies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.5,
      ),
      itemBuilder: (context, index) {
        var favMovie = favMovies[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: favMovie.posterPath != null
                  ? Image.network(
                      '$imageBaseUrl${favMovie.posterPath}',
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
              favMovie.title,
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
    );
  }
}
