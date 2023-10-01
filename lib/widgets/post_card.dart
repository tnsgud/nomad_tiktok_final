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
    var titleDate = posts.first.createTime.toString().substring(0, 7);

    return StickyHeader(
      header: Container(
        padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
        color: Colors.white,
        child: Row(
          children: [
            Text(
              titleDate,
              style: context.displayMedium,
            ),
          ],
        ),
      ),
      content: SizedBox(
        height: posts.length * 105,
        child: Column(
          children: posts.map((post) {
            var index = posts.indexOf(post);

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < (posts.length - 1) ? Sizes.size10 : 0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                  color: Color(int.parse(post.color)),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${post.createTime.day}',
                          style: context.displayMedium,
                        ),
                        Text(
                          post.emoji,
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
                    Expanded(
                      child: Text(
                        post.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
