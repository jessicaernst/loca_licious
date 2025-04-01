import 'package:flutter/material.dart';
import 'package:loca_licious/data/models/restaurant.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:loca_licious/features/detail/widgets/edit_restaurant_dialog.dart';

class RestaurantDetailPage extends StatefulWidget {
  const RestaurantDetailPage({
    super.key,
    required this.restaurantId,
    required this.repo,
  });

  final String restaurantId;
  final RestaurantsRepo repo;

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late Map<String, dynamic> _restaurantData;
  late Restaurant _restaurant;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRestaurantData();
  }

  Future<void> _loadRestaurantData() async {
    try {
      _restaurantData = await widget.repo.getRestaurantById(
        widget.restaurantId,
      );
      _restaurant = Restaurant.fromJson(_restaurantData, widget.restaurantId);
    } catch (e) {
      // Fehlerbehandlung
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden des Restaurants: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showEditRestaurantPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditRestaurantDialog(
          restaurant: _restaurant,
          onRestaurantUpdated: (restaurant) {
            _updateRestaurant(restaurant);
          },
        );
      },
    );
  }

  void _updateRestaurant(Map<String, dynamic> restaurant) async {
    try {
      await widget.repo.updateRestaurant(restaurant);
      // Erfolgsmeldung
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restaurant aktualisiert!')),
        );
        // Aktualisiere die Daten im Widget
        setState(() {
          _restaurant = Restaurant.fromJson(restaurant, restaurant['id']);
        });
      }
    } catch (e) {
      // Fehlermeldung
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Aktualisieren: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditRestaurantPopup(context);
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                          _restaurant.name,
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
                                '${_restaurant.adress}\n${_restaurant.postalCode} ${_restaurant.city}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Bewertung
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            ...List.generate(
                              _restaurant.rating,
                              (_) => const Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${_restaurant.rating} / 5'),
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
                              label: Text(_restaurant.category),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withAlpha((0.1 * 255).toInt()),
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
              ),
    );
  }
}
