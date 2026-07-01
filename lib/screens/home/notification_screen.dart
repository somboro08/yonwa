import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationModel {
  final String id;
  final String sender;
  final String title;
  final String message;
  final String time;
  final String fullDetail;
  bool isRead;
  bool isStarred;
  final IconData icon;
  final Color color;

  _NotificationModel({
    required this.id,
    required this.sender,
    required this.title,
    required this.message,
    required this.time,
    required this.fullDetail,
    this.isRead = false,
    required this.icon,
    required this.color,
  });
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<_NotificationModel> _notifications = [
    _NotificationModel(
      id: '1',
      sender: 'Service Réservation',
      title: 'Réservation confirmée avec Koffi',
      message: 'Votre guide Koffi Mensah a accepté votre demande de visite de Ganvié.',
      time: '09:41',
      fullDetail: 'Bonjour Marc,\n\nVotre réservation pour la visite guidée "Ganvié - La Venise d\'Afrique" le samedi 22 juin avec Koffi Mensah a été confirmée avec succès.\n\nTarif : 15 000 FCFA par personne (total 60 000 FCFA pour 4 personnes).\nLe point de rendez-vous est fixé à l\'embarcadère d\'Abomey-Calavi à 9h00.\n\nBon voyage !',
      isRead: false,
      icon: Icons.check_circle_rounded,
      color: YonwaColors.success,
    ),
    _NotificationModel(
      id: '2',
      sender: 'Équipe Yonwa',
      title: 'Offre exclusive : -15% sur l\'artisanat',
      message: 'Rencontrez Amina Cissé à Bohicon et profitez d\'un atelier de tissage gratuit.',
      time: 'Hier',
      fullDetail: 'Profitez de notre offre spéciale de saison !\n\nEn réservant une démonstration de tissage traditionnel de pagne avec notre artisane certifiée Amina Cissé à Bohicon, bénéficiez de 15% de réduction sur l\'achat de votre premier pagne tissé main.\n\nCode promo à présenter : ATELIER15\nValable jusqu\'au 30 juin 2026.',
      isRead: false,
      icon: Icons.local_offer_rounded,
      color: YonwaColors.warning,
    ),
    _NotificationModel(
      id: '3',
      sender: 'Système de Certification',
      title: 'Audit de profil réussi !',
      message: 'Félicitations, votre profil de Guide Local a été certifié par l\'équipe.',
      time: '15 juin',
      fullDetail: 'Félicitations !\n\nSuite à l\'analyse de vos documents officiels et de votre parcours, votre profil a été certifié conforme. Le badge "Guide Certifié" est désormais visible sur vos fiches.\n\nMerci de faire vivre et découvrir le patrimoine béninois avec passion et professionnalisme !',
      isRead: true,
      icon: Icons.verified_rounded,
      color: YonwaColors.certified,
    ),
    _NotificationModel(
      id: '4',
      sender: 'Sécurité Yonwa',
      title: 'Nouvelle connexion détectée',
      message: 'Une connexion à votre compte a été effectuée depuis un nouvel appareil.',
      time: '12 juin',
      fullDetail: 'Alerte de sécurité :\n\nUne nouvelle connexion à votre compte Yonwa a été enregistrée le 12 juin à 14h22 depuis un appareil Infinix Note 30 à Cotonou, Bénin.\n\nSi vous n\'êtes pas à l\'origine de cette action, veuillez immédiatement réinitialiser votre mot de passe depuis l\'écran des paramètres de l\'application.',
      isRead: true,
      icon: Icons.security_rounded,
      color: YonwaColors.error,
    ),
  ];

  void _showNotificationDetail(_NotificationModel notif, bool isDark) {
    setState(() {
      notif.isRead = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral900 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Sender info & time
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: notif.color.withOpacity(0.1),
                  child: Icon(notif.icon, color: notif.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif.sender,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark ? Colors.white : YonwaColors.neutral900,
                        ),
                      ),
                      Text(
                        'Pour : Moi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  notif.time,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Subject title
            Text(
              notif.title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : YonwaColors.neutral900,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // Message Body
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  notif.fullDetail,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: isDark ? YonwaColors.neutral300 : YonwaColors.neutral700,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            
            // Action button
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: YonwaColors.primary500,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Fermer',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : const Color(0xFFF6F8FC), // Gmail light background
      appBar: AppBar(
        backgroundColor: isDark ? YonwaColors.neutral800 : Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: isDark ? Colors.white : YonwaColors.neutral800,
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : YonwaColors.neutral900,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
            color: isDark ? Colors.white : YonwaColors.neutral700,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            color: isDark ? YonwaColors.neutral800 : Colors.white,
            onSelected: (val) {
              if (val == 'read_all') {
                setState(() {
                  for (var n in _notifications) {
                    n.isRead = true;
                  }
                });
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'read_all',
                child: Text(
                  'Tout marquer comme lu',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: isDark ? Colors.white : YonwaColors.neutral800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: isDark ? YonwaColors.neutral800 : Colors.grey[200],
        ),
        itemBuilder: (context, index) {
          final notif = _notifications[index];
          final hasUnreadStyle = !notif.isRead;
          
          return InkWell(
            onTap: () => _showNotificationDetail(notif, isDark),
            child: Container(
              color: notif.isRead
                  ? Colors.transparent
                  : (isDark ? YonwaColors.primary500.withOpacity(0.06) : const Color(0xFFE8F0FE)), // Gmail unread blue tint
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circular Sender Avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: notif.color.withOpacity(0.12),
                    child: Icon(notif.icon, color: notif.color, size: 20),
                  ),
                  const SizedBox(width: 14),
                  
                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: Text(
                                notif.sender,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: hasUnreadStyle ? FontWeight.w800 : FontWeight.w500,
                                  color: isDark ? Colors.white : YonwaColors.neutral900,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              notif.time,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: hasUnreadStyle ? FontWeight.bold : FontWeight.normal,
                                color: hasUnreadStyle
                                    ? YonwaColors.primary500
                                    : YonwaColors.neutral400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          notif.title,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: hasUnreadStyle ? FontWeight.bold : FontWeight.w500,
                            color: isDark ? Colors.white : YonwaColors.neutral800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          notif.message,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Star Column
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        notif.isStarred = !notif.isStarred;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Icon(
                        notif.isStarred ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 22,
                        color: notif.isStarred
                            ? const Color(0xFFF59E0B)
                            : YonwaColors.neutral400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
