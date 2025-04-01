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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Adresse
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${restaurant.adress}\n${restaurant.postalCode} ${restaurant.city}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Bewertung
                    Row(
                      children: [
                        const Icon(Icons.star, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        ...List.generate(
                          restaurant.rating,
                          (_) => const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${restaurant.rating} / 5'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Kategorie
                    Row(
                      children: [
                        const Icon(
                          Icons.restaurant_menu,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(restaurant.category),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
