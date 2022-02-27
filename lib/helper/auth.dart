import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signIn(String mail, String pass) async {
    final UserCredential authResult =
        await auth.signInWithEmailAndPassword(email: mail, password: pass);
    final user = authResult.user;

    assert(user != null);
    assert(await user?.getIdToken() != null);

    final currentUser = auth.currentUser!;
    assert(user!.uid == currentUser.uid);
    return user;
  }

  Future<void> registerUser(String mail, String pass) async {
    print('signing up');
    try {
      final UserCredential authResult = await auth
          .createUserWithEmailAndPassword(email: mail, password: pass);
      print('signing up');

      final User? user = authResult.user;
      print('signing up');

      assert(user != null);
      assert(await user?.getIdToken() != null);
      print('signing up');

      final FirebaseFirestore store = FirebaseFirestore.instance;
      print('signing up');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
