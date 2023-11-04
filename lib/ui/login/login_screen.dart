import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c8_online/providers/AuthProvider.dart';
import 'package:todo_c8_online/ui/components/custom_form_field.dart';
import 'package:todo_c8_online/ui/dialog_utils.dart';
import 'package:todo_c8_online/ui/home/home_screen.dart';
import 'package:todo_c8_online/ui/register/register_screen.dart';
import 'package:todo_c8_online/validation_utils.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();


  var emailController = TextEditingController(text: 'nabil@route.com');
  var passwordController = TextEditingController(text: '123456');


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color(0xFFDFECDB),
          image: DecorationImage(
              image: AssetImage('assets/images/auth_pattern.png'),
              fit: BoxFit.fill),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
            title: Text('Login'),
          ),
          body: Container(
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .3,
                    ),
                    CustomFormField(
                      controller: emailController,
                      label: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter email';
                        }
                        if(!ValidationUtils.isValidEmail(text)){
                          return 'please enter a valid email';
                        }
                      },
                    ),
                    CustomFormField(
                      controller: passwordController,
                      label: 'Password',
                      keyboardType: TextInputType.text,
                      isPassword: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter password';
                        }
                        if (text.length < 6) {
                          return 'password should at least 6 chars';
                        }
                      },
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12)),
                        onPressed: () {
                          login();
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 24),
                        )
                    ),
                    TextButton(onPressed: (){
                      Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                    },child: Text("Don't Have Account?"),)
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  FirebaseAuth authService = FirebaseAuth.instance;

  void login()async{// async - await
    var authProvider=Provider.of<AuthProvider>(context,listen: false);
    DialogUtils.showLoadingDialog(context,'Loading...');
    try{
      await authProvider.login(emailController.text, passwordController.text,context);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, 'user logged in successfully',
          postActionName: 'ok',
          posAction: (){
            Navigator.pushReplacementNamed(context,HomeScreen.routeName);
          },dismissible: false
      );

    }on FirebaseAuthException catch (e) {
      DialogUtils.hideDialog(context);
      String errorMessage = 'wrong email or password';
        DialogUtils.showMessage(context, errorMessage,
          postActionName: 'ok');

    } catch (e) {
      DialogUtils.hideDialog(context);
      String errorMessage = 'Something went wrong';
      DialogUtils.showMessage(context, errorMessage,
          postActionName: 'cancel',
          negActionName: 'Try Again',
          negAction: (){
            login();
          }
      );

    }
  }
}
