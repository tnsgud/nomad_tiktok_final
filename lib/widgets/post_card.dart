import 'package:final_project/constants/sizes.dart';
import 'package:final_project/main.dart';
import 'package:final_project/model/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:final_project/constants/style.dart';

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
          title: Text(
            '기록을 삭제하시겠습니까?',
            style: context.bodyMedium,
          ),
          message: Text(
            '삭제된 기록은 복구가 불가능합니다.',
            style: context.bodySmall,
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => _onDelete(context, ref),
              isDestructiveAction: true,
              child: Text(
                '삭제',
                style: context.displaySmall,
              ),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              '취소',
              style: context.displaySmall,
            ),
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
    var lastTime = '$day일 전';

    if (day == 0) {
      lastTime = '${time.inHours}시간 전';
    }

    if (time.inHours == 0) {
      lastTime = '${time.inMinutes}분 전';
    }

    if (time.inMinutes < 10) {
      lastTime = '방금전';
    }

    return GestureDetector(
      onLongPress: () => _showActionSheet(context, ref),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(int.parse(post.color)),
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(Sizes.size20 * -1, Sizes.size20 * -1),
                    child: Container(
                      width: Sizes.size52,
                      height: Sizes.size52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          post.emoji,
                          style: context.displayMedium,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      post.content,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: context.displaySmall.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            lastTime,
            style: context.bodySmall.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
