import 'package:final_project/constants/sizes.dart';
import 'package:final_project/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:final_project/main.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var posts = ref.watch(provider);

    if (posts.isEmpty) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.fromLTRB(
                  Sizes.size20,
                  Sizes.size20,
                  Sizes.size20,
                  0,
                ),
                child: PostCard(post: posts[index]),
              ),
              itemCount: posts.length,
            ),
          )
        ],
      ),
    );
  }
}
