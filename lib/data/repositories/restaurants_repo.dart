abstract class RestaurantsRepo {
  // 🔁 Live-Streams
  Stream<List<Map<String, dynamic>>> streamRestaurants();
  Stream<List<Map<String, dynamic>>> streamRestaurantsByRating(int rating);
  Stream<List<Map<String, dynamic>>> streamRestaurantsByPostalCode(
    String postalCode,
  );

  // 🔧 CRUD-Operationen (Einmalige Abfragen)
  Future<List<Map<String, dynamic>>> getRestaurants();
  Future<void> addRestaurant(Map<String, dynamic> restaurant);
  Future<void> updateRestaurant(Map<String, dynamic> restaurant);
  Future<void> deleteRestaurant(String id);
  Future<Map<String, dynamic>> getRestaurantById(String id);
  Future<List<Map<String, dynamic>>> getRestaurantsByPostalCode(
    String postalCode,
  );
  Future<List<Map<String, dynamic>>> getRestaurantsByRating(int rating);
}
