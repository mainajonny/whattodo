import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sign_button/sign_button.dart';

import '../const/constants.dart';
import '../data/auth_data.dart';
import '../utils/controllers/auth_controller.dart';
import '../utils/image_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(this.show, {super.key});

  final VoidCallback show;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var auth = Get.put(AuthController());
  var googleAuth = Get.put(GoogleSignInController());

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() {
      setState(() {});
    });
    super.initState();
    _focusNode2.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              image(context, '7'),
              SizedBox(height: 50),
              textfield(email, _focusNode1, 'Email', Icons.email),
              SizedBox(height: 20),
              textfield(password, _focusNode2, 'Password', Icons.password),
              SizedBox(height: 8),
              account(),
              SizedBox(height: 20),
              loginButton(),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SignInButton(
                  buttonType: ButtonType.google,
                  onPressed: () async {
                    await googleAuth.signInWithGoogle().then((userCredential) {
                      googleAuth.userName(userCredential?.user?.displayName);
                      Fluttertoast.showToast(
                        toastLength: Toast.LENGTH_LONG,
                        msg:
                            'Welcome ${userCredential?.user?.displayName ?? ''}',
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget account() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              'Sign UP',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Visibility(
          visible: !auth.isLoading.value,
          replacement: CircularProgressIndicator(color: customMustard),
          child: GestureDetector(
            onTap: () {
              if (email.text.isEmpty) {
                Fluttertoast.showToast(
                  backgroundColor: customRed(1),
                  msg: 'Enter a valid email',
                );
              } else if (password.text.isEmpty) {
                Fluttertoast.showToast(
                  backgroundColor: customRed(1),
                  msg: 'Enter a valid password',
                );
              } else {
                AuthenticationRemote()
                    .login(email.text, password.text)
                    .whenComplete(() {
                      if (auth.hasError.value) {
                        Fluttertoast.showToast(
                          backgroundColor: customRed(1),
                          msg: 'Wrong user credentials',
                        );
                      }
                    });
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: customMustard,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'LogIn',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget textfield(
    TextEditingController controller,
    FocusNode focusNode,
    String typeName,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: typeName.toLowerCase().contains('password'),
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? customMustard : Color(0xffc5c5c5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: typeName,
            labelText: typeName,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xffc5c5c5), width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: customMustard, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }
}
