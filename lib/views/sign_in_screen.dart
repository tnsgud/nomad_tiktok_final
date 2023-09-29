import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController, _passwordController;

  void _onSignIn() async {
    final isValidate = _formKey.currentState?.validate() ?? false;

    if (!isValidate) return;

    final email = _emailController.text;
    final password = _passwordController.text;
    final instance = FirebaseAuth.instance;

    try {
      await instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      context.go('/');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        print('없는 계정입니다.');
      }
    }
  }

  void _onPushTap() => context.go('/sign-up');

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return '이메일을 입력해주세요.';

                  final reg = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                  if (!reg.hasMatch(value)) return '올바르지 않은 이메일입니다.';

                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return '비밀번호를 입력해주세요.';

                  return null;
                },
              ),
              GestureDetector(
                onTap: _onSignIn,
                child: const Text('sign in'),
              ),
              GestureDetector(
                onTap: _onPushTap,
                child: const Text('sign up'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
