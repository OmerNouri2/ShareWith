//@dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'User.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp(ShareWithUser shareWithUser, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: shareWithUser.emailAddress, password: password);
      User newUser = _firebaseAuth.currentUser;
      await shareWithUser.addUserToDataBase(newUser.uid);
      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
