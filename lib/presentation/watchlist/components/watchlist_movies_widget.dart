import 'package:flutter/material.dart';

class WatchlistMoviesWidget extends StatelessWidget {
  final List watchlistMovies;
  final String imageBaseUrl;

  const WatchlistMoviesWidget(
      {super.key, required this.watchlistMovies, required this.imageBaseUrl});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: watchlistMovies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.5,
      ),
      itemBuilder: (context, index) {
        var watchlistMovie = watchlistMovies[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: watchlistMovie.posterPath != null
                  ? Image.network(
                      '$imageBaseUrl${watchlistMovie.posterPath}',
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
              watchlistMovie.title,
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
