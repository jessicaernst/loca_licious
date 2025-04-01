import 'package:flutter/material.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:loca_licious/features/detail/restaurant_details_page.dart';

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
      return widget.repo.streamRestaurants().map(
        (list) =>
            list
                .where(
                  (r) =>
                      r['rating'] == rating &&
                      r['postalCode']?.toString() == postalCode,
                )
                .toList(),
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
            DropdownButtonFormField<int>(
              value: selectedRating,
              hint: const Text('Alle Bewertungen'),
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('Alle Bewertungen'),
                ),
                ...List.generate(5, (i) => i + 1).map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Row(
                      children: List.generate(
                        e,
                        (index) => const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              onChanged: (val) => setState(() => selectedRating = val),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _postalCodeController,
              decoration: const InputDecoration(labelText: 'PLZ'),
              keyboardType: TextInputType.number,
              onChanged:
                  (value) => setState(() {}), // HIER: onChanged hinzugefügt
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
                              (i) => const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => RestaurantDetailPage(
                                    restaurantId: restaurant['id'],
                                    repo: widget.repo,
                                  ),
                            ),
                          );
                        },
                      );
                    },
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
