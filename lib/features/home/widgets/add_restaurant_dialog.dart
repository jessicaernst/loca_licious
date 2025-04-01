import 'package:flutter/material.dart';

class AddRestaurantDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onRestaurantAdded;

  const AddRestaurantDialog({super.key, required this.onRestaurantAdded});

  @override
  State<AddRestaurantDialog> createState() => _AddRestaurantDialogState();
}

class _AddRestaurantDialogState extends State<AddRestaurantDialog> {
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
    return AlertDialog(
      title: const Text('Neues Restaurant hinzufügen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _postalCodeController,
              decoration: const InputDecoration(labelText: 'Postleitzahl'),
            ),
            TextField(
              controller: _ratingController,
              decoration: const InputDecoration(labelText: 'Bewertung (1-5)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _adressController,
              decoration: const InputDecoration(labelText: 'Adresse'),
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Stadt'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Kategorie'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Schließe das Popup
          },
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
            // Hier die Daten aus den Textfeldern holen und das Restaurant hinzufügen
            final name = _nameController.text.trim();
            final postalCode = _postalCodeController.text.trim();
            final ratingString = _ratingController.text.trim();
            final adress = _adressController.text.trim();
            final city = _cityController.text.trim();
            final category = _categoryController.text.trim();

            if (name.isNotEmpty &&
                postalCode.isNotEmpty &&
                ratingString.isNotEmpty &&
                adress.isNotEmpty &&
                city.isNotEmpty &&
                category.isNotEmpty) {
              final rating = int.tryParse(ratingString);
              if (rating != null && rating >= 1 && rating <= 5) {
                // Erstelle die Map für das Restaurant
                final restaurant = <String, dynamic>{
                  'name': name,
                  'postalCode': postalCode,
                  'rating': rating,
                  'adress': adress,
                  'city': city,
                  'category': category,
                };
                widget.onRestaurantAdded(restaurant);
                Navigator.of(context).pop(); // Schließe das Popup
              } else {
                // Fehlerbehandlung: Ungültige Bewertung
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Ungültige Bewertung. Bitte eine Zahl zwischen 1 und 5 eingeben.',
                    ),
                  ),
                );
              }
            } else {
              // Fehlerbehandlung: Leere Felder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bitte alle Felder ausfüllen.')),
              );
            }
          },
          child: const Text('Hinzufügen'),
        ),
      ],
    );
  }
}
