import 'package:flutter/material.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:loca_licious/features/detail/screens/restaurant_details_page.dart';

class RestaurantListView extends StatelessWidget {
  const RestaurantListView({
    super.key,
    required this.restaurants,
    required this.repo,
  });

  final List<Map<String, dynamic>> restaurants;
  final RestaurantsRepo repo;

  void _deleteRestaurant(BuildContext context, String id) async {
    try {
      await repo.deleteRestaurant(id);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Restaurant gelöscht!')));
      }
    } catch (e) {
      // Fehlermeldung
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Löschen des Restaurants: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: restaurants.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final r = restaurants[index];

        return Dismissible(
          key: Key(r['id']),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            _deleteRestaurant(context, r['id']);
          },
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => RestaurantDetailPage(
                        restaurantId: r['id'],
                        repo: repo,
                      ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r['name'] ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        (r['rating'] ?? 0),
                        (i) => const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          r['city'] ?? '',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const Spacer(),
                        Text(
                          r['category'] ?? '',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
