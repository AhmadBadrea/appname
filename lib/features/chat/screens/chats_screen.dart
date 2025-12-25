// lib/screens/chats_screen.dart

import 'package:appname/data/models/chat_model.dart';
import 'package:appname/shared_widgets/chat_list_item.dart';
import 'package:flutter/material.dart'; 

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Chats"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mockChats.length, // استخدام القائمة مباشرة
        itemBuilder: (context, index) {
          final chat = mockChats[index];
          return ChatListItem(chat: chat);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
