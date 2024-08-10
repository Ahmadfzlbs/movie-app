import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controllers/home.controller.dart';

class PopularWidget extends StatefulWidget {
  final List movies;
  final String imageBaseUrl;
  final Function(String) onTap;

  const PopularWidget({
    super.key,
    required this.movies,
    required this.imageBaseUrl,
    required this.onTap,
  });

  @override
  _PopularWidget createState() => _PopularWidget();
}

class _PopularWidget extends State<PopularWidget> {
  final Map<String, bool> _favorites = {};
  final Map<String, bool> _watchlist = {};

  @override
  void initState() {
    super.initState();
    // Fetch initial favorite status from controller
    final homeController = Get.find<HomeController>();
    for (var movie in widget.movies) {
      final movieId = movie.id.toString();
      _favorites[movieId] = homeController.isFavoriteMovie(int.parse(movieId));
      _watchlist[movieId] = homeController.isWatchlistMovie(int.parse(movieId));
    }
  }

  @override
  Widget build(BuildContext context) {
    const int maxItemCount = 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Now Playing",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "See All",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: widget.movies.length > maxItemCount
                ? maxItemCount
                : widget.movies.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              final movieId = movie.id.toString();
              final isFavorite = _favorites[movieId] ?? false;
              final isWatchlist = _watchlist[movieId] ?? false;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  onTap: () => widget.onTap(movieId),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.white,
                              height: 250,
                              width: 150,
                              child: Image.network(
                                '${widget.imageBaseUrl}${movie.posterPath}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          isFavorite ? redColor : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _favorites[movieId] = !isFavorite;
                                        if (_favorites[movieId] == true) {
                                          Get.find<HomeController>()
                                              .addFavoriteMovie(
                                                  int.parse(movieId));
                                        } else {
                                          Get.find<HomeController>()
                                              .removeFavoriteMovie(
                                                  int.parse(movieId));
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  IconButton(
                                    icon: Icon(
                                      isWatchlist
                                          ? Icons.watch_later
                                          : Icons.watch_later_outlined,
                                      color: isWatchlist
                                          ? Colors.orange
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _watchlist[movieId] = !isWatchlist;
                                        if (_watchlist[movieId] == true) {
                                          Get.find<HomeController>()
                                              .addWatchlistMovie(
                                                  int.parse(movieId));
                                        } else {
                                          Get.find<HomeController>()
                                              .removeWatchlistMovie(
                                                  int.parse(movieId));
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 150,
                        child: Text(
                          textAlign: TextAlign.center,
                          movie.title.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
