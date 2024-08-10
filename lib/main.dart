import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'presentation/detail_movie/controllers/detail_movie.controller.dart';
import 'presentation/fav_movie/controllers/fav_movie.controller.dart';
import 'presentation/watchlist/controllers/watchlist.controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  Get.put(DetailMovieController());
  Get.put(FavMovieController());
  Get.put(WatchlistController());

  // Check if user is logged in
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  var initialRoute = isLoggedIn ? Routes.HOME : Routes.LOGIN;

  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: Nav.routes,
    );
  }
}
