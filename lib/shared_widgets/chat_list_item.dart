// lib/widgets/chat_list_item.dart

import 'package:appname/core/theme/app_colors.dart';
import 'package:appname/features/chat/screens/chat_detail_screen.dart';
import 'package:flutter/material.dart';
import '../data/models/chat_model.dart';

class ChatListItem extends StatelessWidget {
  final Chat chat;

  const ChatListItem({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(chat.imageUrl),
      ),
      title: Text(
        chat.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.textLight),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat.time,
            style: TextStyle(
              fontSize: 12,
              color: chat.unreadCount > 0
                  ? AppColors.primary
                  : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          if (chat.unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          else
            const SizedBox(height: 18),
        ],
      ),
      onTap: () {
        // --- 2. تغيير منطق الضغط هنا ---
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatDetailScreen(chat: chat), // <-- 3. تمرير بيانات المحادثة
          ),
        );
      },
    );
  }
}
