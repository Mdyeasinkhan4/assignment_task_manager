import 'package:flutter/material.dart';
import '../data/model/api_response.dart';
import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/screen_bg.dart';
import 'login_screen.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const SetNewPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool inProgress = false;

  Future<void> resetPassword() async {
    setState(() { inProgress = true; });

    final ApiResponse response = await ApiCaller.PostRequest(
      url: TMUrls.recoverResetPassURL,
      body: {
        "email": widget.email,
        "OTP": widget.otp,
        "password": passwordController.text,
      },
    );

    setState(() { inProgress = false; });

    if (response.isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset success, ekhon login koro')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data'].toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBG(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 200,),
              Text('Set Password', style: Theme.of(context).textTheme.titleLarge,),
              SizedBox(height: 10,),
              Text('Enter your new password to proceed with your account.'),
              SizedBox(height: 25,),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter password';
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Confirm Password'),
                validator: (value) {
                  if (value != passwordController.text) return 'Password mile nai';
                  return null;
                },
              ),
              SizedBox(height: 20,),
              Visibility(
                visible: inProgress == false,
                replacement: Center(child: CircularProgressIndicator()),
                child: FilledButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      resetPassword();
                    }
                  },
                  child: Icon(Icons.arrow_circle_right_outlined, size: 25,),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
