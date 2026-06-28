import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';
import '../../models/models.dart';
import '../../widgets/yonwa_badge.dart';

class ListingDetailScreen extends StatefulWidget {
  final Listing listing;
  const ListingDetailScreen({super.key, required this.listing});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  DateTime? _dateArrivee;
  DateTime? _dateDepart;

  Future<void> _pickDates() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: YonwaColors.primary500,
          ),
        ),
        child: child!,
      ),
    );
    if (range != null) {
      setState(() {
        _dateArrivee = range.start;
        _dateDepart = range.end;
      });
    }
  }

  int get _nombreNuits {
    if (_dateArrivee == null || _dateDepart == null) return 0;
    return _dateDepart!.difference(_dateArrivee!).inDays;
  }

  double get _montantTotal => widget.listing.prixParNuit * _nombreNuits;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final listing = widget.listing;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: isDark ? YonwaColors.neutral800 : YonwaColors.neutral0,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.4),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      Icon(Icons.home_rounded, size: 80,
                        color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral300),
                      Text(listing.ville, style: YonwaTextStyles.body.copyWith(
                        color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400,
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(YonwaSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          listing.titre,
                          style: YonwaTextStyles.h2.copyWith(
                            color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CertificationBadge(status: listing.certification),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 16, color: YonwaColors.neutral400),
                      Text(
                        '${listing.quartier}, ${listing.ville}',
                        style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
                      ),
                    ],
                  ),
                  const SizedBox(height: YonwaSpacing.md),

                  // Rating row
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 18, color: YonwaColors.warning),
                      Text(
                        ' ${listing.note.toStringAsFixed(1)}',
                        style: YonwaTextStyles.label.copyWith(
                          color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' · ${listing.nombreAvis} avis',
                        style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
                      ),
                      const Spacer(),
                      Text(
                        '${listing.prixParNuit.toInt()} FCFA',
                        style: YonwaTextStyles.h3.copyWith(color: YonwaColors.primary500),
                      ),
                      Text(
                        ' /nuit',
                        style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Description
                  Text(
                    'À propos',
                    style: YonwaTextStyles.h3.copyWith(
                      color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    listing.description,
                    style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
                  ),
                  const Divider(height: 32),

                  // Equipements
                  Text(
                    'Équipements',
                    style: YonwaTextStyles.h3.copyWith(
                      color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: listing.equipements.map((e) => YonwaBadge(
                      label: e,
                      color: YonwaColors.primary500,
                      icon: Icons.check_circle_rounded,
                    )).toList(),
                  ),
                  const Divider(height: 32),

                  // Date picker
                  Text(
                    'Choisir les dates',
                    style: YonwaTextStyles.h3.copyWith(
                      color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _pickDates,
                    child: Container(
                      padding: const EdgeInsets.all(YonwaSpacing.md),
                      decoration: BoxDecoration(
                        color: isDark ? YonwaColors.neutral800 : YonwaColors.neutral100,
                        borderRadius: BorderRadius.circular(YonwaRadius.md),
                        border: Border.all(
                          color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Arrivée', style: YonwaTextStyles.caption.copyWith(
                                  color: YonwaColors.neutral400,
                                )),
                                Text(
                                  _dateArrivee != null
                                      ? '${_dateArrivee!.day}/${_dateArrivee!.month}/${_dateArrivee!.year}'
                                      : 'Choisir',
                                  style: YonwaTextStyles.body.copyWith(
                                    color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 0.5,
                            height: 36,
                            color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral300,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Départ', style: YonwaTextStyles.caption.copyWith(
                                    color: YonwaColors.neutral400,
                                  )),
                                  Text(
                                    _dateDepart != null
                                        ? '${_dateDepart!.day}/${_dateDepart!.month}/${_dateDepart!.year}'
                                        : 'Choisir',
                                    style: YonwaTextStyles.body.copyWith(
                                      color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Icon(Icons.calendar_today_rounded, color: YonwaColors.primary500),
                        ],
                      ),
                    ),
                  ),

                  if (_nombreNuits > 0) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(YonwaSpacing.md),
                      decoration: BoxDecoration(
                        color: YonwaColors.primary50,
                        borderRadius: BorderRadius.circular(YonwaRadius.md),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$_nombreNuits nuit${_nombreNuits > 1 ? 's' : ''} × ${listing.prixParNuit.toInt()} FCFA',
                            style: YonwaTextStyles.body.copyWith(color: YonwaColors.primary700),
                          ),
                          Text(
                            '${_montantTotal.toInt()} FCFA',
                            style: YonwaTextStyles.h3.copyWith(color: YonwaColors.primary600),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Book button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(YonwaSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : YonwaColors.neutral0,
          border: Border(
            top: BorderSide(
              color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${listing.prixParNuit.toInt()} FCFA',
                  style: YonwaTextStyles.h3.copyWith(color: YonwaColors.primary500),
                ),
                Text(
                  'par nuit',
                  style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500),
                ),
              ],
            ),
            const SizedBox(width: YonwaSpacing.md),
            Expanded(
              child: ElevatedButton(
                onPressed: _nombreNuits > 0
                    ? () => Navigator.of(context).pushNamed('/payment')
                    : _pickDates,
                child: Text(_nombreNuits > 0 ? 'Réserver · ${_montantTotal.toInt()} FCFA' : 'Choisir les dates'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


