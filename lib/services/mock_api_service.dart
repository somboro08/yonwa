import '../mock/mock_data.dart';
import '../models/models.dart';

enum MockSearchResultType { profile, listing, product, news }

class MockSearchResult {
  final String id;
  final MockSearchResultType type;
  final String title;
  final String subtitle;
  final String imageUrl;
  final List<String> keywords;
  final Object payload;

  const MockSearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.keywords,
    required this.payload,
  });
}

class MockApiService {
  const MockApiService();

  Future<List<Map<String, dynamic>>> getProfiles() async {
    await _latency();
    return MockData.actors;
  }

  Future<List<Listing>> getListings() async {
    await _latency();
    return MockData.listings;
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    await _latency();
    return MockData.products;
  }

  Future<List<Map<String, dynamic>>> getNews() async {
    await _latency();
    return MockData.news;
  }

  Future<List<MockSearchResult>> search({
    String query = '',
    String category = 'Tout',
  }) async {
    await _latency();
    final normalizedQuery = _normalize(query);
    final normalizedCategory = _normalize(category);
    final allResults = <MockSearchResult>[
      ...MockData.actors.map(_profileResult),
      ...MockData.listings.map(_listingResult),
      ...MockData.products.map(_productResult),
      ...MockData.news.map(_newsResult),
    ];

    return allResults.where((result) {
      final textMatch = normalizedQuery.isEmpty ||
          _normalize('${result.title} ${result.subtitle} ${result.keywords.join(' ')}')
              .contains(normalizedQuery);
      final categoryMatch = normalizedCategory == 'tout' ||
          _normalize(result.keywords.join(' ')).contains(normalizedCategory) ||
          _matchesType(result.type, normalizedCategory);
      return textMatch && categoryMatch;
    }).toList();
  }

  MockSearchResult _profileResult(Map<String, dynamic> actor) {
    final role = actor['role'] as UserRole;
    return MockSearchResult(
      id: 'profile_${actor['nom']}',
      type: MockSearchResultType.profile,
      title: actor['nom'] as String,
      subtitle: '${role.displayName} - ${actor['ville']}',
      imageUrl: actor['photoUrl'] as String,
      keywords: [
        role.displayName,
        _profileCategoryKeyword(role),
        actor['ville'] as String,
        ...(actor['savoirFaire'] as List).cast<String>(),
        ...(actor['servicesProduits'] as List).cast<String>(),
      ],
      payload: actor,
    );
  }

  MockSearchResult _listingResult(Listing listing) {
    return MockSearchResult(
      id: listing.id,
      type: MockSearchResultType.listing,
      title: listing.titre,
      subtitle: '${listing.quartier}, ${listing.ville} - ${listing.prixParNuit.toInt()} FCFA/nuit',
      imageUrl: 'https://images.unsplash.com/photo-1590674899484-d56419821d99?q=80&w=600',
      keywords: ['Logements', listing.ville, listing.quartier, ...listing.equipements],
      payload: listing,
    );
  }

  MockSearchResult _productResult(Map<String, dynamic> product) {
    return MockSearchResult(
      id: 'product_${product['title']}',
      type: MockSearchResultType.product,
      title: product['title'] as String,
      subtitle: '${product['price']} - ${product['seller']}',
      imageUrl: product['image'] as String,
      keywords: ['Produits', product['category'] as String, product['seller'] as String],
      payload: product,
    );
  }

  MockSearchResult _newsResult(Map<String, dynamic> item) {
    return MockSearchResult(
      id: 'news_${item['title']}',
      type: MockSearchResultType.news,
      title: item['title'] as String,
      subtitle: '${item['type']} - ${item['location']}',
      imageUrl: item['image'] as String,
      keywords: ['Actualites', 'Experiences', item['type'] as String, item['location'] as String],
      payload: item,
    );
  }

  bool _matchesType(MockSearchResultType type, String category) {
    return switch (type) {
      MockSearchResultType.profile => false,
      MockSearchResultType.listing => category == 'logements',
      MockSearchResultType.product => category == 'produits',
      MockSearchResultType.news => ['actualites', 'experiences'].contains(category),
    };
  }

  String _profileCategoryKeyword(UserRole role) {
    return switch (role) {
      UserRole.artisan || UserRole.artisanConcepteur || UserRole.artisanRevendeur => 'Artisans',
      UserRole.guideTouristique => 'Guides',
      UserRole.revendeur => 'Revendeurs',
      UserRole.voyageur => 'Profils',
    };
  }

  Future<void> _latency() => Future.delayed(const Duration(milliseconds: 180));

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('à', 'a')
        .replaceAll('ô', 'o')
        .replaceAll('ù', 'u')
        .replaceAll('ç', 'c');
  }
}
