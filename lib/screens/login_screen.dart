import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/resources/auth_methods.dart';
import 'package:linkup/screens/forgot_password_screen.dart';
import 'package:linkup/screens/sign_up_screen.dart';
// import 'package:linkup/screens/BusinessLoginScreen.dart'; // Import for business login
import 'package:linkup/utils/utils.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();
  bool _isHovered = false; // Track hover state for the button

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res =   await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passController.text,
    );

    if (res == "Success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayot(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      ));
    } else {
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SingUpScreen(),
    ));
  }

  void navigateToForgotPassword() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ForgotPasswordScreen(),
    ));
  }

  // Navigate to Business Login Screen
  // void navigateToBusinessLogin() {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => const BusinessLoginScreen(), // Business login page
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/linkup.png',
                    height: 76,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 64),

                  // Email TextField
                  Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {});
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: _emailFocusNode.hasFocus ? Colors.amberAccent.withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _emailFocusNode.hasFocus ? Colors.amberAccent : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        focusNode: _emailFocusNode,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.lightBlue),
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Password TextField
                  Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {});
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: _passFocusNode.hasFocus ? Colors.amberAccent.withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _passFocusNode.hasFocus ? Colors.amberAccent: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        focusNode: _passFocusNode,
                        controller: _passController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.lightBlue),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login button
                  InkWell(
                    onTap: loginUser,
                    onHover: (isHovered) {
                      setState(() {
                        _isHovered = isHovered;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: MediaQuery.of(context).size.width * 0.8,
                      alignment: Alignment.center,
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        gradient: LinearGradient(
                          colors: _isHovered
                              ? [Colors.lightBlue.shade700, Colors.lightBlue.shade900]
                              : [Colors.lightBlue.shade500, Colors.lightBlue.shade700],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.lightBlue.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: !_isLoading
                          ? const Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : const CircularProgressIndicator(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Forgot Password link
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: navigateToForgotPassword,
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign Up Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: navigateToSignUp,
                        child: const Text(
                          " Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Business Login link
                  // TextButton(
                  //   onPressed: navigateToBusinessLogin, // Navigate to business login
                  //   child: const Text(
                  //     'Log in with Business Account',
                  //     style: TextStyle(
                  //       color: Colors.lightBlue,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
