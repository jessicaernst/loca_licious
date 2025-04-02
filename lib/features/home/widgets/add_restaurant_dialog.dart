import 'package:flutter/material.dart';
import 'package:loca_licious/data/models/restaurant.dart';

/// Dieses Widget zeigt das Popup zum Hinzufügen eines neuen Restaurants an.
class AddRestaurantDialog extends StatefulWidget {
  /// Der Konstruktor für das `AddRestaurantDialog`-Widget.
  /// `onRestaurantAdded`: Eine Callback-Funktion, die aufgerufen wird, wenn ein neues Restaurant hinzugefügt wurde.
  const AddRestaurantDialog({super.key, required this.onRestaurantAdded});

  /// Eine Callback-Funktion, die aufgerufen wird, wenn ein neues Restaurant hinzugefügt wurde.
  final Function(Map<String, dynamic>) onRestaurantAdded;

  @override
  State<AddRestaurantDialog> createState() => _AddRestaurantDialogState();
}

class _AddRestaurantDialogState extends State<AddRestaurantDialog> {
  // `_formKey`: Ein Schlüssel, um auf den Zustand des Formulars zuzugreifen.
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _ratingController = TextEditingController();
  final _adressController = TextEditingController();
  final _cityController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _postalCodeController.dispose();
    _ratingController.dispose();
    _adressController.dispose();
    _cityController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // `AlertDialog`: Das Popup-Widget.
    return AlertDialog(
      title: const Text('Neues Restaurant hinzufügen'),
      // `SingleChildScrollView`: Ermöglicht das Scrollen, wenn der Inhalt zu groß ist.
      content: SingleChildScrollView(
        // `Form`: Ein Widget, das ein Formular darstellt.
        child: Form(
          // `key`: Der Schlüssel, um auf den Zustand des Formulars zuzugreifen.
          key: _formKey,
          // `Column`: Ein Widget, das seine Kinder vertikal anordnet.
          child: Column(
            // `mainAxisSize`: Definiert die Größe der Hauptachse.
            mainAxisSize: MainAxisSize.min,
            children: [
              // `TextFormField`: Ein Textfeld mit Validierung.
              TextFormField(
                // `controller`: Der Controller für das Textfeld.
                controller: _nameController,
                // `decoration`: Definiert das Aussehen des Textfelds.
                decoration: const InputDecoration(labelText: 'Name'),
                // `validator`: Diese Funktion wird aufgerufen, um die Eingabe zu validieren.
                validator: (value) {
                  // Überprüfe, ob das Feld nicht leer ist.
                  if (value == null || value.isEmpty) {
                    return 'Bitte einen Namen eingeben';
                  }
                  return null; // `null` bedeutet, dass die Validierung erfolgreich war.
                },
              ),
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(labelText: 'Postleitzahl'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte eine Postleitzahl eingeben';
                  }
                  if (value.length != 5) {
                    return 'Bitte eine gültige Postleitzahl eingeben';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Bewertung (1-5)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte eine Bewertung eingeben';
                  }
                  final rating = int.tryParse(value);
                  if (rating == null || rating < 1 || rating > 5) {
                    return 'Bitte eine Zahl zwischen 1 und 5 eingeben';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _adressController,
                decoration: const InputDecoration(labelText: 'Adresse'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte eine Adresse eingeben';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Stadt'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte eine Stadt eingeben';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategorie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte eine Kategorie eingeben';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      // `actions`: Die Buttons am unteren Rand des Popups.
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
            // Überprüfe, ob das Formular gültig ist.
            if (_formKey.currentState!.validate()) {
              // Hier die Daten aus den Textfeldern holen
              final name = _nameController.text.trim();
              final postalCode = _postalCodeController.text.trim();
              final rating = int.parse(_ratingController.text.trim());
              final adress = _adressController.text.trim();
              final city = _cityController.text.trim();
              final category = _categoryController.text.trim();

              // Erstelle das Restaurant-Objekt
              final restaurant = Restaurant(
                id: '', // Die ID wird von Firestore generiert
                name: name,
                postalCode: postalCode,
                rating: rating,
                adress: adress,
                city: city,
                category: category,
              );

              // Übergib die Map an das übergeordnete Widget
              widget.onRestaurantAdded(restaurant.toJson());
              // Schließe das Popup.
              Navigator.of(context).pop();
            }
          },
          child: const Text('Hinzufügen'),
        ),
      ],
    );
  }
}
