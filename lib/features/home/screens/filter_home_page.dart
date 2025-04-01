import 'package:flutter/material.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:loca_licious/features/home/widgets/add_restaurant_dialog.dart';
import 'package:loca_licious/features/home/widgets/filter_view.dart';
import 'package:loca_licious/features/home/widgets/restaurant_list_view.dart';

class FilterHomePage extends StatefulWidget {
  const FilterHomePage({super.key, required this.repo});

  final RestaurantsRepo repo;

  @override
  State<FilterHomePage> createState() => _FilterHomePageState();
}

class _FilterHomePageState extends State<FilterHomePage> {
  int? selectedRating;
  final _postalCodeController = TextEditingController();

  @override
  void dispose() {
    _postalCodeController.dispose();
    super.dispose();
  }

  Stream<List<Map<String, dynamic>>> _getStream() {
    final rating = selectedRating;
    final postalCode = _postalCodeController.text.trim();

    // 🟢 Kombination Rating + PLZ
    if (rating != null && postalCode.isNotEmpty) {
      return widget.repo.streamRestaurantsByRatingAndPostalCode(
        rating,
        postalCode,
      );
    }

    // 🟢 Nur Rating
    if (rating != null) {
      return widget.repo.streamRestaurantsByRating(rating);
    }

    // 🟢 Nur PLZ
    if (postalCode.isNotEmpty) {
      return widget.repo.streamRestaurantsByPostalCode(postalCode);
    }

    // 🟢 Kein Filter → alle
    return widget.repo.streamRestaurants();
  }

  void _showAddRestaurantPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddRestaurantDialog(
          onRestaurantAdded: (restaurant) {
            _addRestaurant(restaurant);
          },
        );
      },
    );
  }

  // Die Methode erwartet jetzt eine Map
  void _addRestaurant(Map<String, dynamic> restaurant) async {
    try {
      // Übergib die Map direkt an die Methode im Repo
      await widget.repo.addRestaurant(restaurant);

      // Prüfe, ob das Widget noch im Baum ist, bevor du mit ScaffoldMessenger interagierst
      if (mounted) {
        // Erfolgsmeldung
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restaurant hinzugefügt!')),
        );
      }
    } catch (e) {
      // Prüfe, ob das Widget noch im Baum ist, bevor du mit ScaffoldMessenger interagierst
      if (mounted) {
        // Fehlermeldung
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Hinzufügen des Restaurants: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRestaurantPopup(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ExpansionTile(
              title: const Text('Filter'),
              childrenPadding: const EdgeInsets.all(16),
              children: [
                FilterView(
                  postalCodeController: _postalCodeController,
                  selectedRating: selectedRating,
                  onRatingChanged:
                      (rating) => setState(() => selectedRating = rating),
                  onPostalCodeChanged: () => setState(() {}),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Fehler: ${snapshot.error}'));
                  }

                  final restaurants = snapshot.data ?? [];

                  if (restaurants.isEmpty) {
                    return const Center(
                      child: Text('Keine Restaurants gefunden.'),
                    );
                  }

                  return RestaurantListView(
                    restaurants: restaurants,
                    repo: widget.repo,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
