import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/constants/style.dart';
import 'package:final_project/main.dart';
import 'package:final_project/model/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final List<String> _emojiColor = [
    '0xFFF7CE88',
    '0xFFF7CE88',
    '0xFFF7CE88',
    '0xFFF7CE88',
    '0xFF6B78FE',
    '0xFFFF8574',
    '0xFFFF8574',
    '0xFFFF8574',
  ];
  final List<bool> _emojiSelect = List.filled(8, false);

  Widget _emojiCard({required String emoji, required int index}) {
    final colorCode = int.parse(_emojiColor[index]);
    final color = _emojiSelect[index] ? Color(colorCode) : Colors.white;

    return GestureDetector(
      onTap: () => _onEmojiCardTap(index: index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size3,
          horizontal: Sizes.size8,
        ),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(Sizes.size10),
        ),
        child: Text(
          emoji,
          style: context.bodyMedium,
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
    if (_controller.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('경고'),
          content: const Text('기분을 입력해주세요.'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            )
          ],
        ),
      );
      return;
    }

    if (_emojiSelect.where((e) => e).isEmpty) {
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('경고'),
          content: const Text('아이콘을 선택해주세요.'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            )
          ],
        ),
      );
      return;
    }

    var text = _controller.text;
    var emojiIndex = _emojiSelect.indexOf(_emojiSelect.firstWhere((e) => e));
    var emoji = _emoji[emojiIndex];
    var color = _emojiColor[emojiIndex];
    var post = Post(
      content: text,
      emoji: emoji,
      color: color,
      createTime: DateTime.now(),
    );

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
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: '지금 기분은 어떤가요?',
              border: OutlineInputBorder(),
            ),
          ),
          Gaps.v20,
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
          Gaps.v20,
          GestureDetector(
            onTap: _onAddPost,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  '기록하기',
                  style: context.displaySmall.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
