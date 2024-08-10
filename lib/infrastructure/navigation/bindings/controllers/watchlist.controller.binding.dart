import 'package:get/get.dart';

import '../../../../presentation/watchlist/controllers/watchlist.controller.dart';

class WatchlistControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WatchlistController>(
      () => WatchlistController(),
    );
  }
}
