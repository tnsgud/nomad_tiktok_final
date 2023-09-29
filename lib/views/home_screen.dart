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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) => PostCard(post: posts[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: posts.length,
          ),
        )
      ],
    );
  }
}
