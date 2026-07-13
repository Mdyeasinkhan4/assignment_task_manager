import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../data/model/api_response.dart';
import '../data/model/user_model.dart';
import '../data/service/api_caller.dart';
import '../utils/urls.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    UserModel? user = AuthController.userData;
    emailController.text = user?.email ?? '';
    firstNameController.text = user?.firstName ?? '';
    lastNameController.text = user?.lastName ?? '';
    mobileController.text = user?.mobile ?? '';
  }

  Future<void> updateProfile() async {
    setState(() { inProgress = true; });

    Map<String, dynamic> requestBody = {
      "email": emailController.text,
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "mobile": mobileController.text,
    };

    if (passwordController.text.isNotEmpty) {
      requestBody['password'] = passwordController.text;
    }

    final ApiResponse response = await ApiCaller.PostRequest(
      url: TMUrls.updateProfileURL,
      body: requestBody,
    );

    setState(() { inProgress = false; });

    if (response.isSuccess) {
      UserModel user = UserModel(
        sId: AuthController.userData?.sId,
        email: emailController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobile: mobileController.text,
      );

      AuthController.updateUserData(user);
      await AuthController.getUserData();

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile update hoyeche')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data'].toString())),
      );
    }
  }

  Widget labeledField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 13)),
        SizedBox(height: 4,),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
        ),
        SizedBox(height: 16,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.person, color: Colors.grey.shade600, size: 34,),
                ),
                SizedBox(width: 14,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${firstNameController.text} ${lastNameController.text}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      emailController.text,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25,),

            labeledField(label: 'Email', controller: emailController),
            labeledField(label: 'First Name', controller: firstNameController),
            labeledField(label: 'Last Name', controller: lastNameController),
            labeledField(label: 'Mobile', controller: mobileController),
            labeledField(label: 'Password', controller: passwordController, obscureText: true),

            SizedBox(height: 10,),

            Visibility(
              visible: inProgress == false,
              replacement: Center(child: CircularProgressIndicator()),
              child: FilledButton(
                onPressed: () {
                  updateProfile();
                },
                child: Icon(Icons.arrow_circle_right_outlined, size: 25,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}