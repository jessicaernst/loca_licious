import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:loca_licious/features/home/screens/filter_home_page.dart';

class App extends StatelessWidget {
  const App({super.key, required this.repo});

  final RestaurantsRepo repo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        textTheme: GoogleFonts.urbanistTextTheme(),
      ),
      home: FilterHomePage(repo: repo),
    );
  }
}
