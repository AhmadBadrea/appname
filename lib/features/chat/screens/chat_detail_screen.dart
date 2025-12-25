// lib/screens/chat_detail_screen.dart

import 'dart:async';
import 'package:appname/data/models/chat_model.dart';
import 'package:appname/data/models/message_model.dart';
import 'package:flutter/material.dart';

// --- 1. تحويله إلى StatefulWidget ---
class ChatDetailScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  // --- 2. إدارة الحالة محليًا ---
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    // نقوم بإنشاء نسخة قابلة للتعديل من الرسائل الوهمية عند بدء الشاشة
    // ونعكسها لتناسب `reverse: true` في ListView
    _messages.addAll(mockMessages.reversed);
  }

  @override
  void dispose() {
    // التخلص من الـ controller لمنع تسرب الذاكرة
    _textController.dispose();
    super.dispose();
  }

  // --- 3. منطق إرسال الرسالة ---
  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isEmpty) return; // لا ترسل رسائل فارغة

    // إنشاء رسالة جديدة
    final message = Message(
      text: text,
      time: "${DateTime.now().hour}:${DateTime.now().minute}", // وقت حقيقي
      isMe: true,
    );

    // `setState` يخبر فلاتر بإعادة بناء الواجهة
    setState(() {
      // `insert(0, ...)` هو الأسلوب الأمثل مع `reverse: true`
      _messages.insert(0, message);
      _textController.clear();
    });

    // محاكاة رد من الطرف الآخر بعد ثانية
    _simulateReply();
  }

  // --- 4. منطق محاكاة الرد ---
  void _simulateReply() {
    Future.delayed(const Duration(seconds: 1), () {
      final reply = Message(
        text: "تمام، وصلتني رسالتك.",
        time: "${DateTime.now().hour}:${DateTime.now().minute}",
        isMe: false,
      );
      // إعادة بناء الواجهة مرة أخرى لعرض الرد
      setState(() {
        _messages.insert(0, reply);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                widget.chat.imageUrl,
              ), // استخدام widget. للوصول للمتغير
            ),
            const SizedBox(width: 12),
            Text(widget.chat.name),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.call_outlined), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              // استخدام قائمة الرسائل المحلية
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // الوصول للرسالة مباشرة من القائمة المحلية
                final message = _messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),
          // تمرير الـ controller ودالة الإرسال إلى ويدجت الإدخال
          _TextInputArea(textController: _textController, onSend: _sendMessage),
        ],
      ),
    );
  }
}

// --- ويدجت فقاعة الرسالة (الكود الكامل) ---
class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // تحديد هل الرسالة من المرسل (isMe) لتحديد التصميم
    final bool isMe = message.isMe;

    return Row(
      // 1. محاذاة الفقاعة يمينًا (لرسائلك) أو يسارًا (لرسائله)
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          // 2. تحديد أقصى عرض للفقاعة حتى لا تملأ الشاشة
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            // 3. تحديد لون الفقاعة بناءً على المرسل
            color: isMe ? theme.colorScheme.primary : Colors.grey.shade200,

            // 4. هذا هو الجزء الأهم: جعل الزوايا دائرية بشكل مميز
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe
                  ? const Radius.circular(16)
                  : Radius.zero, // زاوية حادة إذا كانت الرسالة من الطرف الآخر
              bottomRight: isMe
                  ? Radius.zero
                  : const Radius.circular(
                      16,
                    ), // زاوية حادة إذا كانت الرسالة منك
            ),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              // 5. تحديد لون النص ليكون واضحًا فوق لون الخلفية
              color: isMe ? Colors.white : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }
}

// --- 5. تعديل ويدجت الإدخال ليصبح تفاعليًا ---
class _TextInputArea extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSend;

  const _TextInputArea({required this.textController, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
          Expanded(
            child: TextField(
              controller: textController, // ربط الـ controller
              decoration: InputDecoration(
                hintText: "اكتب رسالة...",
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => onSend(), // للسماح بالإرسال من الكيبورد
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: theme.primaryColor),
            onPressed: onSend, // ربط دالة الإرسال بالزر
          ),
        ],
      ),
    );
  }
}
