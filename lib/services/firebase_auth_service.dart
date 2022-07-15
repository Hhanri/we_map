import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_map/constants/firebase_constants.dart';

class FirebaseAuthService {
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future signIn({required String email, required String password}) async {
    await authInstance.signInWithEmailAndPassword(email: email, password: password);
  }

  Stream<User?> getUserStateStream() {
    return authInstance.userChanges();
  }

  bool get isSignedIn => authInstance.currentUser != null;

  Future<void> signUp({required String email, required String password}) async {
    await authInstance.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<bool> get isProfileCreated async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await firestoreInstance
        .collection(FirebaseConstants.usersCollection)
        .doc(authInstance.currentUser!.uid)
        .get();
    return doc.exists;
  }

  Future<void> createProfile({required String username, required}) async{
   return await firestoreInstance
    .collection(FirebaseConstants.usersCollection)
    .doc(authInstance.currentUser!.uid)
    .set({FirebaseConstants.username: username});
}

  Future<void> signOut() async {
    await authInstance.signOut();
  }
}