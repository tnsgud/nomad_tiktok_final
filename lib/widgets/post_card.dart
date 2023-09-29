import 'package:final_project/main.dart';
import 'package:final_project/model/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  void _onDelete(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();

    ref.read(postProvider.notifier).remove(post);
  }

  void _showActionSheet(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('title'),
          message: const Text('message'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => _onDelete(context, ref),
              isDestructiveAction: true,
              child: const Text('삭제'),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('취소'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var diff = DateTime.now().difference(post.createTime);
    var day = diff.inDays;
    var time = Duration(seconds: diff.inSeconds);
    var lastTime = '$day일';

    if (day == 0) {
      lastTime = '${time.inHours}시간';
    }

    if (time.inHours == 0) {
      lastTime = '${time.inMinutes}분';
    }

    if (time.inMinutes < 10) {
      lastTime = '방금전';
    }

    return GestureDetector(
      onLongPress: () => _showActionSheet(context, ref),
      child: Row(
        children: [
          Text(post.content),
          Text(post.emoji),
          Text(lastTime),
        ],
      ),
    );
  }
}
