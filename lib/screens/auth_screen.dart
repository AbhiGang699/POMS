import 'package:flutter/material.dart';
import 'package:poms/components/sign_in_form.dart';
import 'package:poms/components/sign_up_form.dart';
import 'package:poms/utils/colors.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late bool state;
  late String message;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    state = true;
    message = " Create Account";
  }

  void changeState() {
    setState(() {
      if (state == true) {
        state = false;
      } else {
        state = true;
      }

      message = state == true ? "Create Account" : "Already an user? Sign In";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColors.primaryBackground,
      body: state == true ? const SignInScreen() : const SignUpScreen(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => changeState(),
        label: Text(message),
      ),
    );
  }
}
