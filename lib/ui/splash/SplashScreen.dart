import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c8_online/providers/AuthProvider.dart';
import 'package:todo_c8_online/ui/home/home_screen.dart';
import 'package:todo_c8_online/ui/login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String routeName='splashScreen';
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2),(){
      navigate(context);
    });
    return  Scaffold(
      body: Image.asset('assets/images/splash.png'),
    );
  }

  void navigate(BuildContext context) async{
    var authProvider =Provider.of<AuthProvider>(context,listen: false);
    if(authProvider.isUserLoggedInBefore()){
      await authProvider.retreiveUserFromDatabase();
      Navigator.of(context).pushReplacementNamed( HomeScreen.routeName);
    }else{
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

}
