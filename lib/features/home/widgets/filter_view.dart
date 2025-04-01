import 'package:flutter/material.dart';

class FilterView extends StatelessWidget {
  const FilterView({
    super.key,
    required this.postalCodeController,
    required this.selectedRating,
    required this.onRatingChanged,
    required this.onPostalCodeChanged,
  });

  final TextEditingController postalCodeController;
  final int? selectedRating;
  final void Function(int?) onRatingChanged;
  final VoidCallback onPostalCodeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    (index) =>
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                  ),
                ),
              ),
            ),
          ],
          onChanged: onRatingChanged,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: postalCodeController,
          decoration: InputDecoration(
            labelText: 'PLZ',
            suffixIcon:
                postalCodeController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        postalCodeController.clear();
                        onPostalCodeChanged();
                      },
                    )
                    : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => onPostalCodeChanged(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
