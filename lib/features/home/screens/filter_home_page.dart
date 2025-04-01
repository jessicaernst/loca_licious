import 'package:flutter/material.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),
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
