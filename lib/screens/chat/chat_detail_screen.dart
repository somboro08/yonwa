import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme/yonwa_theme.dart';
import 'messages_inbox_screen.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatContact contact;
  const ChatDetailScreen({super.key, required this.contact});
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _Msg {
  final String text;
  final bool isMe;
  final DateTime time;
  final bool read;
  _Msg({required this.text, required this.isMe, required this.time, this.read = false});
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  bool _isTyping = false;

  final List<_Msg> _msgs = [
    _Msg(text: 'Bonjour ! Je suis intéressé par vos services.', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 30)), read: true),
    _Msg(text: 'Bonjour, avec plaisir ! Comment puis-je vous aider ?', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 28))),
    _Msg(text: 'Je voudrais organiser une excursion à Ganvié pour 4 personnes.', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 25)), read: true),
    _Msg(text: 'Excellent choix ! Je propose une visite de 3h en pirogue avec guide bilingue. Le tarif est de 15 000 FCFA par personne.', isMe: false, time: DateTime.now().subtract(const Duration(minutes: 22))),
    _Msg(text: 'Parfait. Êtes-vous disponible ce weekend ?', isMe: true, time: DateTime.now().subtract(const Duration(minutes: 10)), read: true),
  ];

  void _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(_Msg(text: text, isMe: true, time: DateTime.now(), read: false));
      _isTyping = true;
    });
    _ctrl.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isTyping = false;
      _msgs.add(_Msg(text: 'Je suis disponible ce weekend ! Voulez-vous confirmer la réservation ?', isMe: false, time: DateTime.now()));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  String _fmt(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  void dispose() { _ctrl.dispose(); _scroll.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : const Color(0xFFF0EBE3),
      body: Column(
        children: [
          _buildHeader(isDark),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _msgs.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (_isTyping && i == _msgs.length) return _TypingBubble(avatar: widget.contact.avatar);
                final msg = _msgs[i];
                return _BubbleWidget(msg: msg, avatar: widget.contact.avatar, isDark: isDark, fmt: _fmt);
              },
            ),
          ),
          _buildInput(isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 6, left: 8, right: 16, bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context),
            color: isDark ? Colors.white : YonwaColors.neutral800),
          Stack(
            children: [
              CircleAvatar(radius: 22, backgroundImage: NetworkImage(widget.contact.avatar)),
              if (widget.contact.online) Positioned(bottom: 1, right: 1,
                child: Container(width: 11, height: 11, decoration: BoxDecoration(color: YonwaColors.success, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.contact.name, style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : YonwaColors.neutral900)),
                Text(widget.contact.online ? 'En ligne' : widget.contact.role, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: widget.contact.online ? YonwaColors.success : YonwaColors.neutral400)),
              ],
            ),
          ),
          _HdrIcon(Icons.call_rounded, isDark),
          const SizedBox(width: 4),
          _HdrIcon(Icons.videocam_rounded, isDark),
          const SizedBox(width: 4),
          _HdrIcon(Icons.more_vert_rounded, isDark),
        ],
      ),
    );
  }

  Widget _buildInput(bool isDark) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -3))],
      ),
      child: Row(
        children: [
          // Attach
          GestureDetector(
            onTap: () {},
            child: Container(width: 44, height: 44, decoration: BoxDecoration(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral100, shape: BoxShape.circle),
              child: Icon(Icons.attach_file_rounded, size: 20, color: isDark ? YonwaColors.neutral300 : YonwaColors.neutral500)),
          ),
          const SizedBox(width: 8),
          // Input pill
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              decoration: BoxDecoration(
                color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral100,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral200),
              ),
              child: Row(
                children: [
                  GestureDetector(onTap: () {}, child: Icon(Icons.sentiment_satisfied_rounded, size: 22, color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral400)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: isDark ? Colors.white : YonwaColors.neutral800),
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400),
                        border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
                        isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onSubmitted: (_) => _send(),
                      maxLines: null,
                    ),
                  ),
                  GestureDetector(onTap: () {}, child: Icon(Icons.camera_alt_rounded, size: 22, color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral400)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send / Mic
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 44, height: 44,
              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: const Icon(Icons.mic_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _HdrIcon extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  const _HdrIcon(this.icon, this.isDark);
  @override
  Widget build(BuildContext context) => Container(
    width: 38, height: 38,
    decoration: BoxDecoration(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral100, shape: BoxShape.circle),
    child: Icon(icon, size: 18, color: isDark ? YonwaColors.neutral300 : YonwaColors.neutral600),
  );
}

class _BubbleWidget extends StatelessWidget {
  final _Msg msg;
  final String avatar;
  final bool isDark;
  final String Function(DateTime) fmt;
  const _BubbleWidget({required this.msg, required this.avatar, required this.isDark, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMe) ...[
            CircleAvatar(radius: 15, backgroundImage: NetworkImage(avatar)),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.68),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: msg.isMe ? const LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                  color: msg.isMe ? null : (isDark ? YonwaColors.neutral700 : Colors.white),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(msg.isMe ? 18 : 4),
                    bottomRight: Radius.circular(msg.isMe ? 4 : 18),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: Text(msg.text, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: msg.isMe ? Colors.white : (isDark ? Colors.white : YonwaColors.neutral800), height: 1.5)),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(fmt(msg.time), style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400)),
                  if (msg.isMe) ...[
                    const SizedBox(width: 4),
                    Icon(msg.read ? Icons.done_all_rounded : Icons.done_rounded, size: 14, color: msg.read ? YonwaColors.info : YonwaColors.neutral400),
                  ],
                ],
              ),
            ],
          ),
          if (msg.isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  final String avatar;
  const _TypingBubble({required this.avatar});
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(); }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(radius: 15, backgroundImage: NetworkImage(widget.avatar)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? YonwaColors.neutral700 : Colors.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(18)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) {
              return AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) {
                  final phase = (_ctrl.value + i * 0.33) % 1.0;
                  final opacity = phase < 0.5 ? phase * 2 : (1 - phase) * 2;
                  return Container(margin: const EdgeInsets.symmetric(horizontal: 2), width: 7, height: 7,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: YonwaColors.primary500.withOpacity(0.3 + opacity * 0.7)));
                },
              );
            })),
          ),
        ],
      ),
    );
  }
}
