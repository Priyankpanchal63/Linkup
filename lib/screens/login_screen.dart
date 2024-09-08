import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:linkup/resources/auth_methods.dart';
import 'package:linkup/screens/sign_up_screen.dart';
import 'package:linkup/utils/colors.dart';

import 'package:linkup/utils/utils.dart';
import 'package:linkup/widget/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passController=TextEditingController();
  bool _isLoading=false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  void loginUser()async{
    setState(() {
      _isLoading=true;
    });

    String res=await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passController.text,
    );
    if(res=="Succses"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context)=>
          const ResponsiveLayot(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout()
          )
      )
      );
    }
    else{
      //
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading=false;
    });
  }
  void  navigateToSign(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SingUpScreen(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex:2),
              Image.asset(
                'assets/linkup.jpg',
                height: 64,),
              const SizedBox(height: 64,),
              //text field input for email
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
              ),
              //text field input for password
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: 'Enter your Password',
                textInputType: TextInputType.text,
                textEditingController:_passController,
                isPass: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
              ),
              const SizedBox(height: 24,),

              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration
                    (shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                    color: Colors.green,
                  ),
                  child: !_isLoading
                      ? const Text('Log in',)
                      :const CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 24,),
              Flexible(child: Container(),flex:2),
              //transition to sining up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account?"),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToSign,
                    child: Container(
                      child: Text("Sing up",style: TextStyle(fontWeight: FontWeight.bold),),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}