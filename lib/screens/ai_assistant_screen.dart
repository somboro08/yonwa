import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/yonwa_theme.dart';

// ─── Data Models ─────────────────────────────

enum _MsgType { user, ai }

class _ChatMessage {
  final _MsgType type;
  final String text;
  final List<_ResultCard>? cards;
  _ChatMessage({required this.type, required this.text, this.cards});
}

class _ResultCard {
  final String image;
  final String title;
  final String subtitle;
  final String tag;
  final double rating;
  _ResultCard({required this.image, required this.title, required this.subtitle, required this.tag, required this.rating});
}

// ─── Mock AI responses ──────────────────────

final _mockResponses = <String, _ChatMessage>{
  'default': _ChatMessage(
    type: _MsgType.ai,
    text: 'Voici quelques recommandations pour vous au Bénin ✨',
    cards: [
      _ResultCard(image: 'assets/images/hero1.png', title: 'Ganvié', subtitle: 'La Venise d\'Afrique', tag: 'Destination', rating: 4.9),
      _ResultCard(image: 'assets/images/hero4.png', title: 'Plages de Ouidah', subtitle: 'Paradis tropical', tag: 'Plage', rating: 4.7),
      _ResultCard(image: 'assets/images/hero5.png', title: 'Abomey', subtitle: 'Palais Royaux UNESCO', tag: 'Patrimoine', rating: 4.8),
    ],
  ),
  'guide': _ChatMessage(
    type: _MsgType.ai,
    text: 'Voici les meilleurs guides touristiques disponibles 🧭',
    cards: [
      _ResultCard(image: 'assets/images/hero2.png', title: 'Guide Koffi', subtitle: 'Spécialiste Ganvié • 5 ans d\'expérience', tag: 'Guide', rating: 4.9),
      _ResultCard(image: 'assets/images/hero7.png', title: 'Guide Moussa', subtitle: 'Expert lac Nokoué', tag: 'Guide', rating: 4.6),
    ],
  ),
  'artisan': _ChatMessage(
    type: _MsgType.ai,
    text: 'Découvrez ces artisans exceptionnels du Bénin 🎨',
    cards: [
      _ResultCard(image: 'assets/images/hero2.png', title: 'Amina Tissage', subtitle: 'Tisserande • Bohicon', tag: 'Artisanat', rating: 4.8),
      _ResultCard(image: 'assets/images/hero6.png', title: 'Kofi Poterie', subtitle: 'Potier traditionnel • Abomey', tag: 'Artisanat', rating: 4.7),
    ],
  ),
  'budget': _ChatMessage(
    type: _MsgType.ai,
    text: 'Pour votre budget, voici un itinéraire optimisé sur 3 jours 💰',
    cards: [
      _ResultCard(image: 'assets/images/hero8.jpg', title: 'Marché Dantokpa', subtitle: 'Gratuit • Cotonou', tag: 'Économique', rating: 4.5),
      _ResultCard(image: 'assets/images/hero14.jpg', title: 'Cascades Tanougou', subtitle: '2 000 FCFA/pers', tag: 'Nature', rating: 4.9),
      _ResultCard(image: 'assets/images/hero12.jpg', title: 'Route des Esclaves', subtitle: '1 500 FCFA/pers', tag: 'Histoire', rating: 4.7),
    ],
  ),
};

_ChatMessage _getAiResponse(String text) {
  final lower = text.toLowerCase();
  if (lower.contains('guide')) return _mockResponses['guide']!;
  if (lower.contains('artisan') || lower.contains('tisser') || lower.contains('craft')) return _mockResponses['artisan']!;
  if (lower.contains('budget') || lower.contains('fcfa') || lower.contains('prix') || lower.contains('pas cher')) return _mockResponses['budget']!;
  return _mockResponses['default']!;
}

// ─── Screen ─────────────────────────────────

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _showWelcome = true;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  final _suggestions = [
    '🗺️ Meilleurs endroits à visiter',
    '👨‍🦯 Trouver un guide local',
    '🎨 Artisans à Cotonou',
    '💰 Voyage avec petit budget',
    '🌅 Ganvié au lever du soleil',
    '🍽️ Cuisine traditionnelle',
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _send(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _showWelcome = false;
      _messages.add(_ChatMessage(type: _MsgType.user, text: text));
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final response = _getAiResponse(text);
    setState(() {
      _isTyping = false;
      _messages.add(response);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : const Color(0xFFF8F4EF),
      body: Column(
        children: [
          _buildHeader(isDark),
          Expanded(
            child: _showWelcome ? _buildWelcome(isDark) : _buildChat(isDark),
          ),
          if (_isTyping) _buildTypingBubble(isDark),
          _buildInputBar(isDark),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────
  Widget _buildHeader(bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0A00), Color(0xFF3D1A08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          // AI Avatar pulsant
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Transform.scale(
              scale: _pulseAnim.value,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [YonwaColors.primary500, YonwaColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: YonwaColors.primary500.withOpacity(0.5), blurRadius: 16, spreadRadius: 2),
                  ],
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Yonwa IA', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('IA', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 7, height: 7, decoration: const BoxDecoration(color: YonwaColors.success, shape: BoxShape.circle)),
                    const SizedBox(width: 5),
                    const Text('Expert tourisme Bénin • En ligne', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() { _messages.clear(); _showWelcome = true; }),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ── Welcome Screen ───────────────────────────
  Widget _buildWelcome(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Illustration
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF3D1A08), YonwaColors.primary500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [BoxShadow(color: YonwaColors.primary500.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)],
            ),
            child: const Icon(Icons.travel_explore_rounded, size: 54, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Bonjour, je suis votre\nexpert touristique IA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A0A00), height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Posez-moi n\'importe quelle question sur le Bénin. Je connais les meilleures destinations, guides, artisans et expériences culturelles !',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500, height: 1.6),
          ),
          const SizedBox(height: 28),
          // Suggestions grid
          Text(
            'Suggestions rapides',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600,
              color: isDark ? YonwaColors.neutral300 : YonwaColors.neutral600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _suggestions.map((s) => _SuggestionChip(text: s, onTap: () => _send(s))).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Chat list ───────────────────────────────
  Widget _buildChat(bool isDark) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (_, i) {
        final msg = _messages[i];
        return msg.type == _MsgType.user
            ? _UserBubble(text: msg.text)
            : _AIBubble(message: msg, isDark: isDark);
      },
    );
  }

  // ── Typing indicator ─────────────────────────
  Widget _buildTypingBubble(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary]),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? YonwaColors.neutral800 : Colors.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _DotPulse(delay: i * 200)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Input bar ───────────────────────────────
  Widget _buildInputBar(bool isDark) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        border: Border(top: BorderSide(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral100,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral200),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: isDark ? Colors.white : YonwaColors.neutral800),
                decoration: InputDecoration(
                  hintText: 'Posez votre question...',
                  hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onSubmitted: _send,
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _send(_controller.text),
            child: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
                boxShadow: [BoxShadow(color: YonwaColors.primary500.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────

class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 60),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(4), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: Text(text, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.white, height: 1.5)),
      ),
    );
  }
}

class _AIBubble extends StatelessWidget {
  final _ChatMessage message;
  final bool isDark;
  const _AIBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 34, height: 34,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFF3D1A08), YonwaColors.primary500]),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? YonwaColors.neutral800 : Colors.white,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: isDark ? Colors.white : YonwaColors.neutral800, height: 1.5),
                  ),
                ),
              ),
            ],
          ),
          if (message.cards != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 42),
                itemCount: message.cards!.length,
                itemBuilder: (_, i) => _ResultCardWidget(card: message.cards![i], isDark: isDark),
              ),
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _ResultCardWidget extends StatelessWidget {
  final _ResultCard card;
  final bool isDark;
  const _ResultCardWidget({required this.card, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(card.image, height: 110, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 110, color: YonwaColors.primary200)),
              Positioned(
                top: 8, left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(card.tag, style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(card.title, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : YonwaColors.neutral800), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(card.subtitle, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                    const SizedBox(width: 3),
                    Text('${card.rating}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _SuggestionChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: YonwaColors.primary200),
          boxShadow: [BoxShadow(color: YonwaColors.primary500.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Text(text, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: YonwaColors.primary600)),
      ),
    );
  }
}

class _DotPulse extends StatefulWidget {
  final int delay;
  const _DotPulse({required this.delay});

  @override
  State<_DotPulse> createState() => _DotPulseState();
}

class _DotPulseState extends State<_DotPulse> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Opacity(
          opacity: _anim.value,
          child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: YonwaColors.primary500, shape: BoxShape.circle)),
        ),
      ),
    );
  }
}
