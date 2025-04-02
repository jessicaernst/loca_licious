import 'package:flutter/material.dart';

/// Dieses Widget zeigt die Filteransicht an, mit der der Benutzer die
/// Restaurantliste nach Bewertung und Postleitzahl filtern kann.
class FilterView extends StatelessWidget {
  /// Der Konstruktor für das `FilterView`-Widget.
  /// `postalCodeController`: Der Controller für das Textfeld der Postleitzahl.
  /// `selectedRating`: Die aktuell ausgewählte Bewertung.
  /// `onRatingChanged`: Eine Callback-Funktion, die aufgerufen wird, wenn sich die Bewertung ändert.
  /// `onPostalCodeChanged`: Eine Callback-Funktion, die aufgerufen wird, wenn sich die Postleitzahl ändert.
  const FilterView({
    super.key,
    required this.postalCodeController,
    required this.selectedRating,
    required this.onRatingChanged,
    required this.onPostalCodeChanged,
  });

  /// Der Controller für das Textfeld der Postleitzahl.
  final TextEditingController postalCodeController;

  /// Die aktuell ausgewählte Bewertung.
  final int? selectedRating;

  /// Eine Callback-Funktion, die aufgerufen wird, wenn sich die Bewertung ändert.
  final void Function(int?) onRatingChanged;

  /// Eine Callback-Funktion, die aufgerufen wird, wenn sich die Postleitzahl ändert.
  final VoidCallback onPostalCodeChanged;

  /// Diese Methode erstellt das Widget.

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // `DropdownButtonFormField`: Ein Widget, das eine Dropdown-Liste für die Auswahl der Bewertung anzeigt.
        DropdownButtonFormField<int>(
          // `value`: Der aktuell ausgewählte Wert.
          value: selectedRating,
          // `hint`: Der Text, der angezeigt wird, wenn kein Wert ausgewählt ist.
          hint: const Text('Alle Bewertungen'),
          // `items`: Die Liste der Elemente in der Dropdown-Liste.
          items: [
            // `DropdownMenuItem`: Ein einzelnes Element in der Dropdown-Liste.
            const DropdownMenuItem<int>(
              value: null, // `null` bedeutet "Alle Bewertungen".
              child: Text('Alle Bewertungen'),
            ),
            // `List.generate`: Erstellt eine Liste von 5 Elementen (1 bis 5 Sterne).
            ...List.generate(5, (i) => i + 1).map(
              (e) => DropdownMenuItem(
                value: e, // Der Wert des Elements ist die Anzahl der Sterne.
                child: Row(
                  children: List.generate(
                    e, // Erstelle so viele Sterne, wie die Bewertung ist.
                    (index) =>
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                  ),
                ),
              ),
            ),
          ],
          // `onChanged`: Diese Funktion wird aufgerufen, wenn sich der ausgewählte Wert ändert.
          onChanged: onRatingChanged,
        ),
        const SizedBox(height: 12),
        TextFormField(
          // `controller`: Der Controller für das Textfeld.
          controller: postalCodeController,
          // `decoration`: Definiert das Aussehen des Textfelds.
          decoration: InputDecoration(
            labelText: 'PLZ',
            // `suffixIcon`: Ein Icon, das am Ende des Textfelds angezeigt wird.
            suffixIcon:
                postalCodeController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        // Lösche den Text im Textfeld.
                        postalCodeController.clear();
                        // Rufe die Callback-Funktion auf, um die Liste zu aktualisieren.
                        onPostalCodeChanged();
                      },
                    )
                    : null, // Zeige kein Icon an, wenn das Textfeld leer ist.
          ),
          // `keyboardType`: Definiert den Typ der Tastatur, die angezeigt wird.
          keyboardType: TextInputType.number, // Nur Zahlen.
          // `onChanged`: Diese Funktion wird aufgerufen, wenn sich der Text im Textfeld ändert.
          onChanged: (value) => onPostalCodeChanged(),
        ),
        // `SizedBox`: Ein Widget, das einen Abstand hinzufügt.
        const SizedBox(height: 12),
      ],
    );
  }
}
