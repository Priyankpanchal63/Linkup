import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linkup/providers/user_provider.dart';
import 'package:linkup/responsive/mobile_screen_layout.dart';
import 'package:linkup/responsive/responsive_layout_screen.dart';
import 'package:linkup/responsive/web_screen_layout.dart';
import 'package:linkup/screens/login_screen.dart';
import 'package:linkup/screens/sign_up_screen.dart';
import 'package:linkup/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the app is running on the web platform
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDAfFBLjXp389ZaveEkWTXPwKOJX5QeWl0",
        authDomain: "linkup-b4243.firebaseapp.com",
        projectId: "linkup-b4243",
        storageBucket: "linkup-b4243.appspot.com",
        messagingSenderId: "947687804408",
        appId: "1:947687804408:web:96593a2b77c9e70e305a0d",
      ),
    );
  } else if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCzq1zQl0WFJPKj9SaIZPrX_JWiPWLI1Ic",
        appId: "1:947687804408:android:0c67ea0121cae6cb305a0d",
        messagingSenderId: "947687804408",
        projectId: "linkup-b4243",
        storageBucket: "linkup-b4243.appspot.com",
      ),
    );
  } else {
    // Fallback for other platforms
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LinkUp',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayot(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
