import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/model/post.dart';
import 'package:final_project/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/constants/style.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController, _passwordController;
  bool isWeakPassword = false, isAlreadyUsed = false;

  void _onSignUp() async {
    final isValidate = _formKey.currentState?.validate() ?? false;

    isWeakPassword = false;
    isAlreadyUsed = false;

    if (!isValidate) return;

    final email = _emailController.text;
    final password = _passwordController.text;
    final instance = FirebaseAuth.instance;

    try {
      final user = await instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      var collection = FirebaseFirestore.instance.collection(user.user!.email!);
      var initPost = Post(
        content: '우리의 첫 만남!',
        emoji: '0',
        color: '0xFFFFCF87',
        createTime: DateTime.now(),
      );
      collection.add(initPost.toMap());
      context.go('/');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        isWeakPassword = true;
        _formKey.currentState?.validate();
      } else if (e.code == 'email-already-in-use') {
        isAlreadyUsed = true;
        _formKey.currentState?.validate();
        _emailController.text = '';
      }
      _passwordController.text = '';
    }
  }

  void _onPushTap() => context.go('/sign-in');

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
                Text(
                  '회원가입',
                  style: context.displayLarge,
                ),
                Gaps.v20,
                SizedBox(
                  height: Sizes.size96,
                  child: CustomTextFormField(
                    hintText: '이메일',
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력해주세요.';
                      }

                      final reg = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                      if (!reg.hasMatch(value)) return '올바르지 않은 이메일입니다.';

                      if (isAlreadyUsed) return '이미 등록된 이메일입니다.';

                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: Sizes.size96,
                  child: CustomTextFormField(
                    obscureText: true,
                    hintText: '비밀번호',
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요.';
                      }

                      if (isWeakPassword) return '비밀번호가 너무 간단합니다.';

                      return null;
                    },
                  ),
                ),
                GestureDetector(
                  onTap: _onSignUp,
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
                        '회원가입',
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
                      '사용하던 계정이 있습니까? →',
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
