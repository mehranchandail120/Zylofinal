import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../services/auth_service.dart';

class ChatRoomScreen extends StatefulWidget {
  final String targetId;
  final String targetName;

  const ChatRoomScreen({super.key, required this.targetId, required this.targetName});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _msgController = TextEditingController();
  late String chatId;
  late String myId;
  late String myName;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    myId = authService.user!.uid;
    myName = authService.userName ?? "User";
    // Generate unique chat ID consistent for both users
    chatId = myId.compareTo(widget.targetId) < 0 
        ? "${myId}_${widget.targetId}" 
        : "${widget.targetId}_$myId";
  }

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;

    FirebaseDatabase.instance.ref('messages/$chatId').push().set({
      'senderId': myId,
      'user': myName,
      'text': _msgController.text.trim(),
      'type': 'text',
      'status': 'sent',
      'timestamp': ServerValue.timestamp,
    });

    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.targetName, style: const TextStyle(fontSize: 16)),
            const Text("Online", style: TextStyle(fontSize: 10, color: Colors.green)),
          ],
        ),
        actions: [
          // ZegoCloud Voice Call Button
          ZegoSendCallInvitationButton(
            isVideoCall: false,
            resourceID: "zego_data", // For offline call notification
            invitees: [
              ZegoUIKitUser(id: widget.targetId, name: widget.targetName),
            ],
            iconSize: const Size(40, 40),
            buttonSize: const Size(50, 50),
          ),
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance.ref('messages/$chatId').orderByChild('timestamp').onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                  return const Center(child: Text("Say hi! 👋", style: TextStyle(color: Colors.grey)));
                }

                Map<dynamic, dynamic> messagesMap = snapshot.data!.snapshot.value as Map;
                List<Map<String, dynamic>> messages = [];
                messagesMap.forEach((key, value) {
                  messages.add(Map<String, dynamic>.from(value));
                });
                
                messages.sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == myId;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          color: isMe ? const Color(0xFF0284C7) : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
                          ],
                        ),
                        child: Text(
                          msg['text'] ?? '',
                          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Input Area
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Color(0xFF0284C7)),
                  onPressed: () {
                    // Open Attachments (Removed games as requested)
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: "Message...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF0284C7),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}