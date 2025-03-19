import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Вхід через email та пароль
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
        if (!doc.exists) {
          await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            "name": user.displayName ?? "Невідомий користувач",
            "email": email,
            "createdAt": FieldValue.serverTimestamp(),
          });
        }
      }
      return user;
    } catch (e) {
      print("Помилка входу: $e");
      return null;
    }
  }

  // Реєстрація користувача та збереження в Firestore
  Future<User?> registerWithEmailPassword(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "name": name,
          "email": email,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      print("Помилка реєстрації: $e");
      return null;
    }
  }

  // Вхід через Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
        if (!doc.exists) {
          await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            "name": user.displayName ?? "Google Користувач",
            "email": user.email,
            "createdAt": FieldValue.serverTimestamp(),
          });
        }
      }
      return user;
    } catch (e) {
      print("Помилка Google Sign-In: $e");
      return null;
    }
  }

  // Вихід з акаунту
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Отримати поточного користувача
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
