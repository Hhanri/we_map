import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future signIn({required String email, required String password}) async {
    await authInstance.signInWithEmailAndPassword(email: email, password: password);
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
    await authInstance.createUserWithEmailAndPassword(email: email, password: password);
    await firestoreInstance
      .collection('users')
      .doc(authInstance.currentUser!.uid)
      .set({
        'uid': authInstance.currentUser!.uid,
        'isBanned': false
      });
  }

  Future<void> signOut() async {
    await authInstance.signOut();
  }
}