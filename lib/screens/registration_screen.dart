import 'package:firebase_project_2/screens/chat_screen.dart';
import 'package:firebase_project_2/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class Register extends StatefulWidget {
  static const registerScreen='register_screen';
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showSpannier=false;
  final _auth=FirebaseAuth.instance;
  bool notVisiabl = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? email;
  String? password;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpannier,
        child: Padding(
          padding:const EdgeInsets.only(left: 20,right: 20,top: 130),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    child: Image.asset('assets/images/messenger.png'),
                    width: 500,
                    height: 180,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: emailController,
                    onSaved: (newValue) {
                      email = emailController.text;
                    },
                    validator: (value) {
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(emailController.text);
                      if (!emailValid) {
                        return "Please re-enter your email";
                      }
                      if (value!.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    style:const TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black),
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      labelText: 'Enter Email',
                      hintText: 'enter email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                      suffixIcon: Icon(
                        Icons.email,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    onSaved: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      }
                      if (!isPasswordCompliant(passwordController.text)) {
                        return 'Please re-enter password';
                      }
                      return null;
                    },
                    obscureText: notVisiabl,
                    decoration: InputDecoration(
                      contentPadding:
                         const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      labelText: 'Enter Password',
                      hintText: 'enter password',
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              notVisiabl=!notVisiabl;
                            });
                          },
                          icon: notVisiabl == true
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder:const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Buttons(
                      title: 'register', onpressed: () async{
                        setState(() {
                          showSpannier=true;
                        });
                        if(formkey.currentState!.validate()) {
                          formkey.currentState!.save();
                          try {
                            final newUser = await _auth
                                .createUserWithEmailAndPassword(
                                email: email!, password: password!);
                            Navigator.pushNamed(context, ChatScreen.chatScreen);
                            setState(() {
                              showSpannier=false;
                            });
                          } catch (e) {
                            print(e);
                          }
                        }
                  }, color: Colors.white)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isPasswordCompliant(String password, [int minLength = 6]) {
    if (password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= minLength;

    return (hasDigits ||
            hasUppercase ||
            hasLowercase ||
            hasSpecialCharacters) &&
        hasMinLength;
  }
}
