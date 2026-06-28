import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/yonwa_theme.dart';
import '../providers/commerce_provider.dart';
import '../screens/commerce/product_detail_page.dart';

class ProductDetailBottomSheet extends StatefulWidget {
  final CommerceItem item;

  const ProductDetailBottomSheet({super.key, required this.item});

  @override
  State<ProductDetailBottomSheet> createState() =>
      _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.65,
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(YonwaRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: YonwaSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(YonwaRadius.lg),
                    child: Image.network(
                      widget.item.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: YonwaSpacing.lg),

                  // Title
                  Text(
                    widget.item.title,
                    style: YonwaTextStyles.h2.copyWith(
                      color: isDark
                          ? YonwaColors.neutral0
                          : YonwaColors.neutral900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: YonwaSpacing.sm),

                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(widget.item.type).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(YonwaRadius.full),
                    ),
                    child: Text(
                      widget.item.typeLabel,
                      style: YonwaTextStyles.caption.copyWith(
                        color: _getTypeColor(widget.item.type),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: YonwaSpacing.md),

                  // Price
                  Text(
                    widget.item.price,
                    style: YonwaTextStyles.h3.copyWith(
                      color: YonwaColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: YonwaSpacing.md),

                  // Seller
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: YonwaColors.primary100,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: YonwaColors.primary500,
                        ),
                      ),
                      const SizedBox(width: YonwaSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vendeur',
                            style: YonwaTextStyles.caption.copyWith(
                              color: isDark
                                  ? YonwaColors.neutral400
                                  : YonwaColors.neutral500,
                            ),
                          ),
                          Text(
                            widget.item.seller,
                            style: YonwaTextStyles.label.copyWith(
                              color: isDark
                                  ? YonwaColors.neutral0
                                  : YonwaColors.neutral900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: YonwaSpacing.lg),

                  // Description
                  Text(
                    'Description',
                    style: YonwaTextStyles.label.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? YonwaColors.neutral0
                          : YonwaColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: YonwaSpacing.sm),
                  Text(
                    widget.item.description,
                    style: YonwaTextStyles.body.copyWith(
                      color: isDark
                          ? YonwaColors.neutral300
                          : YonwaColors.neutral600,
                    ),
                  ),
                  const SizedBox(height: YonwaSpacing.lg),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(YonwaSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? YonwaColors.neutral800 : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? YonwaColors.neutral700
                      : YonwaColors.neutral200,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<CommerceProvider>().addToCart(widget.item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${widget.item.title} ajouté au panier',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Panier'),
                  ),
                ),
                const SizedBox(width: YonwaSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(item: widget.item),
                        ),
                      );
                    },
                    child: Text(widget.item.actionLabel),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(CommerceItemType type) {
    switch (type) {
      case CommerceItemType.product:
        return YonwaColors.secondary;
      case CommerceItemType.touristExperience:
        return YonwaColors.primary500;
      case CommerceItemType.artisticExperience:
        return YonwaColors.accent;
    }
  }
}
