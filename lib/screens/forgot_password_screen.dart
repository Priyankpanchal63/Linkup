import 'package:flutter/material.dart';
import 'package:linkup/resources/auth_methods.dart';
import 'package:linkup/utils/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isHovered = false;
  FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose(); // Dispose the FocusNode
  }

  void resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().resetPassword(_emailController.text);
    if (res == "Success") {
      showSnackBar("Check your email to reset your password", context);
      Navigator.of(context).pop();
    } else {
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color fully white
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar background fully white
        elevation: 0, // Remove shadow from AppBar
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.black), // Title color set to black
        ),
        centerTitle: true, // Center the title if needed
        iconTheme: const IconThemeData(color: Colors.black), // Icon color set to black
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'Enter your email to reset your password',
                style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Animated Email TextField
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {});
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _emailFocusNode.hasFocus
                      ? Colors.lightBlue.withOpacity(0.1) // Sky blue background on focus
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _emailFocusNode.hasFocus ? Colors.lightBlue : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: TextField(
                  focusNode: _emailFocusNode,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Colors.lightBlue),
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: resetPassword,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width * 0.9,
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
                    'Send Reset Link',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )
                      : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
