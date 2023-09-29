import 'package:final_project/main.dart';
import 'package:final_project/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  late TextEditingController _controller;
  final List<String> _emoji = [
    '😆',
    '😍',
    '😊',
    '🥳',
    '😭',
    '🤬',
    '🫠',
    '🤮',
  ];
  final List<bool> _emojiSelect = List.filled(8, false);

  Widget _emojiCard({required String emoji, required int index}) {
    return GestureDetector(
      onTap: () => _onEmojiCardTap(index: index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        decoration: BoxDecoration(
          color: _emojiSelect[index] ? Colors.amber : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  void _onEmojiCardTap({required int index}) {
    if (_emojiSelect[index]) {
      setState(() {
        _emojiSelect[index] = false;
      });

      return;
    }

    for (var i = 0; i < _emojiSelect.length; i++) {
      _emojiSelect[i] = false;
    }

    setState(() {
      _emojiSelect[index] = true;
    });
  }

  void _onAddPost() {
    var text = _controller.text;
    var emojiIndex = _emojiSelect.indexOf(_emojiSelect.firstWhere((e) => e));
    var emoji = _emoji[emojiIndex];
    var post = Post(content: text, emoji: emoji, createTime: DateTime.now());

    if (text.isEmpty) return;

    ref.read(postProvider.notifier).add(post);

    _controller.text = '';
    for (var i = 0; i < _emojiSelect.length; i++) {
      _emojiSelect[i] = false;
    }

    setState(() {});
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: '지금 기분은 어떤가요?',
            border: OutlineInputBorder(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _emoji
              .map(
                (e) => _emojiCard(
                  emoji: e,
                  index: _emoji.indexOf(e),
                ),
              )
              .toList(),
        ),
        GestureDetector(
          onTap: _onAddPost,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text('기록하기'),
            ),
          ),
        )
      ],
    );
  }
}
