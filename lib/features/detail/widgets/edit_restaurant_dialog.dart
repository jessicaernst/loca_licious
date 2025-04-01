import 'package:flutter/material.dart';
import 'package:loca_licious/data/models/restaurant.dart';

class EditRestaurantDialog extends StatefulWidget {
  final Restaurant restaurant;
  final Function(Map<String, dynamic>) onRestaurantUpdated;

  const EditRestaurantDialog({
    super.key,
    required this.restaurant,
    required this.onRestaurantUpdated,
  });

  @override
  State<EditRestaurantDialog> createState() => _EditRestaurantDialogState();
}

class _EditRestaurantDialogState extends State<EditRestaurantDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _ratingController;
  late final TextEditingController _adressController;
  late final TextEditingController _cityController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.restaurant.name);
    _postalCodeController = TextEditingController(
      text: widget.restaurant.postalCode,
    );
    _ratingController = TextEditingController(
      text: widget.restaurant.rating.toString(),
    );
    _adressController = TextEditingController(text: widget.restaurant.adress);
    _cityController = TextEditingController(text: widget.restaurant.city);
    _categoryController = TextEditingController(
      text: widget.restaurant.category,
    );
  }

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
      title: const Text('Restaurant bearbeiten'),
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
                  return null;
                },
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
              // Hier die Daten aus den Textfeldern holen
              final name = _nameController.text.trim();
              final postalCode = _postalCodeController.text.trim();
              final rating = int.parse(_ratingController.text.trim());
              final adress = _adressController.text.trim();
              final city = _cityController.text.trim();
              final category = _categoryController.text.trim();

              // Erstelle das Restaurant-Objekt
              final restaurant = Restaurant(
                id: widget.restaurant.id, // Die ID ist bereits vorhanden
                name: name,
                postalCode: postalCode,
                rating: rating,
                adress: adress,
                city: city,
                category: category,
              );

              // Übergib die Map an das übergeordnete Widget
              widget.onRestaurantUpdated(restaurant.toJson());
              Navigator.of(context).pop();
            }
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
