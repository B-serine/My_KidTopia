import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('messages') ?? '[]';
    final list = (jsonDecode(raw) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    setState(() {
      _messages = list;
    });
  }

  Future<void> _clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('messages');
    setState(() => _messages = []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _messages.isEmpty ? null : _clearMessages,
          ),
        ],
      ),
      body: _messages.isEmpty
          ? const Center(child: Text('No messages yet'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final m = _messages[i];
                final title = m['title'] ?? 'Kidtopia';
                final body = m['body'] ?? '';
                final data = m['data'] ?? {};
                final ts = m['timestamp'] ?? '';
                return ListTile(
                  title: Text(title),
                  subtitle: Text(body),
                  trailing: Text(ts.toString().split('T').first),
                  onTap: () {
                    final screen = (data is Map && data['screen'] is String)
                        ? data['screen'] as String
                        : null;
                    if (screen != null) {
                      Navigator.pushNamed(context, screen);
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(title),
                          content: Text(body),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
