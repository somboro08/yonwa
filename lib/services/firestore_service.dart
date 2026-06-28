import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import 'auth_service.dart';
import 'mock_api_service.dart';

class FirestoreService {
  final MockApiService _mockApi = const MockApiService();

  FirebaseFirestore get _db {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      throw UnimplementedError('Firestore non disponible en mode simulation');
    }
  }

  bool get _isMock => AuthService().isMockMode;

  // --- USERS ---
  Future<void> saveUser(YonwaUser user) async {
    if (_isMock) return;
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Future<YonwaUser?> getUser(String id) async {
    if (_isMock) return null;
    final doc = await _db.collection('users').doc(id).get();
    return doc.exists ? YonwaUser.fromMap(doc.data()!) : null;
  }

  // --- IDENTITY VERIFICATION ---
  Future<void> updateUserVerification(
    String userId,
    IdentityVerificationStatus status, {
    String? idCardUrl,
    String? birthCertificateUrl,
  }) async {
    if (_isMock) return;
    Map<String, dynamic> updateData = {
      'verificationStatus': status.name,
    };
    if (idCardUrl != null) updateData['idCardUrl'] = idCardUrl;
    if (birthCertificateUrl != null) updateData['birthCertificateUrl'] = birthCertificateUrl;

    await _db.collection('users').doc(userId).update(updateData);
  }

  // --- FAVORITES ---
  Future<void> addFavorite(String userId, String listingId) async {
    if (_isMock) return;
    await _db.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayUnion([listingId]),
    });
  }

  Future<void> removeFavorite(String userId, String listingId) async {
    if (_isMock) return;
    await _db.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayRemove([listingId]),
    });
  }

  Stream<List<Listing>> getFavoriteListings(List<String> listingIds) {
    if (_isMock) {
      return Stream.fromFuture(
        _mockApi.getListings().then(
              (listings) => listingIds.isEmpty
                  ? listings.take(2).toList()
                  : listings.where((listing) => listingIds.contains(listing.id)).toList(),
            ),
      );
    }
    if (listingIds.isEmpty) {
      return Stream.value([]);
    }
    return _db
        .collection('listings')
        .where(FieldPath.documentId, whereIn: listingIds)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Listing.fromMap(doc.data())).toList());
  }

  // --- LISTINGS ---
  Stream<List<Listing>> getListings() {
    if (_isMock) return Stream.fromFuture(_mockApi.getListings());
    return _db.collection('listings').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Listing.fromMap(doc.data())).toList());
  }

  Future<void> addListing(Listing listing) async {
    if (_isMock) return;
    await _db.collection('listings').doc(listing.id).set(listing.toMap());
  }

  // --- BOOKINGS ---
  Future<void> createBooking(Booking booking) async {
    if (_isMock) return;
    await _db.collection('bookings').doc(booking.id).set(booking.toMap());
  }

  Stream<List<Booking>> getUserBookings(String userId) {
    if (_isMock) return Stream.value([]);
    return _db
        .collection('bookings')
        .where('voyageurId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Booking.fromMap(doc.data())).toList());
  }
}
