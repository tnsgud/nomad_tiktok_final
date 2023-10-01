import 'dart:math' as math;
import 'package:final_project/constants/gaps.dart';
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
    '😭',
    '🤬',
  ];
  final List<String> _emojiColor = [
    '0xFFFFCF87',
    '0xFF87BEFF',
    '0xFFFFAB87',
  ];
  double sliderValue = 0.0;
  int emojiIndex = 0;
  final List<double> emojiTurns = [0.25, 0, -0.25];

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

    var text = _controller.text;
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

    setState(() {});
  }

  void _onSliderChange(double newValue) {
    setState(() {
      sliderValue = newValue;
      emojiIndex = sliderValue.ceil();
    });
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: '지금 기분은 어떤가요?',
              border: OutlineInputBorder(),
            ),
          ),
          Gaps.v40,
          Stack(
            children: [
              AnimatedRotation(
                turns: emojiTurns[emojiIndex],
                duration: const Duration(milliseconds: 200),
                child: Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(
                      child: Stack(
                        children: [
                          Transform.translate(
                            offset: const Offset(-50, 0),
                            child: Transform.rotate(
                              angle: -90 * math.pi / 180,
                              child: Text(
                                _emoji[0],
                                style: context.displayLarge,
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, -50),
                            child: Text(
                              _emoji[1],
                              style: context.displayLarge,
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(50, 0),
                            child: Transform.rotate(
                              angle: 90 * math.pi / 180,
                              child: Text(
                                _emoji[2],
                                style: context.displayLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, 20),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.white,
                  child: Slider(
                    min: 0,
                    max: 2,
                    activeColor: Colors.black,
                    divisions: 2,
                    value: sliderValue,
                    label: _emoji[emojiIndex],
                    onChanged: _onSliderChange,
                  ),
                ),
              ),
            ],
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
