import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/components/text_field.dart';
import 'package:chatapp/components/custom_button.dart';
import 'package:chatapp/pages/forgot_pw_page.dart';
import 'package:chatapp/pages/sign_up_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/themes/theme_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ref = FirebaseDatabase.instance.ref();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future signin(context) async {
    if (emailTextController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
        final authService = AuthService();
        await authService.signInWithEmailPassword(
          emailTextController.text,
          passwordController.text,
        );
      } catch (e) {
        String error = e.toString();
        error = error.substring(error.lastIndexOf(']') + 1, error.length);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.fixed,
            elevation: 0,
            padding: const EdgeInsets.all(4),
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error',
              message: error,
              contentType: ContentType.failure,
              inMaterialBanner: true,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.fixed,
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: "Fill in details.",
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 16,
                  ),
                ),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                )
              ],
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_open_rounded,
                size: 80,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Welcome back. Login in this page",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                textEditingController: emailTextController,
                hinTtext: 'Email',
                obscure: false,
                type: 'emali',
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                textEditingController: passwordController,
                hinTtext: 'Password',
                obscure: true,
                type: 'password',
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      emailTextController.clear();
                      passwordController.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ForgotPwPage();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                onpressed: () => signin(context),
                child: const Text(
                  "Sign in",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member? ',
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                    child: const Text(
                      "Register here.",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
