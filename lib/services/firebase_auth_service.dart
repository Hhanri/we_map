import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future signIn({required String email, required String password}) async {
    try {
      await authInstance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(error) {
      print(error);
    }
  }

  Stream<User?> getUserStateStream() {
    return authInstance.userChanges();
  }

  Stream<bool> getUserBanStateStream() {
    return firestoreInstance
      .collection('users')
      .doc(authInstance.currentUser!.uid)
      .snapshots()
      .map((event) => event.data()!['isBanned']);
  }

  bool get isSignedIn => authInstance.currentUser != null;

  Future<void> signUp({required String email, required String password}) async {
    try {
      await authInstance.createUserWithEmailAndPassword(email: email, password: password);
      await firestoreInstance
        .collection('users')
        .doc(authInstance.currentUser!.uid)
        .set({
        'uid': authInstance.currentUser!.uid,
        'isBanned': false
      });
    } on FirebaseException catch(error) {
      print(error.message);
    }
  }

  Future<void> signOut() async {
    try {
      await authInstance.signOut();
    } catch (error) {
      print(error);
    }
  }
}