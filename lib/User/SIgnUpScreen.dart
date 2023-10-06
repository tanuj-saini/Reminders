import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/User/LoginScreen.dart';
import 'package:reminder/User/authContoller.dart';
import 'package:reminder/utils/Loder.dart';

class SignUp extends ConsumerStatefulWidget {
  SignUp({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SignUp();
  }
}

class _SignUp extends ConsumerState<SignUp> {
  void sendSignUser(
      {required String name,
      required String password,
      required String email}) async {
    ref.watch(authContoller.notifier).sendSign(
        name: name, password: password, context: context, email: email);
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  final TextEditingController nameContoller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    PasswordController.dispose();
    nameContoller.dispose();
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
                  controller: nameContoller,
                  decoration: InputDecoration(
                      hintText: "Name",
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
                  onPressed: () => sendSignUser(
                      name: nameContoller.text,
                      password: PasswordController.text,
                      email: emailController.text),
                  child: Text("SigIn")),
              SizedBox(
                height: 50,
              ),
              Text("Already have a account"),
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => LoginScreen())),
                child: isLoding ? LoderScreen() : Text("Login In"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
