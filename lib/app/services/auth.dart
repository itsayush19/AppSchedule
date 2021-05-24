import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';


class MyUser{
  MyUser({@required this.uid});
  final String uid;
}
abstract class AuthBase{
  Stream<MyUser> get onAuthStateChanged;
  Future<MyUser> currentUser();
  Future<MyUser> signInAn();
  Future<MyUser> signInWithGoogle();
  Future<MyUser> signInWithEmail(String email,String password);
  Future<MyUser> createUserInWithEmail(String email,String password);
  Future<void> signOut();
  String getUid();
}


class Auth implements AuthBase{
  final _firebaseAuth=FirebaseAuth.instance;

  @override
  MyUser _userFromFirebase(User user){
    if(user==null){
      return null;
    }
    else{
      return  MyUser(uid:user.uid);
    }
  }

  Stream<MyUser> get onAuthStateChanged{
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<MyUser> currentUser() async{
    final User user=await _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<MyUser> signInAn() async{
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<MyUser> signInWithGoogle() async{
    final googleSignIn=await GoogleSignIn();
    final googleAccount=await googleSignIn.signIn();
    if(googleAccount!=null){
      final googleAuth=await googleAccount.authentication;
      if(googleAuth.accessToken!=null&&googleAuth.idToken!=null){
        final authResult=await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken
          )
        );
        return _userFromFirebase(authResult.user);
      }
      else{
        throw PlatformException(
          code:'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token'
        );
      }
    }
    else{
      throw PlatformException(
          code:'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user'
      );
    }
  }

  @override
  Future<MyUser> signInWithEmail(String email,String password) async{
    final authResult= await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<MyUser> createUserInWithEmail(String email,String password) async{
    final authResult= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  String getUid(){
    User user=_firebaseAuth.currentUser;
    return user.uid;
  }

}