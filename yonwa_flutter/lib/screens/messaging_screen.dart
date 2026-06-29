import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class MessagingScreen extends StatelessWidget {
  final Function(String) navigate;
  const MessagingScreen({super.key, required this.navigate});

  @override
  Widget build(BuildContext context) {
    final convos = MockData.conversations;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 14),
            color: AppColors.card,
            child: Row(
              children: const [
                Text('Messages', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Expanded(
            child: ListView.separated(
              itemCount: convos.length,
              separatorBuilder: (_, __) => const Divider(indent: 76, height: 1, color: AppColors.border),
              itemBuilder: (_, i) {
                final c = convos[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  onTap: () => navigate('chat'),
                  leading: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      c.avatar.isNotEmpty
                          ? ClipOval(child: SizedBox(width: 50, height: 50, child: NetworkImg(url: c.avatar)))
                          : Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color(0x1AC4622D),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(child: Text('Y', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 18))),
                            ),
                      if (c.unread > 0)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: Center(child: Text('${c.unread}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))),
                          ),
                        ),
                    ],
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(c.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                      Text(c.time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                  subtitle: Text(
                    c.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: c.unread > 0 ? AppColors.textDark : AppColors.textMuted,
                      fontWeight: c.unread > 0 ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
