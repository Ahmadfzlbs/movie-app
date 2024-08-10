import 'package:get/get.dart';

import '../../../../presentation/fav_movie/controllers/fav_movie.controller.dart';

class FavMovieControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavMovieController>(
      () => FavMovieController(),
    );
  }
}
