import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:bloc/bloc.dart';
import 'wallet_service.dart';
import '../helper/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class Authentication extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Authentication(AuthState initialState) : super(initialState) {
    on<SignInUser>((event, Emitter<AuthState> emit) async {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      emit(AuthLoading());
      try {
        String pubkey = await genPublicKey(event.mnemonic);
        log("####################" + pubkey);
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email.trim(),
          password: event.password.trim(),
        );
        log('################' + event.userType.toString());
        var userDoc = await FirebaseFirestore.instance
            .collection(event.userType.toString())
            .doc(userCredential.user!.uid)
            .get();
        assert(userDoc.exists);
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        assert(data['publicKey'] == pubkey);
        await _prefs.clear();
        await _prefs.setString('Mode', event.userType.toString());
        await _prefs.setString('Mnemonic', event.mnemonic);
        emit(AuthSuccess());
      } catch (e) {
        log(e.toString());

        FirebaseAuth.instance.signOut();

        emit(AuthError(message: 'Cant login'));
      }
    });

    on<SignUpCustomer>((SignUpCustomer event, emit) async {
      emit(AuthLoading());
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      try {
        await _prefs.clear();
        await _prefs.setString('Mnemonic', event.mnemonic);
        await _prefs.setString('Mode', UserType.customer.toString());
        final UserCredential authResult =
            await auth.createUserWithEmailAndPassword(
                email: event.email, password: event.password);
        final User? user = authResult.user;
        assert(user != null);
        assert(await user?.getIdToken() != null);

        addCustomerData(event, user?.uid);
        emit(AuthSuccess());
      } on FirebaseAuthException catch (e) {
        emit(AuthError(message: 'Credentials Invalid'));
        if (e.code == 'email-already-in-use') {
          MotionToast.error(
                  title: const Text('Error'),
                  description: const Text('Email is already in use'))
              .show(event.context);
        } else if (e.code == 'weak-password') {
          MotionToast.error(
                  title: const Text('Error'),
                  description: const Text('Password is too weak'))
              .show(event.context);
        }
      } catch (e) {
        emit(AuthError(message: 'Cant sign up'));
      }
    });

    on<SignUpManufacturer>((event, emit) async {
      emit(AuthLoading());
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      try {
        log('############## hello');
        await _prefs.clear();
        await _prefs.setString('Mnemonic', event.mnemonic);
        await _prefs.setString('Mode', UserType.manufacturer.toString());
        final UserCredential authResult =
            await auth.createUserWithEmailAndPassword(
                email: event.email, password: event.password);
        final User? user = authResult.user;
        assert(user != null);
        assert(await user?.getIdToken() != null);
        addManufacturerData(event, user?.uid);
        emit(AuthSuccess());
      } on FirebaseAuthException catch (e) {
        emit(AuthError(message: 'Credentials Invalid'));
        if (e.code == 'email-already-in-use') {
          MotionToast.error(
                  title: const Text('Error'),
                  description: const Text('Email is already in use'))
              .show(event.context);
        } else if (e.code == 'weak-password') {
          MotionToast.error(
                  title: const Text('Error'),
                  description: const Text('Password is too weak'))
              .show(event.context);
        }
      } catch (e) {
        emit(AuthError(message: 'Cant sign up'));
      }
    });
  }

  Future<String> genPublicKey(String mnemonic) async {
    final priKey = await WalletService.getPrivateKey(mnemonic);
    final pubKey = await WalletService.getPublicKey(priKey);
    final pub = pubKey.toString();
    return pub;
  }

  void addManufacturerData(SignUpManufacturer event, uid) async {
    final pubKey = await genPublicKey(event.mnemonic);
    await FirebaseFirestore.instance
        .collection(UserType.manufacturer.toString())
        .doc(uid)
        .set({
      'email': event.email,
      'companyName': event.companyName,
      'companyPrefix': event.companyPrefix,
      'publicKey': pubKey
    }).then((value) => log("manufacturer details added successfully"));
  }

  void addCustomerData(SignUpCustomer event, uid) async {
    final pubKey = await genPublicKey(event.mnemonic);
    await FirebaseFirestore.instance
        .collection(UserType.customer.toString())
        .doc(uid)
        .set({
      'email': event.email,
      'name': event.name,
      'publicKey': pubKey
    }).then((value) => log("customer details added successfully"));
  }
}

  //  var pr = await Wallet().getPrivateKey(mn);
//   var p = await Wallet().getPublicKey(pr);