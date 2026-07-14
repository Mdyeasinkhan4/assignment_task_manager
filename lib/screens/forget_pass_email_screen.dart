
import 'package:flutter/material.dart';
import '../widget/screen_bg.dart';
import 'otp_verification_screen.dart';

class ForgetPassEmailScreen extends StatefulWidget {
  const ForgetPassEmailScreen({super.key});

  @override
  State<ForgetPassEmailScreen> createState() => _ForgetPassEmailScreenState();
}

class _ForgetPassEmailScreenState extends State<ForgetPassEmailScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool inProgress = false;

  void navigateToOtpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationScreen(email: emailController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBG(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 250),
                Text(
                  'Your Email Address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                const Text('A 6 digit verification pin will send to your email address.'),
                const SizedBox(height: 25),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: inProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: FilledButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        navigateToOtpScreen();
                      }
                    },
                    child: const Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}