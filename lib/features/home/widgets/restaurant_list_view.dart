import 'package:flutter/material.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:loca_licious/features/detail/screens/restaurant_details_page.dart';

/// Dieses Widget zeigt eine Liste von Restaurants an.
/// Es verwendet ein `ListView.builder`, um die Liste effizient zu erstellen.
/// Es verwendet `Dismissible` für das Swipe-to-Delete-Verhalten.
/// Es verwendet `GestureDetector` für das Tap-Verhalten.
/// Es verwendet `Card` für das Design.
class RestaurantListView extends StatelessWidget {
  /// Der Konstruktor für das `RestaurantListView`-Widget.
  /// `restaurants`: Eine Liste von Restaurants, die angezeigt werden sollen.
  /// `repo`: Das Repository, das für den Zugriff auf die Restaurantdaten verwendet wird.
  const RestaurantListView({
    super.key,
    required this.restaurants,
    required this.repo,
  });

  /// Die Liste der Restaurants, die angezeigt werden sollen.
  final List<Map<String, dynamic>> restaurants;

  /// Das Repository, das für den Zugriff auf die Restaurantdaten verwendet wird.
  final RestaurantsRepo repo;

  /// Diese Methode löscht ein Restaurant aus der Datenbank.
  /// `context`: Der BuildContext des Widgets.
  /// `id`: Die ID des Restaurants, das gelöscht werden soll.
  void _deleteRestaurant(BuildContext context, String id) async {
    try {
      // Versuche, das Restaurant aus dem Repository zu löschen.
      await repo.deleteRestaurant(id);

      // Wenn das Löschen erfolgreich war, zeige eine Erfolgsmeldung an.
      // `context.mounted` prüft, ob das Widget noch im Baum ist.
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Restaurant gelöscht!')));
      }
    } catch (e) {
      // Wenn ein Fehler auftritt, zeige eine Fehlermeldung an.
      // `context.mounted` prüft, ob das Widget noch im Baum ist.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Löschen des Restaurants: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // `ListView.builder` ist eine effiziente Möglichkeit, eine lange Liste zu erstellen.
    return ListView.builder(
      // `itemCount`: Die Anzahl der Elemente in der Liste.
      itemCount: restaurants.length,
      // `padding`: Fügt einen Abstand um die Liste herum hinzu.
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // `itemBuilder`: Diese Funktion wird für jedes Element in der Liste aufgerufen.
      itemBuilder: (context, index) {
        // `r`: Das aktuelle Restaurant aus der Liste.
        final r = restaurants[index];

        // `Dismissible`: Ermöglicht das Löschen eines Eintrags durch Wischen.
        return Dismissible(
          // `key`: Ein eindeutiger Schlüssel für jedes Widget.
          key: Key(r['id']),
          // `direction`: Die Richtung, in die gewischt werden kann.
          direction: DismissDirection.endToStart, // Nur von rechts nach links
          // `background`: Das Widget, das angezeigt wird, während gewischt wird.
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          // `onDismissed`: Diese Funktion wird aufgerufen, wenn der Eintrag vollständig gewischt wurde.
          onDismissed: (direction) {
            // Lösche das Restaurant.
            _deleteRestaurant(context, r['id']);
          },
          // `GestureDetector`: Erfasst Tap-Gesten.
          child: GestureDetector(
            // `onTap`: Diese Funktion wird aufgerufen, wenn auf den Eintrag getippt wird.
            onTap: () {
              // Öffne die Detailseite des Restaurants.
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
            // `Card`: Ein Widget, das einen Eintrag als Karte darstellt.
            child: Card(
              // `margin`: Fügt einen Abstand um die Karte herum hinzu.
              margin: const EdgeInsets.only(bottom: 12),
              // `shape`: Definiert die Form der Karte.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              // `elevation`: Definiert den Schatten der Karte.
              elevation: 2,
              // `Padding`: Fügt einen Abstand innerhalb der Karte hinzu.
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r['name'] ?? '', // Zeige den Namen des Restaurants an.
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // `SizedBox`: Ein Widget, das einen Abstand hinzufügt.
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        (r['rating'] ??
                            0), // Erstelle so viele Sterne, wie die Bewertung ist.
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
                          r['city'] ??
                              '', // Zeige die Stadt des Restaurants an.
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const Spacer(), // Nimmt den restlichen Platz ein.
                        Text(
                          r['category'] ??
                              '', // Zeige die Kategorie des Restaurants an.
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
