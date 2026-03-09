import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to listen to authentication changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // =====================
  // SIGN UP (REGISTER)
  // =====================
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Store additional user info in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;

    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code}');
      return null;
    } catch (e) {
      print('Sign Up Error: $e');
      return null;
    }
  }

  // =====================
  // SIGN IN (LOGIN)
  // =====================
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;

    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code}');
      return null;
    } catch (e) {
      print('Sign In Error: $e');
      return null;
    }
  }

  // =====================
  // SIGN OUT
  // =====================
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
    }
  }

  // =====================
  // GET USER INFO FROM FIRESTORE
  // =====================
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Get User Data Error: $e');
      return null;
    }
  }
}