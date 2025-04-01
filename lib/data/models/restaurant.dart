/// Die `Restaurant`-Klasse repräsentiert ein Restaurant mit verschiedenen Eigenschaften.
/// und wird mit den folgenden Parametern repräsentiert:
/// - `id` (String): Die eindeutige ID des Restaurants. Diese wird von Firebase generiert.
/// - `name` (String): Der Name des Restaurants.
/// - `rating` (int): Die Bewertung des Restaurants (z.B. Sternebewertung).
/// - `postalCode` (String): Die Postleitzahl des Restaurants.
/// - `adress` (String): Die Adresse des Restaurants.
/// - `category` (String): Die Kategorie des Restaurants (z.B. Italienisch, Chinesisch).
/// Die `Restaurant`-Klasse ist immutable, was bedeutet, dass ein Restaurant-Objekt nach
/// seiner Erstellung nicht mehr verändert werden kann.
///
/// Diese Klasse ist als immutable (unveränderlich) konzipiert. Das bedeutet, dass ein
/// Restaurant-Objekt nach seiner Erstellung nicht mehr verändert werden kann.
/// In Flutter sind immutable Klassen besonders wichtig, da sie die Performance und
/// Vorhersagbarkeit der Benutzeroberfläche verbessern.
/// Vorteile von immutablen Klassen:
/// - **Sicherheit:** Es können keine unerwarteten Änderungen an den Daten auftreten.
/// - **Vorhersagbarkeit:** Der Zustand eines Objekts ist immer klar und konsistent.
/// - **Einfacheres Debugging:** Fehler, die durch unerwartete Änderungen entstehen, werden vermieden.
/// - **Performance:** Flutter kann immutable Objekte effizienter verarbeiten, da es weiß, dass sie sich nicht ändern.
/// - **Einfacheres State-Management:** Immutable Objekte erleichtern das State-Management, da man immer weiß, wann sich etwas geändert hat.
/// - **Thread-Sicherheit:** Immutable Objekte können sicher in Multi-Thread-Umgebungen verwendet werden.
library;

class Restaurant {
  /// Die eindeutige ID des Restaurants.
  /// `final` bedeutet, dass dieser Wert nach der Erstellung des Objekts nicht mehr geändert werden kann.
  final String id;

  /// Der Name des Restaurants.
  /// `final` bedeutet, dass dieser Wert nach der Erstellung des Objekts nicht mehr geändert werden kann.
  final String name;

  /// Die Bewertung des Restaurants (z.B. Sternebewertung).
  /// `final` bedeutet, dass dieser Wert nach der Erstellung des Objekts nicht mehr geändert werden kann.
  final int rating;

  /// Die Postleitzahl des Restaurants.
  /// `final` bedeutet, dass dieser Wert nach der Erstellung des Objekts nicht mehr geändert werden kann.
  final String postalCode;

  /// Die Adresse des Restaurants.
  /// `final` bedeutet, dass dieser Wert nach der Erstellung des Objekts nicht mehr geändert werden kann.
  final String adress;

  /// Die Stadt in der das Restaurant ist
  /// `final` bedeutet, dass dieser Wert nach der Erstellung des Objekts nicht mehr geändert werden kann.
  final String city;

  /// Die Kategorie des Restaurants (z.B. Italienisch, Chinesisch).
  /// `final` bedeutet, dass dieser Wert nach der Erstellung des Objekts nicht mehr geändert werden kann.
  final String category;

  /// Der `const`-Konstruktor der `Restaurant`-Klasse.
  /// `const` bedeutet, dass Instanzen dieser Klasse zur Compile-Zeit erstellt werden können.
  /// Das ist möglich, weil alle Felder `final` sind und somit nach der Erstellung nicht mehr verändert werden können.
  /// `required` bedeutet, dass diese Parameter beim Erstellen eines `Restaurant`-Objekts zwingend angegeben werden müssen.
  const Restaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.postalCode,
    required this.adress,
    required this.city,
    required this.category,
  });

  /// Ein "Factory"-Konstruktor, der ein `Restaurant`-Objekt aus einem JSON-Objekt erstellt.
  /// Ein Factory-Konstruktor kann eine Instanz der Klasse zurückgeben oder eine Instanz einer Subklasse.
  /// Hier wird er verwendet, um die Erstellung eines `Restaurant`-Objekts aus einem JSON-Format zu vereinfachen.
  /// `toJson` wird verwendet, da JSON das Standardformat für Web-APIs und Firestore ist.
  /// `Map` ist Dart-spezifisch.
  factory Restaurant.fromJson(Map<String, dynamic> json, String restaurantId) {
    // HIER: String id entfernt
    /// Gibt ein neues `Restaurant`-Objekt zurück, das aus den Daten des JSON-Objekts erstellt wurde.
    /// `json['name'] ?? ''` bedeutet: Wenn `json['name']` einen Wert hat, wird dieser verwendet.
    /// Wenn `json['name']` `null` ist, wird stattdessen ein leerer String (`''`) verwendet.
    /// Das `??` ist der Null-Aware-Operator.
    return Restaurant(
      id: json['id'],
      name: json['name'] ?? '',
      rating:
          json['rating'] ??
          0, // Wenn keine Bewertung vorhanden ist, wird 0 verwendet.
      postalCode: json['postalCode'] ?? '',
      adress: json['adress'] ?? '',
      city: json['city'] ?? '',
      category: json['category'] ?? '',
    );
  }

  /// Eine Methode, die das `Restaurant`-Objekt in ein JSON-Objekt umwandelt.
  /// Dies ist nützlich, um das Objekt z.B. in einer Datenbank zu speichern oder über ein Netzwerk zu senden.
  Map<String, dynamic> toJson() {
    /// Gibt ein Map-Objekt zurück, das die Daten des `Restaurant`-Objekts enthält.
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'postalCode': postalCode,
      'adress': adress,
      'city': city,
      'category': category,
    };
  }
}
