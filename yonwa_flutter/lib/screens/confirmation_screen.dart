import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ConfirmationScreen extends StatelessWidget {
  final Function(String) navigate;
  const ConfirmationScreen({super.key, required this.navigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Success icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.green.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 28),
              const Text(
                'Réservation confirmée !',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Votre aventure au cœur du Bénin est réservée. Préparez-vous à vivre quelque chose d\'exceptionnel.',
                style: TextStyle(fontSize: 14, color: AppColors.textMuted, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Booking card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    const Text('DÉTAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1.2)),
                    const SizedBox(height: 12),
                    ...const [
                      ['Expérience', "Palais Royaux d'Abomey"],
                      ['Guide', 'Prosper Houédanou'],
                      ['Date', '14 Juillet 2025 · 09:00'],
                      ['Participants', '2 adultes'],
                      ['Montant payé', '73 500 FCFA'],
                    ].map((row) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(row[0], style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          Text(row[1], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                        ],
                      ),
                    )),
                    const Divider(color: AppColors.border, height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Référence', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              Text('YNW-2025-07-4821', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            ],
                          ),
                        ),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
                          child: const Icon(Icons.qr_code_rounded, size: 30, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Actions
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => navigate('history'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Voir mes réservations'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => navigate('home'),
                  child: const Text("Retour à l'accueil", style: TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
