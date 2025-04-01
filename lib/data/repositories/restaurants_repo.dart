/// Dieses Interface (`abstract class`) definiert die Methoden, die ein Repository für
/// Restaurant-Daten implementieren muss. Ein Repository ist eine Abstraktion, die
/// den Zugriff auf die Datenquelle (in diesem Fall Firebase Firestore) kapselt.
abstract class RestaurantsRepo {
  // 🔁 Live-Streams
  /// Gibt einen Stream von Listen von Restaurants zurück.
  /// Ein Stream ist eine Abfolge von Daten, die sich im Laufe der Zeit ändern können.
  /// Hier werden die Daten "live" aus der Datenbank abgerufen, d.h. wenn sich die
  /// Daten in der Datenbank ändern, werden sie auch in der App aktualisiert.
  /// Jedes Restaurant wird als `Map<String, dynamic>` dargestellt, wobei die
  /// Schlüssel die Feldnamen (z.B. 'name', 'rating') und die Werte die
  /// entsprechenden Daten sind.
  Stream<List<Map<String, dynamic>>> streamRestaurants();

  /// Gibt einen Stream von Listen von Restaurants zurück, die eine bestimmte
  /// Bewertung haben.
  /// `rating`: Die Bewertung, nach der gefiltert werden soll.
  Stream<List<Map<String, dynamic>>> streamRestaurantsByRating(int rating);

  /// Gibt einen Stream von Listen von Restaurants zurück, die sich in einer
  /// bestimmten Postleitzahl befinden.
  /// `postalCode`: Die Postleitzahl, nach der gefiltert werden soll.
  Stream<List<Map<String, dynamic>>> streamRestaurantsByPostalCode(
    String postalCode,
  );

  /// Gibt einen Stream von Listen von Restaurants zurück, die eine bestimmte
  /// Bewertung haben und sich in einer bestimmten Postleitzahl befinden.
  /// `rating`: Die Bewertung, nach der gefiltert werden soll.
  /// `postalCode`: Die Postleitzahl, nach der gefiltert werden soll.
  Stream<List<Map<String, dynamic>>> streamRestaurantsByRatingAndPostalCode(
    int rating,
    String postalCode,
  );

  // 🔧 CRUD-Operationen (Einmalige Abfragen)
  /// Gibt eine Liste aller Restaurants zurück.
  /// Im Gegensatz zu den Streams werden hier die Daten nur einmal abgerufen.
  Future<List<Map<String, dynamic>>> getRestaurants();

  /// Fügt ein neues Restaurant hinzu.
  /// `restaurant`: Die Daten des neuen Restaurants als `Map<String, dynamic>`.
  Future<void> addRestaurant(Map<String, dynamic> restaurant);

  /// Aktualisiert ein bestehendes Restaurant.
  /// `restaurant`: Die aktualisierten Daten des Restaurants als `Map<String, dynamic>`.
  Future<void> updateRestaurant(Map<String, dynamic> restaurant);

  /// Löscht ein Restaurant anhand seiner ID.
  /// `id`: Die ID des zu löschenden Restaurants.
  Future<void> deleteRestaurant(String id);

  /// Gibt ein Restaurant anhand seiner ID zurück.
  /// `id`: Die ID des gesuchten Restaurants.
  Future<Map<String, dynamic>> getRestaurantById(String id);

  /// Gibt eine Liste von Restaurants zurück, die sich in einer bestimmten
  /// Postleitzahl befinden.
  /// `postalCode`: Die Postleitzahl, nach der gefiltert werden soll.
  Future<List<Map<String, dynamic>>> getRestaurantsByPostalCode(
    String postalCode,
  );

  /// Gibt eine Liste von Restaurants zurück, die eine bestimmte Bewertung haben.
  /// `rating`: Die Bewertung, nach der gefiltert werden soll.
  Future<List<Map<String, dynamic>>> getRestaurantsByRating(int rating);

  /// Gibt eine Liste von Restaurants zurück, die eine bestimmte Bewertung haben
  /// und sich in einer bestimmten Postleitzahl befinden.
  /// `rating`: Die Bewertung, nach der gefiltert werden soll.
  /// `postalCode`: Die Postleitzahl, nach der gefiltert werden soll.
  Future<List<Map<String, dynamic>>> getRestaurantsByRatingAndPostalCode(
    int rating,
    String postalCode,
  );
}
