import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poms/helper/auth.dart';
import 'package:poms/injection.dart';
import '/utils/text_style.dart';
import 'package:poms/utils/colors.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helper/constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late UserType userType;

  @override
  void initState() {
    super.initState();
    userType = UserType.manufacturer;
  }

  void changeState() {
    setState(() {
      userType = (userType == UserType.customer)
          ? UserType.manufacturer
          : UserType.customer;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController mnemonicController = TextEditingController();

    return BlocProvider(
      create: (context) => getIt<Authentication>(),
      child:
          BlocConsumer<Authentication, AuthState>(listener: (context, state) {
        log(state.toString() + " a dastard");
      }, builder: (context, state) {
        return Scaffold(
          backgroundColor: UIColors.primaryBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "POMS",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 51,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Text(
                      "Welcome",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Text(
                      "Back",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SwitcherButton(
                        offColor: Colors.black,
                        onColor: Colors.white,
                        onChange: (_) {
                          changeState();
                        },
                      ),
                      Text(userType.name.toUpperCase(),
                          style: StyleText.popBold
                              .copyWith(color: Colors.white, fontSize: 20))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16),
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16),
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16),
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      controller: mnemonicController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: "Mnemonic",
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: InkWell(
                      onTap: () async {
                        log(state.toString());
                        getIt<Authentication>().add(SignInUser(
                            email: emailController.text,
                            password: passwordController.text,
                            userType: userType,
                            mnemonic: mnemonicController.text,
                            context: context));
                        log(state.toString());
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.redAccent,
                        ),
                        child: Center(
                          child: state is AuthLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  'Sign In',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
