import 'package:flutter/material.dart';
import 'package:loca_licious/data/models/restaurant.dart';
import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:loca_licious/features/detail/widgets/edit_restaurant_dialog.dart';

/// Dieses Widget zeigt die Detailseite eines Restaurants an.
class RestaurantDetailPage extends StatefulWidget {
  /// Der Konstruktor für das `RestaurantDetailPage`-Widget.
  /// `restaurantId`: Die ID des Restaurants, das angezeigt werden soll.
  /// `repo`: Das Repository, das für den Zugriff auf die Restaurantdaten verwendet wird.
  const RestaurantDetailPage({
    super.key,
    required this.restaurantId,
    required this.repo,
  });

  /// Die ID des Restaurants, das angezeigt werden soll.
  final String restaurantId;

  /// Das Repository, das für den Zugriff auf die Restaurantdaten verwendet wird.
  final RestaurantsRepo repo;

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  /// Die Daten des Restaurants.
  late Map<String, dynamic> _restaurantData;

  /// Das Restaurant-Objekt.
  late Restaurant _restaurant;

  /// Gibt an, ob die Daten geladen werden.
  bool _isLoading = true;

  /// Diese Methode wird aufgerufen, wenn das Widget zum ersten Mal erstellt wird.
  @override
  void initState() {
    super.initState();
    // Lade die Restaurantdaten.
    _loadRestaurantData();
  }

  /// Diese Methode lädt die Restaurantdaten aus dem Repository.
  Future<void> _loadRestaurantData() async {
    try {
      // Versuche, das Restaurant aus dem Repository zu laden.
      _restaurantData = await widget.repo.getRestaurantById(
        widget.restaurantId,
      );
      // Erstelle ein Restaurant-Objekt aus den Daten.
      _restaurant = Restaurant.fromJson(_restaurantData, widget.restaurantId);
    } catch (e) {
      // Wenn ein Fehler auftritt, zeige eine Fehlermeldung an.
      // `mounted` prüft, ob das Widget noch im Baum ist.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden des Restaurants: $e')),
        );
      }
    } finally {
      // Setze `_isLoading` auf `false`, wenn die Daten geladen wurden oder ein Fehler aufgetreten ist.
      // `mounted` prüft, ob das Widget noch im Baum ist.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Diese Methode zeigt das Popup zum Bearbeiten des Restaurants an.
  void _showEditRestaurantPopup(BuildContext context) {
    // Zeige das Popup an.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // `EditRestaurantDialog`: Das Widget für das Popup zum Bearbeiten des Restaurants.
        return EditRestaurantDialog(
          restaurant: _restaurant,
          onRestaurantUpdated: (restaurant) {
            // Aktualisiere das Restaurant.
            _updateRestaurant(restaurant);
          },
        );
      },
    );
  }

  /// Diese Methode aktualisiert das Restaurant in der Datenbank.
  void _updateRestaurant(Map<String, dynamic> restaurant) async {
    try {
      // Versuche, das Restaurant im Repository zu aktualisieren.
      await widget.repo.updateRestaurant(restaurant);
      // Wenn das Aktualisieren erfolgreich war, zeige eine Erfolgsmeldung an.
      // `mounted` prüft, ob das Widget noch im Baum ist.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restaurant aktualisiert!')),
        );
        // Aktualisiere die Daten im Widget.
        setState(() {
          _restaurant = Restaurant.fromJson(restaurant, restaurant['id']);
        });
      }
    } catch (e) {
      // Wenn ein Fehler auftritt, zeige eine Fehlermeldung an.
      // `mounted` prüft, ob das Widget noch im Baum ist.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Aktualisieren: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // `Scaffold`: Das Grundgerüst für die Seite.
    return Scaffold(
      // `AppBar`: Die obere Leiste der Seite.
      appBar: AppBar(
        title: const Text('Restaurant Details'),
        // `actions`: Die Icons in der Appbar.
        actions: [
          // `IconButton`: Ein Icon-Button zum Bearbeiten des Restaurants.
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Zeige das Popup zum Bearbeiten des Restaurants an.
              _showEditRestaurantPopup(context);
            },
          ),
        ],
      ),
      // `body`: Der Hauptinhalt der Seite.
      body:
          _isLoading
              // Zeige einen Ladeindikator an, während die Daten geladen werden.
              ? const Center(child: CircularProgressIndicator())
              // Zeige die Restaurantdetails an, wenn die Daten geladen wurden.
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                // `Card`: Ein Widget, das die Details als Karte darstellt.
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // `Padding`: Fügt einen Abstand innerhalb der Karte hinzu.
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // `Text`: Ein Widget, das Text anzeigt.
                        // Name
                        Text(
                          _restaurant.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        // `SizedBox`: Ein Widget, das einen Abstand hinzufügt.
                        const SizedBox(height: 16),

                        // Adresse
                        // `Row`: Ein Widget, das seine Kinder horizontal anordnet.
                        Row(
                          // `crossAxisAlignment`: Definiert die Ausrichtung der Kinder auf der vertikalen Achse.
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            // `Expanded`: Ein Widget, das den verfügbaren Platz einnimmt.
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
                            // `List.generate`: Erstellt eine Liste von Widgets.
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
                            // `Chip`: Ein Widget, das eine Kategorie darstellt.
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
