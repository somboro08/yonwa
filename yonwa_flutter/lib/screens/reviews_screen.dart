import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class ReviewsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const ReviewsScreen({super.key, required this.onBack});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _rating = 0;
  int _hover = 0;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: 'Laisser un avis', onBack: widget.onBack),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Experience
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.06), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(width: 66, height: 66, child: NetworkImg(url: MockData.experiences[1].image)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(MockData.experiences[1].title, maxLines: 2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.3)),
                        const SizedBox(height: 4),
                        Text('2 Juin 2025 · ${MockData.experiences[1].guide}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Star rating
            Center(
              child: Column(
                children: [
                  const Text('Votre note globale', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final filled = (_hover > 0 ? _hover : _rating) > i;
                      return GestureDetector(
                        onTap: () => setState(() => _rating = i + 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            filled ? Icons.star_rounded : Icons.star_border_rounded,
                            size: 40,
                            color: filled ? AppColors.secondary : AppColors.textLight,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _rating == 0 ? 'Appuyez pour noter' : ['', 'Mauvais', 'Passable', 'Bien', 'Très bien', 'Excellent !'][_rating],
                    style: TextStyle(color: _rating > 0 ? AppColors.secondary : AppColors.textMuted, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Criteria
            const Text('Critères détaillés', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 12),
            ...[
              ["Qualité de l'expérience", 5],
              ["Accueil & communication", 4],
              ["Rapport qualité-prix", 5],
            ].map((row) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  Expanded(child: Text(row[0] as String, style: const TextStyle(fontSize: 13, color: AppColors.textDark))),
                  Row(
                    children: List.generate(5, (i) => Icon(
                      i < (row[1] as int) ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 16,
                      color: i < (row[1] as int) ? AppColors.secondary : AppColors.textLight,
                    )),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),

            // Comment
            const Text('Votre commentaire', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText: 'Décrivez votre expérience pour aider les autres voyageurs...',
                alignLabelWithHint: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                child: const Text("Publier l'avis"),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
