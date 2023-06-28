import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reliefmate/models/auth_user.dart' as model;
import 'package:reliefmate/services/auth/auth_exceptions.dart';
import 'package:reliefmate/utilities/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.AuthUser> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.AuthUser.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some Error Occured';
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String deviceToken = await getDeviceToken();
      print(deviceToken);
      model.AuthUser user = model.AuthUser(
        uid: cred.user!.uid,
        email: email,
        type: 'user',
        token: deviceToken,
      );
      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());
      res = 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some Error Occured';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = credential.user;

        String deviceToken = await getDeviceToken();
        print(deviceToken);

        await _firestore.collection('users').doc(user!.uid).update({
          'token': deviceToken,
        });

        res = "Success";
      } else {
        res = 'Please Enter all the Fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
