import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final myId = authService.user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("zylo.pages"),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: myId == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: FirebaseDatabase.instance.ref('users').onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                Map<dynamic, dynamic> users = snapshot.data!.snapshot.value as Map;
                List<Map<String, dynamic>> userList = [];
                
                users.forEach((key, value) {
                  if (key != myId) {
                    userList.add({
                      'id': key,
                      'name': value['name'] ?? 'Unknown',
                      'photoURL': value['photoURL'] ?? '',
                    });
                  }
                });

                return ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final user = userList[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        backgroundImage: user['photoURL'] != '' ? NetworkImage(user['photoURL']) : null,
                        child: user['photoURL'] == '' ? const Icon(Icons.person, color: Colors.blue) : null,
                      ),
                      title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Tap to chat..."),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatRoomScreen(
                              targetId: user['id'],
                              targetName: user['name'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0284C7),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}