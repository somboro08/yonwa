import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../theme/yonwa_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  bool _isInWishlist = false;
  int _quantity = 1;
  final PageController _pageController = PageController();

  final Map<String, dynamic> _productData = {
    'id': '1',
    'title': 'Poterie artisanale en terre cuite',
    'price': 15000,
    'currency': 'FCFA',
    'category': 'Artisanat',
    'rating': 4.8,
    'reviews': 127,
    'seller': {
      'name': 'Koffi Mensah',
      'avatar': 'assets/images/hero1.jpg',
      'verified': true,
      'rating': 4.9,
    },
    'description':
        'Magnifique poterie artisanale faite à la main par des artisans locaux. Chaque pièce est unique et représente le savoir-faire ancestral du Bénin.',
    'specifications': {
      'Matériau': 'Terre cuite',
      'Dimensions': '25 x 25 x 30 cm',
      'Poids': '2.5 kg',
      'Couleur': 'Terre cuite naturelle',
      'Finition': 'Polie et vernie',
    },
    'images': [
      'assets/images/hero1.jpg',
      'assets/images/hero2.jpg',
      'assets/images/hero3.jpeg',
      'assets/images/hero4.jpeg',
    ],
    'videos': ['assets/videos/product1.mp4'],
    'stock': 15,
    'delivery': {'estimated': '2-3 jours', 'free': true},
    'similarProducts': [
      {
        'title': 'Statue en bronze',
        'price': 50000,
        'image': 'assets/images/hero1.jpg',
      },
      {
        'title': 'Tissu Wax premium',
        'price': 35000,
        'image': 'assets/images/hero2.jpg',
      },
      {
        'title': 'Pagne traditionnel',
        'price': 12000,
        'image': 'assets/images/hero3.jpeg',
      },
    ],
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YonwaColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: Colors.white,
                size: 24,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => setState(() => _isInWishlist = !_isInWishlist),
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHeartAdd,
                  color: _isInWishlist ? Colors.red : Colors.white,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedShare01,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount:
                        _productData['images'].length +
                        _productData['videos'].length,
                    onPageChanged: (index) =>
                        setState(() => _currentImageIndex = index),
                    itemBuilder: (context, index) {
                      final isVideo = index >= _productData['images'].length;
                      final mediaIndex = isVideo
                          ? index - _productData['images'].length
                          : index;

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          if (isVideo)
                            _buildVideoPlayer(
                              _productData['videos'][mediaIndex],
                            )
                          else
                            Image.asset(
                              _productData['images'][mediaIndex],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: YonwaColors.neutral200,
                                child: const Icon(
                                  Icons.image,
                                  color: YonwaColors.neutral400,
                                  size: 50,
                                ),
                              ),
                            ),
                          if (isVideo)
                            Container(
                              color: Colors.black.withValues(alpha: 0.3),
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _productData['images'].length +
                                    _productData['videos'].length,
                                (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_currentImageIndex + 1}/${_productData['images'].length + _productData['videos'].length}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: YonwaColors.primary50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _productData['category'],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: YonwaColors.primary500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _productData['title'],
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: YonwaColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedStar,
                            color: Color(0xFFC9A84C),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _productData['rating'].toString(),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: YonwaColors.neutral900,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${_productData['reviews']} avis)',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: YonwaColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            '${_productData['price']} ${_productData['currency']}',
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: YonwaColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'En stock (${_productData['stock']})',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: YonwaColors.neutral200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: YonwaColors.primary500,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  _productData['seller']['avatar'],
                                ),
                                backgroundColor: YonwaColors.neutral200,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _productData['seller']['name'],
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: YonwaColors.neutral900,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const HugeIcon(
                                        icon: HugeIcons.strokeRoundedTick01,
                                        color: Colors.blue,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const HugeIcon(
                                        icon: HugeIcons.strokeRoundedStar,
                                        color: Color(0xFFC9A84C),
                                        size: 12,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        _productData['seller']['rating']
                                            .toString(),
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: YonwaColors.neutral700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Voir profil',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: YonwaColors.primary500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: YonwaColors.neutral200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: YonwaColors.primary50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedDeliveryBox01,
                            color: YonwaColors.primary500,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Livraison gratuite',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: YonwaColors.neutral900,
                                ),
                              ),
                              Text(
                                'Livraison estimée: ${_productData['delivery']['estimated']}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: YonwaColors.neutral500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: YonwaColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _productData['description'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.6,
                          color: YonwaColors.neutral700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spécifications',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: YonwaColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: YonwaColors.neutral200),
                        ),
                        child: Column(
                          children: _productData['specifications'].entries.map((
                            entry,
                          ) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    entry.key,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: YonwaColors.neutral600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    entry.value,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: YonwaColors.neutral900,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Produits similaires',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: YonwaColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _productData['similarProducts'].length,
                          itemBuilder: (context, index) {
                            final product =
                                _productData['similarProducts'][index];
                            return Container(
                              width: 140,
                              margin: EdgeInsets.only(
                                right:
                                    index <
                                        _productData['similarProducts'].length -
                                            1
                                    ? 10
                                    : 0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: YonwaColors.neutral200,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.asset(
                                        product['image'],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: YonwaColors.neutral200,
                                          child: const Icon(
                                            Icons.image,
                                            color: YonwaColors.neutral400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            product['title'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: YonwaColors.neutral900,
                                            ),
                                          ),
                                          Text(
                                            '${product['price']} FCFA',
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: YonwaColors.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: YonwaColors.neutral100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          },
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedMinusSign,
                            color: YonwaColors.neutral700,
                            size: 18,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        SizedBox(
                          width: 32,
                          child: Text(
                            '$_quantity',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: YonwaColors.neutral900,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_quantity < _productData['stock']) {
                              setState(() => _quantity++);
                            }
                          },
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedPlusSign,
                            color: YonwaColors.neutral700,
                            size: 18,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Produit ajouté au panier'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: YonwaColors.primary500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedShoppingBag01,
                        color: YonwaColors.primary500,
                        size: 20,
                      ),
                      label: Text(
                        'Panier',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: YonwaColors.primary500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmation'),
                            content: Text(
                              'Voulez-vous réserver "${_productData['title']}" pour $_quantity article(s) ?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(),
                                child: const Text('Annuler'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Produit réservé avec succès !',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: YonwaColors.primary500,
                                ),
                                child: const Text('Confirmer'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: YonwaColors.primary500,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedShoppingCart01,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Réserver',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: YonwaColors.neutral600,
                    ),
                  ),
                  Text(
                    '${_productData['price'] * _quantity} ${_productData['currency']}',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: YonwaColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(String videoPath) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_filled, color: Colors.white, size: 64),
            SizedBox(height: 8),
            Text(
              'Vidéo du produit',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
