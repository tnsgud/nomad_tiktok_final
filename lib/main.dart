import 'package:final_project/firebase_options.dart';
import 'package:final_project/model/post.dart';
import 'package:final_project/view_model/post_view_mode.dart';
import 'package:final_project/views/home_screen.dart';
import 'package:final_project/views/post_screen.dart';
import 'package:final_project/views/sign_in_screen.dart';
import 'package:final_project/views/sign_up_screen.dart';
import 'package:final_project/widgets/custom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/',
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          key: state.pageKey,
          body: SafeArea(child: child),
          bottomNavigationBar: const CustomNavigation(),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/post',
          builder: (context, state) => const PostScreen(),
        )
      ],
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    )
  ],
);

final postProvider = StateNotifierProvider<PostViewModel, List<Post>>(
  (ref) {
    var viewModel = PostViewModel([]);

    viewModel.getData();

    return viewModel;
  },
);

final provider = Provider<List<Post>>((ref) {
  var posts = ref.watch(postProvider);

  return posts;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'final-project',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nomad Flutter Final',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
