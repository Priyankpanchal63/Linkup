import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/resources/auth_methods.dart';
import 'package:linkup/responsive/mobile_screen_layout.dart';
import 'package:linkup/responsive/responsive_layout_screen.dart';
import 'package:linkup/responsive/web_screen_layout.dart';
import 'package:linkup/screens/login_screen.dart';
import 'package:linkup/utils/colors.dart';
import 'package:linkup/utils/utils.dart';

import '../widget/text_field_input.dart';
import 'package:image_picker/image_picker.dart';
class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passController=TextEditingController();
  final TextEditingController _bioController=TextEditingController();
  final TextEditingController _usernameController=TextEditingController();
  Uint8List? _image;
  bool _isLoading=false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }
   void selectimage()async{
    Uint8List im= await pickImage(ImageSource.gallery);
    setState(() {
      _image=im;
    });
   }

   void signUpUser()async{
    setState(() {
      _isLoading=true;
    });
     String res =await AuthMethods().signUpUser(
         email: _emailController.text,
         password: _passController.text,
         username: _usernameController.text,
         bio: _bioController.text,
         file: _image!,
     );
    setState(() {
      _isLoading=false;
    });

     if(res !='success'){
         showSnackBar(res,context);
     }
     else{
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const ResponsiveLayot(mobileScreenLayout: MobileScreenLayout(),
           webScreenLayout: WebScreenLayout())));
     }
   }
  void  navigateToLogin(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LoginScreen(),
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
              const SizedBox(height: 32,),
              Stack(
                children: [
                  _image!=null?CircleAvatar(
                radius: 64,
                backgroundImage:MemoryImage(_image!),
              )
                  :const CircleAvatar(
                    radius: 64,
                    backgroundImage:NetworkImage('https://www.pngitem.com/pimgs/m/22-223968_default-profile-picture-circle-hd-png-download.png'),

                  ),
                  Positioned(child:
                  IconButton(onPressed: selectimage,
                    icon: const Icon(Icons.add_a_photo),))
                ],
              ),
              const SizedBox(height: 16,),
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
              //circular

              const SizedBox(height: 16,),
              TextFieldInput(
                hintText: 'Enter your Username',
                textInputType: TextInputType.text,
                textEditingController:_usernameController,
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
              const SizedBox(height: 16,),
              TextFieldInput(
                hintText: 'Enter your Bio',
                textInputType: TextInputType.text,
                textEditingController:_bioController,
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
              const SizedBox(height: 16,),
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
              const SizedBox(height: 16,),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child:_isLoading?Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ) : const Text('Sing up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4),
                    ),
                  ),
                      color: Colors.green
                  ),
                ),
              ),
              const SizedBox(height: 16,),
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
                    onTap: navigateToLogin,
                    child: Container(
                      child: const Text("Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),),
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