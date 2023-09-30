import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/constants/style.dart';
import 'package:final_project/widgets/custom_text_form_field.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextFormField(
                  hintText: 'email',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요.';
                    }

                    final reg = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                    if (!reg.hasMatch(value)) return '올바르지 않은 이메일입니다.';

                    return null;
                  },
                ),
                Gaps.v10,
                CustomTextFormField(
                  obscureText: true,
                  hintText: 'password',
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }

                    return null;
                  },
                ),
                Gaps.v20,
                GestureDetector(
                  onTap: _onSignIn,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.size10,
                    ),
                    child: Center(
                      child: Text(
                        '로그인',
                        style: context.displaySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Gaps.v32,
                GestureDetector(
                  onTap: _onPushTap,
                  child: Center(
                    child: Text(
                      '아직 계정이 없습니까? →',
                      style: context.bodySmall.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
