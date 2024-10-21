import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/resources/auth_methods.dart';
import 'package:linkup/responsive/mobile_screen_layout.dart';
import 'package:linkup/responsive/responsive_layout_screen.dart';
import 'package:linkup/responsive/web_screen_layout.dart';
import 'package:linkup/screens/login_screen.dart';
import 'package:linkup/utils/utils.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _bioFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _emailFocusNode.dispose();
    _usernameFocusNode.dispose();
    _bioFocusNode.dispose();
    _passFocusNode.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayot(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      ));
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              Image.asset(
                'assets/linkup.png',
                height: 76,
              ),
              const SizedBox(height: 32),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                      : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                       'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_1280.png'),
                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Email TextField with animation
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {}); // Trigger rebuild for animation
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _emailFocusNode.hasFocus
                        ? Colors.amberAccent.withOpacity(0.1) // Sky blue background on focus
                        : Colors.white,
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

              const SizedBox(height: 16),

              // Username TextField with animation
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {});
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _usernameFocusNode.hasFocus
                        ? Colors.amberAccent.withOpacity(0.1) // Sky blue background on focus
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _usernameFocusNode.hasFocus ? Colors.amberAccent : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    focusNode: _usernameFocusNode,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.lightBlue),
                      hintText: 'Enter your Username',
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

              const SizedBox(height: 16),

              // Bio TextField with animation
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {});
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _bioFocusNode.hasFocus
                        ? Colors.amberAccent.withOpacity(0.1) // Sky blue background on focus
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _bioFocusNode.hasFocus ? Colors.amberAccent : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    focusNode: _bioFocusNode,
                    controller: _bioController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.info, color: Colors.lightBlue),
                      hintText: 'Enter your Bio',
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

              const SizedBox(height: 16),

              // Password TextField with animation
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {});
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _passFocusNode.hasFocus
                        ? Colors.amberAccent.withOpacity(0.1) // Sky blue background on focus
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _passFocusNode.hasFocus ? Colors.amberAccent : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    focusNode: _passFocusNode,
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.lightBlue),
                      hintText: 'Enter your Password',
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

              const SizedBox(height: 16),

              // Sign up button with animation
              InkWell(
                onTap: signUpUser,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    gradient: LinearGradient(
                      colors: [Colors.lightBlue.shade500, Colors.lightBlue.shade700], // Sky blue gradient
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightBlue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold
                  )),
                ),

              ),

              const SizedBox(height: 16),

              Flexible(child: Container(), flex: 2),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 16,color:Colors.grey),
                    ),
                    padding: const EdgeInsets.only(right: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 16, color: Colors.blue,fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
