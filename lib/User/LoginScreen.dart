import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/User/SIgnUpScreen.dart';
import 'package:reminder/User/authContoller.dart';
import 'package:reminder/utils/Loder.dart';

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends ConsumerState<LoginScreen> {
  void sendLoginUser({required String password, required String email}) async {
    ref
        .watch(authContoller.notifier)
        .sendLogin(password: password, email: email, context: context);
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    PasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoding = ref.watch(authContoller);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)))),
              SizedBox(
                height: 10,
              ),
              TextField(
                  controller: PasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)))),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () => sendLoginUser(
                      password: PasswordController.text,
                      email: emailController.text),
                  child: isLoding ? LoderScreen() : Text("Login")),
              SizedBox(
                height: 50,
              ),
              Text("Don't have a account"),
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => SignUp())),
                child: Text("Sign In"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
