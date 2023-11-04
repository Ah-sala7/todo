
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_c8_online/database/model/User.dart' as MyUser;
import 'package:todo_c8_online/database/my_database.dart';

import '../ui/dialog_utils.dart';

class AuthProvider extends ChangeNotifier{
  MyUser.User? databaseUser;
  User? firebaseAuthUser;
  Future<void> register(String email ,String password,String name) async{
    var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email,
        password: password);
    var myUser = MyUser.User(
        id: result.user?.uid,
        name: name,
        email: email
    );
    await MyDataBase.addUser(myUser);
  }
Future<void> login(String email ,String password,BuildContext context) async {
  var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password);
  var user = await MyDataBase.readUser(result.user?.uid ?? "");
  if(user==null){
    // user is authenticated but not exists in the database
    DialogUtils.showMessage(context, "error. can't find user in db",
        postActionName: 'ok');
    return;
  }
  databaseUser=user;
  firebaseAuthUser=result.user;
  }
  Future<void>logout()async{
    databaseUser=null;
    FirebaseAuth.instance.signOut();
  }

  bool isUserLoggedInBefore() {
    return FirebaseAuth.instance.currentUser!=null;
  }

  Future<void> retreiveUserFromDatabase() async{
    firebaseAuthUser = FirebaseAuth.instance.currentUser;
    databaseUser= await MyDataBase.readUser(firebaseAuthUser! .uid) ;
  }
}
