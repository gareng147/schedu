import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFungsi {
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> signInDenganEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    }
  }

Future<User?> registerDenganEmailPassword(String email, String password)async{
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
       password: password
       );
  } catch (e) {
    print("Register Error: $e"  );
  }
}

Future<void> signOut()async{
  await _auth.signOut();
}

Stream<User?> get authStateChanges => _auth.authStateChanges();

}