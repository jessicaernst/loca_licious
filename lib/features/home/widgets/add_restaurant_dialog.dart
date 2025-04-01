import 'package:flutter/material.dart';
import 'package:loca_licious/data/models/restaurant.dart';

class AddRestaurantDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onRestaurantAdded;

  const AddRestaurantDialog({super.key, required this.onRestaurantAdded});

  @override
  State<AddRestaurantDialog> createState() => _AddRestaurantDialogState();
}

class _AddRestaurantDialogState extends State<AddRestaurantDialog> {
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
    return AlertDialog(
      title: const Text('Neues Restaurant hinzufügen'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte einen Namen eingeben';
                  }
                  return null;
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
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Hier die Daten aus den Textfeldern holen und das Restaurant hinzufügen
              final name = _nameController.text.trim();
              final postalCode = _postalCodeController.text.trim();
              final ratingString = _ratingController.text.trim();
              final adress = _adressController.text.trim();
              final city = _cityController.text.trim();
              final category = _categoryController.text.trim();
              final rating = int.tryParse(ratingString)!;

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
              Navigator.of(context).pop();
            }
          },
          child: const Text('Hinzufügen'),
        ),
      ],
    );
  }
}
