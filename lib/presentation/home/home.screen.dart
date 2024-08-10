import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../infrastructure/navigation/routes.dart';
import 'components/menu.dart';
import 'components/now_playing_movies_widget.dart';
import 'components/popular_movies_widget.dart';
import '../screens.dart';

import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const ProfileScreen());
            },
            icon: const Icon(
              Icons.person,
            ),
          ),
        ],
        backgroundColor: whiteColor,
        title: const Text(
          'e-Tix',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Obx(() {
        if (controller.nowPlaying.value == null ||
            controller.popularMovie.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        var nowPlayingMovies = controller.nowPlaying.value!.results;
        var popularMovies = controller.popularMovie.value!.results;
        String imageBaseUrl = '${dotenv.env['IMAGE_BASE_URL']}';

        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Menu(
                      onTap: () => Get.to(() => const FavMovieScreen()),
                      color: blueColor.withOpacity(0.2),
                      title: "Fav Movies",
                      imagePath: "assets/images/movie.png"),
                  Menu(
                      onTap: () {},
                      color: redColor.withOpacity(0.2),
                      title: "Food",
                      imagePath: "assets/images/popcorn.png"),
                  Menu(
                      onTap: () => Get.to(() => const WatchlistScreen()),
                      color: blueColor.withOpacity(0.2),
                      title: "Watchlist",
                      imagePath: "assets/images/watchlist.png"),
                  Menu(
                      onTap: () {},
                      color: purpleColor.withOpacity(0.2),
                      title: "Booking",
                      imagePath: "assets/images/chair.png"),
                ],
              ),
            ),
            NowPlayingWidget(
              movies: nowPlayingMovies,
              imageBaseUrl: imageBaseUrl,
              onTap: (id) => Get.toNamed(Routes.DETAIL_MOVIE, arguments: id),
            ),
            PopularWidget(
              movies: popularMovies,
              imageBaseUrl: imageBaseUrl,
              onTap: (id) => Get.toNamed(Routes.DETAIL_MOVIE, arguments: id),
            ),
          ],
        );
      }),
    );
  }
}
