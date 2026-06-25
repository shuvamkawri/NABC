import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../utils/session.dart';
import '../services/chat_service.dart';

/// Support chat between the logged-in member and NABC admin.
/// Sends via REST and polls every few seconds for replies.
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _scroll = ScrollController();
  final _input = TextEditingController();
  final List<ChatMessage> _messages = [];
  int _lastId = 0;
  Timer? _timer;
  bool _loading = true;
  bool _sending = false;
  String? _error;

  String get _phone => Session.current?.phone ?? '';

  @override
  void initState() {
    super.initState();
    _load(initial: true);
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  Future<void> _load({bool initial = false}) async {
    if (_phone.isEmpty) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Please log in to chat with support.';
        });
      }
      return;
    }
    try {
      final msgs = await ChatService.fetch(_phone, since: _lastId);
      if (!mounted) return;
      if (msgs.isNotEmpty) {
        setState(() {
          _messages.addAll(msgs);
          _lastId = _messages.last.id;
          _loading = false;
          _error = null;
        });
        _scrollToBottom();
      } else if (initial) {
        setState(() => _loading = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (_messages.isEmpty) _error = 'Could not load chat. Pull to retry.';
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _phone.isEmpty || _sending) return;
    setState(() => _sending = true);
    _input.clear();
    try {
      await ChatService.send(_phone, text, name: Session.current?.fullName);
      await _load();
    } catch (e) {
      if (mounted) {
        _input.text = text;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not send message. Try again.'),
          backgroundColor: AppColors.accentRed,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Messages'),
            Text('NABC Support',
                style: TextStyle(
                    fontSize: context.sp(11),
                    color: Colors.white70,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody(context)),
          _buildComposer(context),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _messages.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _load(initial: true),
        child: ListView(
          children: [
            SizedBox(height: context.hp(30)),
            Center(
              child: Text(_error!,
                  style: TextStyle(color: context.textSecondary)),
            ),
          ],
        ),
      );
    }
    if (_messages.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: context.hp(28)),
          Icon(Icons.support_agent_rounded,
              size: 56, color: AppColors.primaryBlue.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Center(
            child: Text('Start the conversation with NABC Support',
                style: TextStyle(color: context.textSecondary)),
          ),
        ],
      );
    }
    return ListView.builder(
      controller: _scroll,
      padding: EdgeInsets.all(context.pagePad),
      itemCount: _messages.length,
      itemBuilder: (_, i) => _bubble(context, _messages[i]),
    );
  }

  Widget _bubble(BuildContext context, ChatMessage m) {
    final isUser = m.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: context.wp(75)),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(m.name?.isNotEmpty == true ? m.name! : 'NABC Support',
                    style: TextStyle(
                        fontSize: context.sp(10),
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue)),
              ),
            Text(m.message,
                style: TextStyle(
                    fontSize: context.sp(13),
                    height: 1.35,
                    color: isUser ? Colors.white : context.textPrimary)),
            const SizedBox(height: 3),
            Text(_time(m.createdAt),
                style: TextStyle(
                    fontSize: context.sp(9),
                    color: isUser ? Colors.white70 : context.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    final disabled = _phone.isEmpty;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _input,
                enabled: !disabled,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText:
                      disabled ? 'Log in to chat' : 'Type a message…',
                  filled: true,
                  fillColor: const Color(0xFFF2F5F9),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Material(
              color: disabled ? Colors.grey : AppColors.primaryBlue,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: disabled ? null : _send,
                child: Padding(
                  padding: const EdgeInsets.all(11),
                  child: _sending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _time(String iso) {
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ap = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ap';
  }
}