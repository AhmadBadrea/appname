// lib/shared_widgets/chat_list_item_widget.dart

import 'package:appname/core/routing/app_router.dart';
import 'package:appname/data/models/chat_model.dart';
import 'package:flutter/material.dart';

/// ويدجت مشترك يعرض عنصرًا واحدًا في قائمة المحادثات.
/// تم تحديثه ليعتمد بالكامل على الثيم المركزي والتوجيه المسمى.
class ChatListItemWidget extends StatelessWidget {
  final Chat chat;
  const ChatListItemWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    // 1. جلب الثيم لسهولة الوصول
    final theme = Theme.of(context);

    return ListTile(
      onTap: () {
        // --- 2. استخدام التوجيه المركزي الاحترافي ---
        Navigator.pushNamed(
          context,
          AppRouter.chatDetail,
          arguments: chat, // تمرير كائن المحادثة بالكامل
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(chat.imageUrl),
      ),

      // --- 3. استخدام أنماط النصوص من الثيم ---
      title: Text(chat.name, style: theme.textTheme.titleMedium),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall,
      ),
      
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat.time,
            // --- 4. استخدام ألوان من الثيم ---
            style: theme.textTheme.bodySmall?.copyWith(
              color: chat.unreadCount > 0
                  ? theme.primaryColor // لون مميز للرسائل الجديدة
                  : theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 4),
          
          // استخدام `AnimatedOpacity` لإظهار وإخفاء الشارة بسلاسة
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: chat.unreadCount > 0 ? 1.0 : 0.0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.primaryColor, // <-- استخدام لون الثيم
                shape: BoxShape.circle,
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
