import 'package:firebase_auth/firebase_auth.dart';
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/models/Lists.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebase user
  CustomUser? _userFromFirbaseUser(User? user){
    List<Lists> temp = [];
    return user != null ? CustomUser(uid: user.uid, lists: temp) : null;
  }

  // Auth change user stream
  Stream<CustomUser?> get user{
    return _auth.authStateChanges()
            .map(_userFromFirbaseUser);
            //.map((User? user) => _userFromFirbaseUser(user));
  }
  
  // sign in anon
  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirbaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign in w/ email + password

  // register w/ email + password

  // sign out
}