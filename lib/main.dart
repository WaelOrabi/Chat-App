import 'package:firebase_project_2/screens/chat_screen.dart';
import 'package:firebase_project_2/screens/registration_screen.dart';
import 'package:firebase_project_2/screens/signin_screen.dart';
import 'package:firebase_project_2/screens/welcome_screen.dart';
import'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final _auth=FirebaseAuth.instance;
   MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MessageMe app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute:_auth.currentUser==null? WelcomeScreen.welcomeScreen:ChatScreen.chatScreen,
      routes: {
        WelcomeScreen.welcomeScreen:(context)=>const WelcomeScreen(),
        SignIn.signInScreen:(context)=>const SignIn(),
        Register.registerScreen:(context)=>const Register(),
        ChatScreen.chatScreen:(context)=>const ChatScreen(),
      },
    );
  }
}
