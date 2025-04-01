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
            Navigator.of(context).pop();
          },
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
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
                final restaurant = <String, dynamic>{
                  'id': widget.restaurant.id,
                  'name': name,
                  'postalCode': postalCode,
                  'rating': rating,
                  'adress': adress,
                  'city': city,
                  'category': category,
                };
                widget.onRestaurantUpdated(restaurant);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Ungültige Bewertung. Bitte eine Zahl zwischen 1 und 5 eingeben.',
                    ),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bitte alle Felder ausfüllen.')),
              );
            }
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
