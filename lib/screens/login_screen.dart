// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:assignment_task_manager/controller/auth_controller.dart';
import 'package:assignment_task_manager/data/model/api_response.dart';
import 'package:assignment_task_manager/data/model/user_model.dart';
import 'package:assignment_task_manager/data/service/api_caller.dart';
import 'package:assignment_task_manager/screens/forget_pass_email_screen.dart';
import 'package:assignment_task_manager/screens/main_nav_screen.dart';
import 'package:assignment_task_manager/screens/sign_up_screen.dart';
import 'package:assignment_task_manager/utils/urls.dart';
import 'package:assignment_task_manager/widget/screen_bg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _inProgress = false;

  Future<void> _login() async {
    setState(() { _inProgress = true; });

    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
    };

    final ApiResponse response = await ApiCaller.PostRequest(
      url: TMUrls.SignInURL, // নিশ্চিত করো urls.dart এ এই নাম আছে
      body: requestBody,
    );

    setState(() { _inProgress = false; });

    if (response.isSuccess) {
      String token = response.responseData['token'];
      UserModel userModel = UserModel.fromJson(response.responseData['data']);
      
      await AuthController.saveUserData(userModel, token);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainNavScreen()),
          (route) => false,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.errorMessage ?? 'Login failed!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBG(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 160),
                  Text('Get Started With', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) => (value == null || value.isEmpty) ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (value) => (value == null || value.isEmpty) ? 'Enter password' : null,
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: !_inProgress,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) _login();
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined, size: 25),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPassEmailScreen()));
                          },
                          child: const Text('Forgot Password?', style: TextStyle(color: Colors.grey)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())); // নিশ্চিত করো এই স্ক্রিনটি তৈরি আছে
                              },
                              child: const Text('Sign up', style: TextStyle(color: Colors.green)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}