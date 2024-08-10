import 'package:get/get.dart';

import '../../../../presentation/detail_movie/controllers/detail_movie.controller.dart';

class DetailMovieControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailMovieController>(
      () => DetailMovieController(),
    );
  }
}
