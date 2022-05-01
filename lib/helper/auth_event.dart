part of 'auth.dart';

abstract class AuthEvent {}

class SignInUser implements AuthEvent {
  final String email;
  final String password;
  final UserType userType;
  final String mnemonic;
  final BuildContext context;

  SignInUser({
    required this.email,
    required this.password,
    required this.userType,
    required this.mnemonic,
    required this.context,
  });
}

class SignUpCustomer implements AuthEvent {
  final String email;
  final String password;
  final String name;
  final String mnemonic;
  final BuildContext context;

  SignUpCustomer({
    required this.email,
    required this.password,
    required this.name,
    required this.mnemonic,
    required this.context,
  });
}

class SignUpManufacturer implements AuthEvent {
  final String email;
  final String password;
  final String companyName;
  final String companyPrefix;
  final String mnemonic;
  final BuildContext context;

  SignUpManufacturer({
    required this.email,
    required this.password,
    required this.companyName,
    required this.companyPrefix,
    required this.mnemonic,
    required this.context,
  });
}
