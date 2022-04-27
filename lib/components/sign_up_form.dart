import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poms/helper/auth/auth.dart';
import 'package:poms/injection.dart';
import 'package:switcher_button/switcher_button.dart';
import '../utils/colors.dart';
import '/utils/text_style.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String userType;

  @override
  void initState() {
    super.initState();
    userType = "Manufacturer";
  }

  void changeState() {
    setState(() {
      userType = (userType == "Customer") ? "Manufacturer" : "Customer";
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController companyNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocProvider(
      create: (context) => getIt<Authentication>(),
      child: BlocConsumer<Authentication, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              backgroundColor: UIColors.primaryBackground,
              body: SafeArea(
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
                            child: Text("Create Account",
                                style: StyleText.popBold.copyWith(
                                  color: Colors.white,
                                  fontSize: 32,
                                )),
                          ),
                          const SizedBox(
                            height: 30,
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
                              Text(userType + " Login",
                                  style: StyleText.popBold.copyWith(
                                      color: Colors.white, fontSize: 20))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 8),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 8),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 8),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 16),
                            child: InkWell(
                              onTap: () {
                                getIt<Authentication>().add(SignUpUser(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    companyName: companyNameController.text,
                                    context: this.context));
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.redAccent),
                                child: Center(
                                  child: state is AuthLoading
                                      ? const CircularProgressIndicator()
                                      : Text(
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
                        ]),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
