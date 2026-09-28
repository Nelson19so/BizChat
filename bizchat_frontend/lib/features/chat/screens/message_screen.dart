import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final int roomId;
  const MessageScreen({super.key, required this.roomId});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Text Message Screen"),
      ),
    );
  }
}
