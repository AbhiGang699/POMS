import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poms/helper/auth.dart';
import 'package:poms/injection.dart';
import 'package:switcher_button/switcher_button.dart';
import '../utils/colors.dart';
import '/utils/text_style.dart';
import '../helper/wallet_service.dart';
import '../helper/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String mnemonic;
  late UserType userType;
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController companyPrefixController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mnemonic = "Tap to generate mnemonic and long press to copy";
    userType = UserType.manufacturer;
  }

  void changeState() {
    setState(() {
      userType = (userType == UserType.customer)
          ? UserType.manufacturer
          : UserType.customer;
    });
  }

  void signUpUser(context) {
    if (mnemonic == "Tap to generate mnemonic and long press to copy") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Choose Mnemonic first'),
      ));
      return;
    }
    if (userType == UserType.manufacturer) {
      getIt<Authentication>().add(SignUpManufacturer(
          email: emailController.text,
          password: passwordController.text,
          companyName: companyNameController.text,
          companyPrefix: companyPrefixController.text,
          mnemonic: mnemonic,
          context: context));
    } else {
      getIt<Authentication>().add(SignUpCustomer(
          email: emailController.text,
          password: passwordController.text,
          name: companyNameController.text,
          mnemonic: mnemonic,
          context: context));
    }
  }

  void genMnemonic() {
    setState(() {
      mnemonic = WalletService.generateMnemonic();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                              Text(userType.name.toUpperCase(),
                                  style: StyleText.popBold.copyWith(
                                      color: Colors.white, fontSize: 20))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 8),
                            child: TextFormField(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              controller: companyNameController,
                              decoration: InputDecoration(
                                labelText: userType == UserType.manufacturer
                                    ? "Company Name"
                                    : "Name",
                                labelStyle: StyleText.popRegular.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (userType == UserType.manufacturer)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0, vertical: 8),
                              child: TextFormField(
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                controller: companyPrefixController,
                                maxLength: 8,
                                validator: (input) {
                                  if (input!.length < 5) {
                                    return "Prefix too short";
                                  } else {
                                    return null;
                                  }
                                },
                                onFieldSubmitted: (_) => companyPrefixController
                                    .text = _.toUpperCase(),
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                decoration: InputDecoration(
                                  labelText: "Company Prefix",
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
                            child: TextButton(
                                onPressed: genMnemonic,
                                child: Text(
                                  mnemonic,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                onLongPress: () {
                                  if (mnemonic !=
                                      "Tap to generate mnemonic and long press to copy") {
                                    Clipboard.setData(
                                        ClipboardData(text: mnemonic));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Copied to clipboard! Dont Lose It.'),
                                    ));
                                  }
                                }),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 16),
                            child: InkWell(
                              onTap: () => signUpUser(context),
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


// String mn = Wallet.generateMnemonic();
//   var pr = await Wallet().getPrivateKey(mn);
//   var p = await Wallet().getPublicKey(pr);