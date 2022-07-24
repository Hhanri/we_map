import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/constants/firebase_constants.dart';

class FirebaseAuthService {
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  String get getUserId => authInstance.currentUser!.uid;

  Stream<User?> getUserStateStream() {
    return authInstance.userChanges();
  }

  bool get isSignedIn => authInstance.currentUser != null;

  Future signIn({required String email, required String password}) async {
    await authInstance.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp({required String email, required String password, required String username}) async {
    if (username.isEmpty) throw FirebaseAuthException(code: '1', message: AppStringsConstants.emptyField);
    if (username.length > 20) throw FirebaseAuthException(code: '0', message: AppStringsConstants.tooLongUsername);
    await authInstance.createUserWithEmailAndPassword(email: email, password: password);
    await createProfile(username: username);
    await sendEmailVerification();
  }

  Future<void> sendEmailVerification() async {
    await authInstance.currentUser!.sendEmailVerification();
  }

  Stream<bool> isProfileCreated() {
    return firestoreInstance
      .collection(FirebaseConstants.usersCollection)
      .doc(authInstance.currentUser!.uid)
      .snapshots()
      .map((event) => event.exists);
  }

  Future<void> createProfile({required String username}) async{
    return await firestoreInstance
      .collection(FirebaseConstants.usersCollection)
      .doc(authInstance.currentUser!.uid)
      .set({
        FirebaseConstants.username: username,
        FirebaseConstants.uid: authInstance.currentUser!.uid,
        FirebaseConstants.email: authInstance.currentUser!.email,
        FirebaseConstants.likedPosts: [],
        FirebaseConstants.dislikedPosts: [],
        FirebaseConstants.likedComments: [],
        FirebaseConstants.likedReplies: []
      });
}

  Future<void> signOut() async {
    await authInstance.signOut();
  }
}