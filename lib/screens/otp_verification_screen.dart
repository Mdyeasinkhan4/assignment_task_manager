import 'package:flutter/material.dart';
import '../data/model/api_response.dart';
import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/screen_bg.dart';
import 'set_new_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController otpController = TextEditingController();
  bool inProgress = false;

  Future<void> verifyOtp() async {
    setState(() { inProgress = true; });

    final ApiResponse response = await ApiCaller.PostRequest(
      url: TMUrls.recoverVerifyOTPURL(widget.email, otpController.text.trim()),
    );

    setState(() { inProgress = false; });

    if (response.isSuccess) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => SetNewPasswordScreen(
          email: widget.email,
          otp: otpController.text.trim(),
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 250,),
            Text('PIN Verification', style: Theme.of(context).textTheme.titleLarge,),
            SizedBox(height: 10,),
            Text('A 6 digit verification pin will send to your email address.'),
            SizedBox(height: 25,),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'PIN'),
            ),
            SizedBox(height: 20,),
            Visibility(
              visible: inProgress == false,
              replacement: Center(child: CircularProgressIndicator()),
              child: FilledButton(
                onPressed: () { verifyOtp(); },
                child: Icon(Icons.arrow_circle_right_outlined, size: 25,),
              ),
            ),
          ],
        ),
      )),
    );
  }
}