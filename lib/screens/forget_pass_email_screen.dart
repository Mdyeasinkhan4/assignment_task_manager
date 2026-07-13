import 'package:flutter/material.dart';
import '../data/model/api_response.dart';
import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/screen_bg.dart';
import 'otp_verification_screen.dart';

class ForgetPassEmailScreen extends StatefulWidget {
  const ForgetPassEmailScreen({super.key});

  @override
  State<ForgetPassEmailScreen> createState() => _ForgetPassEmailScreenState();
}

class _ForgetPassEmailScreenState extends State<ForgetPassEmailScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool inProgress = false;

  Future<void> sendOtp() async {
    setState(() { inProgress = true; });

    final ApiResponse response = await ApiCaller.getRequest(
      url: TMUrls.recoverVerifyEmailURL(emailController.text.trim()),
    );

    setState(() { inProgress = false; });

    if (response.isSuccess) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => OtpVerificationScreen(email: emailController.text.trim()),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data']?.toString() ?? 'Something went wrong')),
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
              SizedBox(height: 250,),
              Text('Your Email Address', style: Theme.of(context).textTheme.titleLarge,),
              SizedBox(height: 10,),
              Text('A 6 digit verification pin will send to your email address.'),
              SizedBox(height: 25,),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter email';
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
                      sendOtp();
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