import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loca_licious/app.dart';
import 'package:loca_licious/data/repositories/restaurants_repo_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final restaurantsRepo = RestaurantsRepoImpl();

  runApp(App(repo: restaurantsRepo));
}
