import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme/yonwa_theme.dart';
import 'chat_detail_screen.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/layout/app_shell.dart';
import '../../shared/widgets/floating_navbar.dart';

// ─── Data ────────────────────────────────────

class ChatContact {
  final String id, name, role, city, avatar, lastMsg;
  final String time;
  final int unread;
  final bool online;
  ChatContact({required this.id, required this.name, required this.role, required this.city, required this.avatar, required this.lastMsg, required this.time, required this.unread, required this.online});
}

final ChatContacts = [
  ChatContact(id: '1', name: 'Koffi Mensah', role: 'Guide • Ganvié', city: 'Cotonou', avatar: 'https://i.pravatar.cc/150?u=koffi', lastMsg: 'Je suis disponible ce weekend !', time: '09:32', unread: 2, online: true),
  ChatContact(id: '2', name: 'Amina Cissé', role: 'Artisane • Tisserande', city: 'Bohicon', avatar: 'https://i.pravatar.cc/150?u=amina', lastMsg: 'Voici des photos de mes créations 📸', time: 'Hier', unread: 0, online: true),
  ChatContact(id: '3', name: 'Moussa Aké', role: 'Guide • Parc du W', city: 'Natitingou', avatar: 'https://i.pravatar.cc/150?u=moussa', lastMsg: 'Le safari dure 3 jours environ', time: 'Lun', unread: 1, online: false),
  ChatContact(id: '4', name: 'Sika Adjovi', role: 'Artisane • Poterie', city: 'Abomey', avatar: 'https://i.pravatar.cc/150?u=sika', lastMsg: 'Merci pour votre commande ✨', time: 'Dim', unread: 0, online: false),
  ChatContact(id: '5', name: 'Lionel Gbèdo', role: 'Guide • Route des Esclaves', city: 'Ouidah', avatar: 'https://i.pravatar.cc/150?u=lionel', lastMsg: 'Réservation confirmée pour le 25 juin', time: 'Ven', unread: 0, online: true),
  ChatContact(id: '6', name: 'Binta Sow', role: 'Artisane • Bijoutière', city: 'Porto-Novo', avatar: 'https://i.pravatar.cc/150?u=binta', lastMsg: 'Vos boucles d\'oreilles sont prêtes !', time: 'Jeu', unread: 3, online: false),
];

// ─── Inbox Screen ────────────────────────────

class MessagesInboxScreen extends StatefulWidget {
  const MessagesInboxScreen({super.key});
  @override
  State<MessagesInboxScreen> createState() => _MessagesInboxScreenState();
}

class _MessagesInboxScreenState extends State<MessagesInboxScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); _search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = ChatContacts.where((c) => c.name.toLowerCase().contains(_query.toLowerCase())).toList();

    final body = Column(
        children: [
          _Header(isDark: isDark, tab: _tab),
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? YonwaColors.neutral800 : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, size: 18, color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _search,
                      onChanged: (v) => setState(() => _query = v),
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: isDark ? Colors.white : YonwaColors.neutral800),
                      decoration: InputDecoration(
                        hintText: 'Chercher un contact...',
                        hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400),
                        border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
                        isDense: true, contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Online strip
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: ChatContacts.where((c) => c.online).length,
              itemBuilder: (_, i) {
                final c = ChatContacts.where((c) => c.online).toList()[i];
                return _OnlineAvatar(contact: c);
              },
            ),
          ),
          const SizedBox(height: 8),
          // Conversations
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: filtered.length,
              itemBuilder: (_, i) => _ConversationTile(
                contact: filtered[i],
                isDark: isDark,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(contact: filtered[i]))),
              ),
            ),
          ),
        ],
      );

    return ResponsiveLayout(
      mobile: Scaffold(
        backgroundColor: isDark ? YonwaColors.neutral900 : const Color(0xFFF8F4EF),
        drawer: const Drawer(),
        floatingActionButton: Container(
        width: 52, height: 52,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: IconButton(icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 22), onPressed: () {}),
      ),
        body: SafeArea(
          child: Builder(
            builder: (context) => Column(
              children: [
                FloatingNavbar(onMenuPressed: () => Scaffold.of(context).openDrawer()),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ),
      desktop: AppShell(child: Scaffold(
        backgroundColor: isDark ? YonwaColors.neutral900 : const Color(0xFFF8F4EF),
        floatingActionButton: Container(
        width: 52, height: 52,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: IconButton(icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 22), onPressed: () {}),
      ),
        body: body)),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isDark;
  final TabController tab;
  const _Header({required this.isDark, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 20, right: 20, bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Messages', style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : YonwaColors.neutral900)),
              const Spacer(),
              _IconBtn(icon: Icons.search_rounded, onTap: () {}),
              const SizedBox(width: 8),
              _IconBtn(icon: Icons.tune_rounded, onTap: () {}),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TabBar(
              controller: tab,
              indicator: BoxDecoration(
                gradient: const LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary]),
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
              dividerColor: Colors.transparent,
              tabs: const [Tab(text: 'Tous'), Tab(text: 'Non lus')],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(color: YonwaColors.neutral100, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: YonwaColors.neutral600),
      ),
    );
  }
}

class _OnlineAvatar extends StatelessWidget {
  final ChatContact contact;
  const _OnlineAvatar({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary]),
                ),
                child: CircleAvatar(radius: 28, backgroundImage: NetworkImage(contact.avatar)),
              ),
              Positioned(
                bottom: 2, right: 2,
                child: Container(width: 12, height: 12,
                  decoration: BoxDecoration(color: YonwaColors.success, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(contact.name.split(' ')[0], style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ChatContact contact;
  final bool isDark;
  final VoidCallback onTap;
  const _ConversationTile({required this.contact, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: contact.unread > 0 ? (isDark ? YonwaColors.neutral800 : Colors.white) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: contact.unread > 0 ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))] : null,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(radius: 26, backgroundImage: NetworkImage(contact.avatar)),
                if (contact.online) Positioned(
                  bottom: 1, right: 1,
                  child: Container(width: 11, height: 11,
                    decoration: BoxDecoration(color: YonwaColors.success, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(contact.name, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: contact.unread > 0 ? FontWeight.bold : FontWeight.w500, color: isDark ? Colors.white : YonwaColors.neutral900))),
                      Text(contact.time, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: contact.unread > 0 ? YonwaColors.primary500 : YonwaColors.neutral400)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(contact.role, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: YonwaColors.primary500, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(child: Text(contact.lastMsg, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: contact.unread > 0 ? (isDark ? YonwaColors.neutral200 : YonwaColors.neutral700) : YonwaColors.neutral400, fontWeight: contact.unread > 0 ? FontWeight.w500 : FontWeight.normal))),
                      if (contact.unread > 0) Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: const BoxDecoration(color: YonwaColors.primary500, shape: BoxShape.circle),
                        child: Text('${contact.unread}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
