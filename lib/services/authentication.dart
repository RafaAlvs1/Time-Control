import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudFunctions _fns = CloudFunctions.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
//  final facebookLogin = FacebookLogin();

  Future<FirebaseUser> currentUser() => _auth.currentUser();

  Stream<FirebaseUser> get state => _auth.onAuthStateChanged;

  Future<bool> signIn({@required String email, @required String password}) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password).then((authResult) => authResult != null);
  }

  Future<AuthResult> signInGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    debugPrint(googleUser.toString());
    return signInSocialNetwork(email: googleUser.email, credential: credential);
  }

  Future<AuthResult> signInFacebook() async {
//    final facebookLogin = FacebookLogin();
//    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
//    final result = await facebookLogin.logIn(['email']);
//    if (result.accessToken == null) {
//      debugPrint(result.errorMessage);
//      facebookLogin.logOut();
//      throw Exception(result.errorMessage);
//    }
//    final accessToken = result.accessToken.token;
//    final response = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$accessToken');
//    Map profile = json.decode(response.body);
//    debugPrint(profile.toString());
//    AuthCredential credential = FacebookAuthProvider.getCredential(
//        accessToken: accessToken
//    );
//    return signInSocialNetwork(email: profile['email'], credential: credential);
  }

  Future<AuthResult> signInSocialNetwork({@required String email, @required AuthCredential credential}) async {
    try {
      bool hasProvider = (await _auth.fetchSignInMethodsForEmail(email: email)).contains(credential.providerId);

      debugPrint('hasProvider ${credential.providerId}: $hasProvider');
      if (!hasProvider) {
        final callable = _fns.getHttpsCallable(functionName: 'login');
        HttpsCallableResult resp = await callable.call(<String, dynamic>{
          'email': email
        });

        debugPrint('token: ${resp.data}');

        if (resp.data != null) {
          await _auth.signInWithCustomToken(token: resp.data);
          final user = await _auth.currentUser();
          return user.linkWithCredential(credential);
        }
      }
      return _auth.signInWithCredential(credential);
    } on CloudFunctionsException catch (e) {
      throw e;
    } on PlatformException catch (e) {
      Map valueMap = Map<String, dynamic>.from(e.details);
      throw new Exception(valueMap['message']);
    } catch (e) {
      print('caught generic exception');
      print(e);
      throw e;
    }
  }

  Future<void> signOut(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    return _auth.signOut();
  }
}
