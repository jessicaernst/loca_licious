import 'package:flutter/material.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:loca_licious/features/detail/restaurant_details_page.dart';

class RestaurantListView extends StatelessWidget {
  const RestaurantListView({
    super.key,
    required this.restaurants,
    required this.repo,
  });

  final List<Map<String, dynamic>> restaurants;
  final RestaurantsRepo repo;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return ListTile(
          title: Text(restaurant['name'] ?? ''),
          subtitle: Row(
            children: [
              Text('${restaurant['postalCode']} • '),
              ...List.generate(
                (restaurant['rating'] ?? 0),
                (i) => const Icon(Icons.star, size: 16, color: Colors.amber),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => RestaurantDetailPage(
                      restaurantId: restaurant['id'],
                      repo: repo,
                    ),
              ),
            );
          },
        );
      },
    );
  }
}
