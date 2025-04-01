import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Diese Klasse implementiert das `RestaurantsRepo`-Interface und stellt die
/// konkrete Verbindung zu Firebase Firestore her.
/// Sie enthält die Logik, um Restaurant-Daten aus der Datenbank abzurufen,
/// hinzuzufügen, zu aktualisieren und zu löschen.
class RestaurantsRepoImpl implements RestaurantsRepo {
  /// `_restaurantsRef`: Eine Referenz auf die 'restaurants'-Collection in
  /// Firebase Firestore. Diese Referenz wird verwendet, um auf die Daten in
  /// der Datenbank zuzugreifen.
  final _restaurantsRef = FirebaseFirestore.instance.collection('restaurants');

  // 🔄 STREAMS (Live)
  /// `streamRestaurants()`: Gibt einen Stream von Listen von Restaurants zurück.
  /// Ein Stream ist eine Abfolge von Daten, die sich im Laufe der Zeit ändern
  /// können. Hier werden die Daten "live" aus der Datenbank abgerufen.
  @override
  Stream<List<Map<String, dynamic>>> streamRestaurants() {
    /// `_restaurantsRef.snapshots()`: Ruft einen Stream von Snapshots der
    /// 'restaurants'-Collection ab. Ein Snapshot enthält die Daten der
    /// Collection zu einem bestimmten Zeitpunkt.
    return _restaurantsRef.snapshots().map(
      /// `.map(...)`: Wandelt jeden Snapshot in eine Liste von Maps um.
      (snap) =>
          snap.docs
              .map(
                /// `.map(...)`: Wandelt jedes Dokument in eine Map um.
                (doc) => {
                  /// `...doc.data()`: Holt die Daten des Dokuments als Map.
                  /// Der Spread-Operator `...` fügt die Daten aus
                  /// `doc.data()` in die neue Map ein.
                  ...doc.data(),

                  /// `'id': doc.id`: Fügt die ID des Dokuments zur Map hinzu.
                  /// Die ID ist nicht in den Daten des Dokuments selbst
                  /// enthalten, sondern wird separat als `doc.id`
                  /// bereitgestellt.
                  'id': doc.id,
                },
              )
              .toList(), // Wandelt die Map in eine Liste um.
    );
  }

  /// `streamRestaurantsByRating(int rating)`: Gibt einen Stream von Listen von
  /// Restaurants zurück, die eine bestimmte Bewertung haben.
  @override
  Stream<List<Map<String, dynamic>>> streamRestaurantsByRating(int rating) {
    return _restaurantsRef
        .where('rating', isEqualTo: rating) // Filtert nach Bewertung.
        .snapshots() // Ruft einen Stream von Snapshots ab.
        .map(
          /// `.map(...)`: Wandelt jeden Snapshot in eine Liste von Maps um.
          (snap) =>
              snap.docs
                  .map(
                    (doc) => {
                      /// `...doc.data()`: Holt die Daten des Dokuments als Map.
                      /// Der Spread-Operator `...` fügt die Daten aus
                      /// `doc.data()` in die neue Map ein.
                      ...doc.data(),

                      /// `'id': doc.id`: Fügt die ID des Dokuments zur Map hinzu.
                      'id': doc.id,
                    },
                  )
                  .toList(),
        );
  }

  /// `streamRestaurantsByPostalCode(String postalCode)`: Gibt einen Stream von
  /// Listen von Restaurants zurück, die sich in einer bestimmten Postleitzahl
  /// befinden.
  @override
  Stream<List<Map<String, dynamic>>> streamRestaurantsByPostalCode(
    String postalCode,
  ) {
    return _restaurantsRef
        .where(
          'postalCode',
          isEqualTo: postalCode,
        ) // Filtert nach Postleitzahl.
        .snapshots() // Ruft einen Stream von Snapshots ab.
        .map(
          /// `.map(...)`: Wandelt jeden Snapshot in eine Liste von Maps um.
          (snap) =>
              snap.docs
                  .map(
                    (doc) => {
                      /// `...doc.data()`: Holt die Daten des Dokuments als Map.
                      /// Der Spread-Operator `...` fügt die Daten aus
                      /// `doc.data()` in die neue Map ein.
                      ...doc.data(),

                      /// `'id': doc.id`: Fügt die ID des Dokuments zur Map hinzu.
                      'id': doc.id,
                    },
                  )
                  .toList(),
        );
  }

  /// `streamRestaurantsByRatingAndPostalCode(int rating, String postalCode)`:
  /// Gibt einen Stream von Listen von Restaurants zurück, die eine bestimmte
  /// Bewertung haben und sich in einer bestimmten Postleitzahl befinden.
  @override
  Stream<List<Map<String, dynamic>>> streamRestaurantsByRatingAndPostalCode(
    int rating,
    String postalCode,
  ) {
    return _restaurantsRef
        .where('rating', isEqualTo: rating) // Filtert nach Bewertung.
        .where(
          'postalCode',
          isEqualTo: postalCode,
        ) // Filtert nach Postleitzahl.
        .snapshots() // Ruft einen Stream von Snapshots ab.
        .map(
          /// `.map(...)`: Wandelt jeden Snapshot in eine Liste von Maps um.
          (snap) =>
              snap.docs
                  .map(
                    (doc) => {
                      /// `...doc.data()`: Holt die Daten des Dokuments als Map.
                      /// Der Spread-Operator `...` fügt die Daten aus
                      /// `doc.data()` in die neue Map ein.
                      ...doc.data(),

                      /// `'id': doc.id`: Fügt die ID des Dokuments zur Map hinzu.
                      'id': doc.id,
                    },
                  )
                  .toList(),
        );
  }

  // 🔧 CRUD (Einmalige Operationen)
  /// `addRestaurant(Map<String, dynamic> restaurant)`: Fügt ein neues
  /// Restaurant hinzu.
  @override
  Future<void> addRestaurant(Map<String, dynamic> restaurant) async {
    /// `_restaurantsRef.doc(restaurant['id'])`: Erstellt eine Referenz auf das
    /// Dokument mit der ID `restaurant['id']`.
    final docRef = _restaurantsRef.doc(restaurant['id']);

    /// `await docRef.set(restaurant)`: Fügt das Restaurant-Dokument zu
    /// Firestore hinzu. `await` bedeutet, dass die Ausführung wartet, bis
    /// die Operation abgeschlossen ist.
    await docRef.set(restaurant);
  }

  /// `deleteRestaurant(String id)`: Löscht ein Restaurant anhand seiner ID.
  @override
  Future<void> deleteRestaurant(String id) async {
    /// `await _restaurantsRef.doc(id).delete()`: Löscht das Dokument mit der
    /// ID `id` aus Firestore.
    await _restaurantsRef.doc(id).delete();
  }

  /// `getRestaurantById(String id)`: Gibt ein Restaurant anhand seiner ID zurück.
  @override
  Future<Map<String, dynamic>> getRestaurantById(String id) async {
    /// `await _restaurantsRef.doc(id).get()`: Ruft das Dokument mit der ID `id`
    /// aus Firestore ab.
    final doc = await _restaurantsRef.doc(id).get();

    /// `if (doc.exists)`: Prüft, ob das Dokument existiert.
    if (doc.exists) {
      /// Gibt die Daten des Dokuments als Map zurück, zusammen mit der ID.
      return {
        /// `...doc.data()`: Holt die Daten des Dokuments als Map.
        /// Der Spread-Operator `...` fügt die Daten aus
        /// `doc.data()` in die neue Map ein.
        ...doc.data() as Map<String, dynamic>,

        /// `'id': doc.id`: Fügt die ID des Dokuments zur Map hinzu.
        'id': doc.id,
      };
    }

    /// Wirft eine Exception, wenn das Restaurant nicht gefunden wurde.
    throw Exception('Restaurant with id $id not found');
  }

  /// `getRestaurants()`: Gibt eine Liste aller Restaurants zurück.
  @override
  Future<List<Map<String, dynamic>>> getRestaurants() async {
    /// `await _restaurantsRef.get()`: Ruft alle Dokumente aus der
    /// 'restaurants'-Collection ab.
    final snapshot = await _restaurantsRef.get();

    /// Gibt die Daten aller Dokumente als Liste von Maps zurück, zusammen mit
    /// den IDs.
    return snapshot.docs
        .map(
          (doc) => {
            /// `...doc.data()`: Holt die Daten des Dokuments als Map.
            /// Der Spread-Operator `...` fügt die Daten aus
            /// `doc.data()` in die neue Map ein.
            ...doc.data(),

            /// `'id': doc.id`: Fügt die ID des Dokuments zur Map hinzu.
            'id': doc.id,
          },
        )
        .toList();
  }

  /// `getRestaurantsByPostalCode(String postalCode)`: Gibt eine Liste von
  /// Restaurants zurück, die sich in einer bestimmten Postleitzahl befinden.
  @override
  Future<List<Map<String, dynamic>>> getRestaurantsByPostalCode(
    String postalCode,
  ) async {
    /// `await _restaurantsRef.where('postalCode', isEqualTo: postalCode).get()`:
    /// Ruft alle Dokumente ab, bei denen das Feld 'postalCode' gleich der
    /// übergebenen `postalCode` ist.
    final snapshot =
        await _restaurantsRef.where('postalCode', isEqualTo: postalCode).get();

    /// Gibt die Daten aller Dokumente als Liste von Maps zurück, zusammen mit
    /// den IDs.
    return snapshot.docs
        .map(
          (doc) => {
            /// `...doc.data()`: Holt die Daten des Dokuments als Map.
            /// Der Spread-Operator `...` fügt die Daten aus
            /// `doc.data()` in die neue Map ein.
            ...doc.data(),

            /// `'id': doc.id`: Fügt die ID des Dokuments zur Map hinzu.
            'id': doc.id,
          },
        )
        .toList();
  }

  /// `getRestaurantsByRating(int rating)`: Gibt eine Liste von Restaurants
  /// zurück, die eine bestimmte Bewertung haben.
  @override
  Future<List<Map<String, dynamic>>> getRestaurantsByRating(int rating) async {
    /// `await _restaurantsRef.where('rating', isEqualTo: rating).get()`: Ruft
    /// alle Dokumente ab, bei denen das Feld 'rating' gleich der übergebenen
    /// `rating` ist.
    final snapshot =
        await _restaurantsRef.where('rating', isEqualTo: rating).get();

    /// Gibt die Daten aller Dokumente als Liste von Maps zurück, zusammen mit
    /// den IDs.
    return snapshot.docs
        .map(
          (doc) => {
            /// `...doc.data()`: Holt die Daten des Dokuments als Map.
            /// Der Spread-Operator `...` fügt die Daten aus
            /// `doc.data()` in die neue Map ein.
            ...doc.data(),

            /// `'id': doc.id`: Fügt die ID des Dokuments zur Map hinzu.
            'id': doc.id,
          },
        )
        .toList();
  }

  /// `getRestaurantsByRatingAndPostalCode(int rating, String postalCode)`: Gibt
  /// eine Liste von Restaurants zurück, die eine bestimmte Bewertung haben und
  /// sich in einer bestimmten Postleitzahl befinden.
  @override
  Future<List<Map<String, dynamic>>> getRestaurantsByRatingAndPostalCode(
    int rating,
    String postalCode,
  ) async {
    /// `await _restaurantsRef.where('rating', isEqualTo: rating).where('postalCode', isEqualTo: postalCode).get()`:
    /// Ruft alle Dokumente ab, bei denen das Feld 'rating' gleich der
    /// übergebenen `rating` ist und das Feld 'postalCode' gleich der
    /// übergebenen `postalCode` ist.
    final snapshot =
        await _restaurantsRef
            .where('rating', isEqualTo: rating)
            .where('postalCode', isEqualTo: postalCode)
            .get();

    /// Gibt die Daten aller Dokumente als Liste von Maps zurück, zusammen mit
    /// den IDs.
    return snapshot.docs
        .map(
          (doc) => {
            /// `...doc.data()`: Holt die Daten des Dokuments als Map.
            /// Der Spread-Operator `...` fügt die Daten aus
            /// `doc.data()` in die neue Map ein.
            ...doc.data(),

            /// `'id': doc.id`: Fügt die ID des Dokuments zur Map hinzu.
            'id': doc.id,
          },
        )
        .toList();
  }

  /// `updateRestaurant(Map<String, dynamic> restaurant)`: Aktualisiert ein
  /// bestehendes Restaurant.
  @override
  Future<void> updateRestaurant(Map<String, dynamic> restaurant) async {
    final id = restaurant['id'];
    if (id == null) {
      throw Exception('Restaurant update requires an id');
    }

    /// `await _restaurantsRef.doc(id).update(restaurant)`: Aktualisiert das
    /// Dokument mit der ID `id` in Firestore mit den Daten aus `restaurant`.
    await _restaurantsRef.doc(id).update(restaurant);
  }
}
