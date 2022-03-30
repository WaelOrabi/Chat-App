import 'package:firebase_project_2/screens/registration_screen.dart';
import 'package:firebase_project_2/screens/signin_screen.dart';
import 'package:firebase_project_2/widgets/buttons.dart';
import 'package:flutter/material.dart';
class WelcomeScreen extends StatefulWidget {
  static const welcomeScreen='welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 180,
                  child: Image.asset('assets/images/messenger.png'),
                ),
                const Text('MessageMe',style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff2e386b),

                ),)
              ],
            ),
           const SizedBox(
              height: 30,
            ),
            Buttons(title: 'Sign In',color: Colors.white,onpressed: (){
           Navigator.pushNamed(context, SignIn.signInScreen);
            },t: 60,),
            Buttons(title: 'Register',color: Colors.white,onpressed: (){
              Navigator.pushNamed(context,Register.registerScreen );
            },t: 20,)
          ],
        ),
      ),
    );
  }
}
