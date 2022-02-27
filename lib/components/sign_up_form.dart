import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poms/helper/auth.dart';
import '/utils/colors.dart';
import '/utils/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final Authentication _authHelper = Authentication();
    final TextEditingController companyNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return SafeArea(
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "POMS",
                  style: StyleText.popBold.copyWith(
                    color: Colors.white,
                    fontSize: 51,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Text("Create",
                    style: StyleText.popBold.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Text("Account",
                    style: StyleText.popBold.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                child: TextFormField(
                  controller: emailController,
                  key: const ValueKey('mail'),
                  validator: (mail) {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(mail!);
                    // ignore: unnecessary_null_comparison
                    if (emailValid == false || mail == null) {
                      return "Enter valid e-mail !";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: StyleText.popRegular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: StyleText.popRegular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                child: TextFormField(
                  controller: companyNameController,
                  decoration: InputDecoration(
                    labelText: "Company Name",
                    labelStyle: StyleText.popRegular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                child: InkWell(
                  onTap: () async {
                    print(emailController.text);
                    await _authHelper.registerUser(
                        emailController.text, passwordController.text);
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.redAccent),
                    child: Center(
                      child:
                          // state is AuthLoading
                          //     ? const CircularProgressIndicator()
                          //     :
                          Text(
                        'Sign Up',
                        style: StyleText.popBold.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
