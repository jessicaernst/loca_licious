import 'package:flutter/material.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:loca_licious/features/home/widgets/add_restaurant_dialog.dart';
import 'package:loca_licious/features/home/widgets/filter_view.dart';
import 'package:loca_licious/features/home/widgets/restaurant_list_view.dart';

/// Dieses Widget zeigt die Startseite mit der Liste der Restaurants und den Filtermöglichkeiten an.
class FilterHomePage extends StatefulWidget {
  /// Der Konstruktor für das `FilterHomePage`-Widget.
  /// `repo`: Das Repository, das für den Zugriff auf die Restaurantdaten verwendet wird.
  const FilterHomePage({super.key, required this.repo});

  /// Das Repository, das für den Zugriff auf die Restaurantdaten verwendet wird.
  final RestaurantsRepo repo;

  @override
  State<FilterHomePage> createState() => _FilterHomePageState();
}

class _FilterHomePageState extends State<FilterHomePage> {
  /// Die aktuell ausgewählte Bewertung.
  int? selectedRating;

  /// Der Controller für das Textfeld der Postleitzahl.
  final _postalCodeController = TextEditingController();

  /// Diese Methode wird aufgerufen, wenn das Widget entfernt wird.
  @override
  void dispose() {
    // Entsorge den Controller, um Speicherlecks zu vermeiden.
    _postalCodeController.dispose();
    super.dispose();
  }

  /// Diese Methode gibt einen Stream von Listen von Restaurants zurück,
  /// basierend auf den ausgewählten Filtern.
  Stream<List<Map<String, dynamic>>> _getStream() {
    // `rating`: Die aktuell ausgewählte Bewertung.
    final rating = selectedRating;
    // `postalCode`: Die eingegebene Postleitzahl.
    final postalCode = _postalCodeController.text.trim();

    // 🟢 Kombination Rating + PLZ
    // Wenn sowohl eine Bewertung als auch eine Postleitzahl ausgewählt wurden,
    // gib einen Stream von Restaurants zurück, die beide Kriterien erfüllen.
    if (rating != null && postalCode.isNotEmpty) {
      return widget.repo.streamRestaurantsByRatingAndPostalCode(
        rating,
        postalCode,
      );
    }

    // 🟢 Nur Rating
    // Wenn nur eine Bewertung ausgewählt wurde, gib einen Stream von
    // Restaurants zurück, die diese Bewertung haben.
    if (rating != null) {
      return widget.repo.streamRestaurantsByRating(rating);
    }

    // 🟢 Nur PLZ
    // Wenn nur eine Postleitzahl eingegeben wurde, gib einen Stream von
    // Restaurants zurück, die sich in dieser Postleitzahl befinden.
    if (postalCode.isNotEmpty) {
      return widget.repo.streamRestaurantsByPostalCode(postalCode);
    }

    // 🟢 Kein Filter → alle
    // Wenn keine Filter ausgewählt wurden, gib einen Stream von allen
    // Restaurants zurück.
    return widget.repo.streamRestaurants();
  }

  /// Diese Methode zeigt das Popup zum Hinzufügen eines neuen Restaurants an.
  /// `context`: Der BuildContext des Widgets.
  void _showAddRestaurantPopup(BuildContext context) {
    // `showDialog`: Zeigt ein Popup an.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // `AddRestaurantDialog`: Das Widget für das Popup zum Hinzufügen eines Restaurants.
        return AddRestaurantDialog(
          // `onRestaurantAdded`: Diese Funktion wird aufgerufen, wenn ein neues Restaurant hinzugefügt wurde.
          onRestaurantAdded: (restaurant) {
            // Füge das Restaurant hinzu.
            _addRestaurant(restaurant);
          },
        );
      },
    );
  }

  /// Diese Methode fügt ein neues Restaurant zur Datenbank hinzu.
  /// `restaurant`: Die Daten des neuen Restaurants als Map.
  void _addRestaurant(Map<String, dynamic> restaurant) async {
    try {
      // Versuche, das Restaurant zum Repository hinzuzufügen.
      await widget.repo.addRestaurant(restaurant);

      // Wenn das Hinzufügen erfolgreich war, zeige eine Erfolgsmeldung an.
      // `mounted` prüft, ob das Widget noch im Baum ist.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restaurant hinzugefügt!')),
        );
      }
    } catch (e) {
      // Wenn ein Fehler auftritt, zeige eine Fehlermeldung an.
      // `mounted` prüft, ob das Widget noch im Baum ist.
      if (mounted) {
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
      // `FloatingActionButton`: Der schwebende Button zum Hinzufügen eines Restaurants.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Zeige das Popup zum Hinzufügen eines Restaurants an.
          _showAddRestaurantPopup(context);
        },
        child: const Icon(Icons.add),
      ),
      // `body`: Der Hauptinhalt der Seite.
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // `ExpansionTile`: Ein Widget, das einen Bereich zum Ein- und Ausklappen anzeigt.
            ExpansionTile(
              title: const Text('Filter'),
              childrenPadding: const EdgeInsets.all(16),
              children: [
                // `FilterView`: Das Widget für die Filteransicht.
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
              // `StreamBuilder`: Ein Widget, das einen Stream von Daten anzeigt.
              child: StreamBuilder<List<Map<String, dynamic>>>(
                // `stream`: Der Stream von Daten.
                stream: _getStream(),
                // `builder`: Diese Funktion wird aufgerufen, wenn sich die Daten im Stream ändern.
                builder: (context, snapshot) {
                  // `ConnectionState.waiting`: Zeige einen Ladeindikator an, während die Daten geladen werden.
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // `snapshot.hasError`: Zeige eine Fehlermeldung an, wenn ein Fehler aufgetreten ist.
                  if (snapshot.hasError) {
                    return Center(child: Text('Fehler: ${snapshot.error}'));
                  }

                  // `restaurants`: Die Liste der Restaurants aus dem Stream.
                  final restaurants = snapshot.data ?? [];

                  // Zeige eine Meldung an, wenn keine Restaurants gefunden wurden.
                  if (restaurants.isEmpty) {
                    return const Center(
                      child: Text('Keine Restaurants gefunden.'),
                    );
                  }

                  // `RestaurantListView`: Das Widget für die Liste der Restaurants.
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
