import 'package:firebase_auth/firebase_auth.dart';
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/screens/services/db_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DBService dbService = DBService();

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
      dbService.addUserToDatabase(user!.uid);
      return _userFromFirbaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign in w/ email + password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirbaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // register w/ email + password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      dbService.addUserToDatabase(user!.uid);
      return _userFromFirbaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}