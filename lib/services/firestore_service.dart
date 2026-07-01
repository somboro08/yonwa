import '../models/models.dart';
import 'auth_service.dart';
import 'mock_api_service.dart';

class FirestoreService {
  final MockApiService _mockApi = const MockApiService();

  bool get _isMock => AuthService().isMockMode;

  // --- USERS ---
  Future<void> saveUser(YonwaUser user) async {
    if (_isMock) return;
    throw UnimplementedError(
      'Firestore backend removed; enable mock mode for testing',
    );
  }

  Future<YonwaUser?> getUser(String id) async {
    if (_isMock) return null;
    throw UnimplementedError(
      'Firestore backend removed; enable mock mode for testing',
    );
  }

  // --- IDENTITY VERIFICATION ---
  Future<void> updateUserVerification(
    String userId,
    IdentityVerificationStatus status, {
    String? idCardUrl,
    String? birthCertificateUrl,
  }) async {
    if (_isMock) return;
    throw UnimplementedError(
      'Firestore backend removed; enable mock mode for testing',
    );
  }

  // --- FAVORITES ---
  Future<void> addFavorite(String userId, String listingId) async {
    if (_isMock) return;
    throw UnimplementedError(
      'Firestore backend removed; enable mock mode for testing',
    );
  }

  Future<void> removeFavorite(String userId, String listingId) async {
    if (_isMock) return;
    throw UnimplementedError(
      'Firestore backend removed; enable mock mode for testing',
    );
  }

  Stream<List<Listing>> getFavoriteListings(List<String> listingIds) {
    if (_isMock) {
      return Stream.fromFuture(
        _mockApi.getListings().then(
          (listings) => listingIds.isEmpty
              ? listings.take(2).toList()
              : listings
                    .where((listing) => listingIds.contains(listing.id))
                    .toList(),
        ),
      );
    }
    throw UnimplementedError(
      'Firestore backend removed; enable mock mode for testing',
    );
  }

  // --- LISTINGS ---
  Stream<List<Listing>> getListings() {
    if (_isMock) return Stream.fromFuture(_mockApi.getListings());
    throw UnimplementedError(
      'Firestore backend removed; enable mock mode for testing',
    );
  }

  Future<void> addListing(Listing listing) async {
    if (_isMock) return;
    throw UnimplementedError(
      'Firestore backend removed; enable mock mode for testing',
    );
  }

  // --- BOOKINGS ---
  Future<void> createBooking(Booking booking) async {
    if (_isMock) return;
    throw UnimplementedError(
      'Firestore backend removed; enable mock mode for testing',
    );
  }

  Stream<List<Booking>> getUserBookings(String userId) {
    if (_isMock) return Stream.value([]);
    throw UnimplementedError(
      'Firestore backend removed; enable mock mode for testing',
    );
  }
}
