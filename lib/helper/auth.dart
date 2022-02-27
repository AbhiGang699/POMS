import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:bloc/bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class Authentication extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Authentication(AuthState initialState) : super(initialState) {

    on<SignInUser>( (event, emit) async {
      emit(AuthLoading());
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email.trim(),
          password: event.password.trim(),
        );

        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential.user?.uid)
            .get();
        assert(userDoc.exists);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(message: 'Cant login'));
      }
    });

    on<SignUpUser>( (event, emit) async {
      log("entered event handler");
      emit(AuthLoading());
      try {
        log("fetching credentials");
        final UserCredential authResult = await auth
            .createUserWithEmailAndPassword(email: event.email, password: event.password);
        log("user created");
        final User? user = authResult.user;
        assert(user != null);
        assert(await user?.getIdToken() != null);
        log("all tests passed");
        emit(AuthSuccess());
      }on FirebaseAuthException catch (e) {
        emit(AuthError(message: 'Credentials Invalid'));
        if (e.code == 'email-already-in-use') {
          MotionToast.error(
              title:  const Text('Error'),
              description:  const Text('Email is already in use')
          ).show(event.context);
        } else if (e.code == 'weak-password') {
          MotionToast.error(
              title:  const Text('Error'),
              description:  const Text('Password is too weak')
          ).show(event.context);
        }
      }catch (e) {
        emit(AuthError(message: 'Cant sign up'));
      }
    });

  }

  // Stream<AuthState> mapEventToState(AuthEvent event) async* {
  //   if(event is SignInUser){
  //     yield AuthLoading();
  //     try {
  //       final UserCredential userCredential =
  //       await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: event.email.trim(),
  //         password: event.password.trim(),
  //       );
  //
  //       final DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //           .collection('user')
  //           .doc(userCredential.user?.uid)
  //           .get();
  //       assert(userDoc.exists);
  //       yield AuthSuccess();
  //     } catch (e) {
  //       yield AuthError(message: 'Cant login');
  //     }
  //   }else if(event is SignUpUser){
  //     yield AuthLoading();
  //     try {
  //       final UserCredential authResult = await auth
  //           .createUserWithEmailAndPassword(email: event.email, password: event.password);
  //       final User? user = authResult.user;
  //       assert(user != null);
  //       assert(await user?.getIdToken() != null);
  //       yield AuthSuccess();
  //     }on FirebaseAuthException catch (e) {
  //       yield AuthError(message: 'Credentials Invalid');
  //       if (e.code == 'email-already-in-use') {
  //         MotionToast.error(
  //             title:  const Text('Error'),
  //             description:  const Text('Email is already in use')
  //         ).show(event.context);
  //       } else if (e.code == 'weak-password') {
  //         MotionToast.error(
  //             title:  const Text('Error'),
  //             description:  const Text('Password is too weak')
  //         ).show(event.context);
  //       }
  //     }catch (e) {
  //       yield AuthError(message: 'Cant sign up');
  //     }
  //   }
  // }

  // Future<User?> signIn(String mail, String pass) async {
  //   final UserCredential authResult =
  //       await auth.signInWithEmailAndPassword(email: mail, password: pass);
  //   final user = authResult.user;
  //
  //   assert(user != null);
  //   assert(await user?.getIdToken() != null);
  //
  //   final currentUser = auth.currentUser!;
  //   assert(user!.uid == currentUser.uid);
  //   return user;
  // }
  //
  // Future<void> registerUser(context,String mail, String pass) async {
  //   print('signing up');
  //   try {
  //     final UserCredential authResult = await auth
  //         .createUserWithEmailAndPassword(email: mail, password: pass);
  //     print('signing up');
  //
  //     final User? user = authResult.user;
  //     print('signing up');
  //
  //     assert(user != null);
  //     assert(await user?.getIdToken() != null);
  //     print('signing up');
  //
  //     final FirebaseFirestore store = FirebaseFirestore.instance;
  //     print('signing up');
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'email-already-in-use') {
  //       MotionToast.error(
  //           title:  const Text('Error'),
  //           description:  const Text('Email is already in use')
  //       ).show(context);
  //     } else if (e.code == 'weak-password') {
  //       MotionToast.error(
  //           title:  const Text('Error'),
  //           description:  const Text('Password is too weak')
  //       ).show(context);
  //     }
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }
}
