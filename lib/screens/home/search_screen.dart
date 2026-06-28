import 'package:flutter/material.dart';
import '../../mock/mock_data.dart';
import '../../models/models.dart';
import '../../services/mock_api_service.dart';
import '../../theme/yonwa_theme.dart';
import '../../widgets/listing_card.dart';
import '../profile/detailed_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;
  final String initialCategory;

  const SearchScreen({
    super.key,
    this.initialQuery = '',
    this.initialCategory = 'Tout',
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _api = const MockApiService();
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _selectedCategory = 'Tout';
  List<MockSearchResult> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;
    _selectedCategory = widget.initialCategory;
    _searchController.addListener(_runSearch);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    _runSearch();
  }

  @override
  void dispose() {
    _searchController.removeListener(_runSearch);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _runSearch() async {
    setState(() => _isLoading = true);
    final results = await _api.search(
      query: _searchController.text,
      category: _selectedCategory,
    );
    if (!mounted) return;
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
      appBar: AppBar(
        title: const Text('Recherche'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: _buildSearchBar(isDark),
          ),
          _buildCategories(isDark),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? _buildEmptyState(isDark)
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _buildResultCard(_results[index], isDark),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(YonwaRadius.xl),
        border: Border.all(
          color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: YonwaColors.primary500),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Rechercher un profil, produit, lieu...',
                border: InputBorder.none,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: _searchController.clear,
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Effacer',
            ),
        ],
      ),
    );
  }

  Widget _buildCategories(bool isDark) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: MockData.searchCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = MockData.searchCategories[index];
          final selected = category == _selectedCategory;
          return FilterChip(
            selected: selected,
            label: Text(category),
            showCheckmark: false,
            selectedColor: YonwaColors.primary500,
            labelStyle: YonwaTextStyles.label.copyWith(
              color: selected
                  ? Colors.white
                  : (isDark ? YonwaColors.neutral200 : YonwaColors.neutral700),
            ),
            side: BorderSide(
              color: selected
                  ? YonwaColors.primary500
                  : (isDark ? YonwaColors.neutral700 : YonwaColors.neutral200),
            ),
            onSelected: (_) {
              setState(() => _selectedCategory = category);
              _runSearch();
            },
          );
        },
      ),
    );
  }

  Widget _buildResultCard(MockSearchResult result, bool isDark) {
    if (result.type == MockSearchResultType.listing) {
      return ListingCard(listing: result.payload as Listing);
    }

    final icon = switch (result.type) {
      MockSearchResultType.profile => Icons.person_rounded,
      MockSearchResultType.product => Icons.shopping_bag_rounded,
      MockSearchResultType.news => Icons.article_rounded,
      MockSearchResultType.listing => Icons.home_rounded,
    };

    return InkWell(
      borderRadius: BorderRadius.circular(YonwaRadius.lg),
      onTap: () {
        if (result.type == MockSearchResultType.profile) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailedProfileScreen(actor: result.payload as Map<String, dynamic>),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(YonwaRadius.lg),
          border: Border.all(
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(YonwaRadius.md),
              child: Image.network(
                result.imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 72,
                  height: 72,
                  color: YonwaColors.neutral200,
                  child: Icon(icon, color: YonwaColors.primary500),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 16, color: YonwaColors.primary500),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _typeLabel(result.type),
                          style: YonwaTextStyles.caption.copyWith(
                            color: YonwaColors.primary500,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: YonwaTextStyles.h3.copyWith(
                      color: isDark ? Colors.white : YonwaColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: YonwaTextStyles.caption.copyWith(
                      color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: YonwaColors.neutral400),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral300,
            ),
            const SizedBox(height: 12),
            Text(
              'Aucun resultat trouve',
              style: YonwaTextStyles.h3.copyWith(
                color: isDark ? Colors.white : YonwaColors.neutral800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Essayez une categorie ou un mot-cle comme guide, textile, Ouidah.',
              textAlign: TextAlign.center,
              style: YonwaTextStyles.body.copyWith(
                color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(MockSearchResultType type) {
    return switch (type) {
      MockSearchResultType.profile => 'Profil',
      MockSearchResultType.listing => 'Logement',
      MockSearchResultType.product => 'Produit',
      MockSearchResultType.news => 'Actualite',
    };
  }
}
