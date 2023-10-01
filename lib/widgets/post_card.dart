import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/model/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:final_project/constants/style.dart';
import 'package:sticky_headers/sticky_headers.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.posts});

  final List<Post> posts;
  // final Post post;

  // void _onDelete(BuildContext context, WidgetRef ref) {
  //   Navigator.of(context).pop();

  //   ref.read(postProvider.notifier).remove(post);
  // }

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
              onPressed: () {},
              // onPressed: () => _onDelete(context, ref),
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
    // var diff = DateTime.now().difference(post.createTime);
    // var day = diff.inDays;
    // var time = Duration(seconds: diff.inSeconds);
    // var lastTime = '$day일 전';

    // if (day == 0) {
    //   lastTime = '${time.inHours}시간 전';
    // }

    // if (time.inHours == 0) {
    //   lastTime = '${time.inMinutes}분 전';
    // }

    // if (time.inMinutes < 10) {
    //   lastTime = '방금전';
    // }

    var titleDate = posts.first.createTime.toString().substring(0, 7);

    return StickyHeader(
      header: Container(
        padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
        color: Colors.white,
        child: Row(
          children: [
            Text(titleDate),
            Gaps.h10,
            const Expanded(
              child: Divider(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      content: SizedBox(
        height: posts.length * 105,
        child: ListView.separated(
          itemCount: posts.length,
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
              color: Color(int.parse(posts[index].color)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${posts[index].createTime.day}',
                      style: context.displayMedium,
                    ),
                    Text(
                      posts[index].emoji,
                      style: context.displayMedium,
                    )
                  ],
                ),
                Gaps.h10,
                Container(
                  width: 1,
                  height: 92,
                  color: Colors.black,
                ),
                Gaps.h10,
                Expanded(child: Text(posts[index].content)),
              ],
            ),
          ),
          separatorBuilder: (context, index) => Gaps.v20,
        ),
      ),
    );

    // return GestureDetector(
    //   onLongPress: () => _showActionSheet(context, ref),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     children: [
    //       Container(
    //         decoration: BoxDecoration(
    //           color: Color(int.parse(post.color)),
    //           border: Border.all(color: Colors.black),
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         child: IntrinsicHeight(
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               Transform.translate(
    //                 offset: const Offset(Sizes.size20 * -1, Sizes.size20 * -1),
    //                 child: Container(
    //                   width: Sizes.size52,
    //                   height: Sizes.size52,
    //                   decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     border: Border.all(color: Colors.black),
    //                     borderRadius: BorderRadius.circular(50),
    //                   ),
    //                   child: Center(
    //                     child: Text(
    //                       post.emoji,
    //                       style: context.displayMedium,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Expanded(
    //                 child: Text(
    //                   post.content,
    //                   maxLines: 5,
    //                   overflow: TextOverflow.ellipsis,
    //                   style: context.displaySmall.copyWith(color: Colors.white),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Text(
    //         lastTime,
    //         style: context.bodySmall.copyWith(
    //           color: Colors.grey,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
