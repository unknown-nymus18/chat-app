import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/components/text_field.dart';
import 'package:chatapp/components/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/themes/theme_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordconfirm = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  bool checker() {
    if (emailTextController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordconfirm.text.isNotEmpty &&
        firstName.text.isNotEmpty &&
        lastName.text.isNotEmpty &&
        passwordconfirm.text == passwordController.text) {
      return true;
    }
    if (passwordController.text != passwordconfirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: 'Passwords don\'t match',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
    return false;
  }

  Future signup(context) async {
    if (checker()) {
      try {
        final authService = AuthService(firstName: firstName.text);
        await authService.signUpWithEmailPassword(
            emailTextController.text, passwordController.text);

        var firebase = FirebaseAuth.instance;
        if (firebase.currentUser!.uid.isNotEmpty) {
          Navigator.pop(context);
        }
      } catch (e) {
        String error = e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: AwesomeSnackbarContent(
                title: 'Error',
                message: error,
                contentType: ContentType.failure),
          ),
        );
      }
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: AwesomeSnackbarContent(
            title: "Error",
            message: 'Fill in all the details',
            contentType: ContentType.failure),
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordconfirm.dispose();
    emailTextController.dispose();
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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.message,
                  size: 80,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Looks like you're new here. Welcome",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  textEditingController: firstName,
                  hinTtext: 'First name',
                  type: 'name',
                  obscure: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  textEditingController: lastName,
                  hinTtext: 'Last name',
                  type: 'name',
                  obscure: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    textEditingController: emailTextController,
                    hinTtext: 'Email',
                    obscure: false,
                    type: 'email'),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  textEditingController: passwordController,
                  hinTtext: 'Password',
                  type: 'password',
                  obscure: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  textEditingController: passwordconfirm,
                  hinTtext: 'Confirm Password',
                  type: 'password',
                  obscure: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onpressed: () => signup(context),
                  child: const Text(
                    "Sign up",
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
                      'Already a member ? ',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        emailTextController.clear();
                        passwordController.clear();
                        passwordconfirm.clear();
                        firstName.clear();
                        lastName.clear();
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Text(
                        "Login Here",
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
      ),
    );
  }
}
