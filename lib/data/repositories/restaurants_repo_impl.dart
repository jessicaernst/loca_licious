import 'package:loca_licious/data/repositories/restaurants_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantsRepoImpl implements RestaurantsRepo {
  final _restaurantsRef = FirebaseFirestore.instance.collection('restaurants');

  // 🔄 STREAMS (Live)
  @override
  Stream<List<Map<String, dynamic>>> streamRestaurants() {
    return _restaurantsRef.snapshots().map(
      (snap) => snap.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList(),
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> streamRestaurantsByRating(int rating) {
    return _restaurantsRef
        .where('rating', isEqualTo: rating)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList(),
        );
  }

  @override
  Stream<List<Map<String, dynamic>>> streamRestaurantsByPostalCode(
    String postalCode,
  ) {
    return _restaurantsRef
        .where('postalCode', isEqualTo: postalCode)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList(),
        );
  }

  // 🔧 CRUD (Einmalige Operationen)
  @override
  Future<void> addRestaurant(Map<String, dynamic> restaurant) async {
    final docRef = _restaurantsRef.doc(restaurant['id']);
    await docRef.set(restaurant);
  }

  @override
  Future<void> deleteRestaurant(String id) async {
    await _restaurantsRef.doc(id).delete();
  }

  @override
  Future<Map<String, dynamic>> getRestaurantById(String id) async {
    final doc = await _restaurantsRef.doc(id).get();
    if (doc.exists) {
      return {...doc.data()!, 'id': doc.id};
    }
    throw Exception('Restaurant with id $id not found');
  }

  @override
  Future<List<Map<String, dynamic>>> getRestaurants() async {
    final snapshot = await _restaurantsRef.get();
    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getRestaurantsByPostalCode(
    String postalCode,
  ) async {
    final snapshot =
        await _restaurantsRef
            .where('postalCode', isEqualTo: postalCode)
            .get(); // HIER: plz zu postalCode geändert
    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getRestaurantsByRating(int rating) async {
    final snapshot =
        await _restaurantsRef.where('rating', isEqualTo: rating).get();
    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  @override
  Future<void> updateRestaurant(Map<String, dynamic> restaurant) async {
    final id = restaurant['id'];
    if (id == null) {
      throw Exception('Restaurant update requires an id');
    }
    await _restaurantsRef.doc(id).update(restaurant);
  }
}
