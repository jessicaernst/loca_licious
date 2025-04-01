import 'package:flutter/material.dart';
import 'package:loca_licious/data/models/restaurant.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';

class RestaurantDetailPage extends StatelessWidget {
  const RestaurantDetailPage({
    super.key,
    required this.restaurantId,
    required this.repo,
  });

  final String restaurantId;
  final RestaurantsRepo repo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: repo.getRestaurantById(restaurantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }

          final restaurantData = snapshot.data;
          if (restaurantData == null) {
            return const Center(child: Text('Restaurant nicht gefunden.'));
          }
          final restaurant = Restaurant.fromJson(restaurantData, restaurantId);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Adresse: ${restaurant.adress}'),
                Text('PLZ: ${restaurant.postalCode}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Bewertung: '),
                    ...List.generate(
                      restaurant.rating,
                      (index) => const Icon(Icons.star, color: Colors.amber),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Kategorie: ${restaurant.category}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
