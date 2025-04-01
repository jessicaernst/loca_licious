import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:loca_licious/data/repositories/restaurants_repo_impl.dart';
import 'package:loca_licious/features/home/screens/filter_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final restaurantsRepo = RestaurantsRepoImpl();

  runApp(App(repo: restaurantsRepo));
}

class App extends StatelessWidget {
  const App({super.key, required this.repo});

  final RestaurantsRepo repo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: FilterHomePage(repo: repo),
    );
  }
}
