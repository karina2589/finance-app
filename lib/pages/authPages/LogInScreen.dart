import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthScope.dart';
import 'package:flutter_frontend/route/router.dart';
import 'package:go_router/go_router.dart';

import '../../requests/Authentication/StreamAuth.dart';

void main(){
  runApp(MaterialApp(home: LoginScreen(),));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  //final PageController controller;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  late StreamAuthScope _authScope;
  // late AuthProvider _authProvider;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _authProvider = AuthProvider(StreamAuth()); // Initialize AuthProvider
  // }
  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;

    });
    final success = await StreamAuthScope.of(context).login(_usernameController.text.trim(), _passController.text.trim());

    if (success) {
      if (mounted) {

       // context.go(AppPath.mainPage); // Navigate to main page after login

      }
    } else {
      setState(() {
        _errorMessage = "Login failed. Please check your credentials.";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _passController.dispose();
    super.dispose();
  }

  //final authNotifier = StreamAuthScope.of(context).authNotifier;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'Log In',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 27,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _usernameController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration:  InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      color: Colors.green.shade300,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                       color: Colors.green.shade900,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _passController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration:  InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.green.shade200,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.green.shade900,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                          color: Colors.green.shade900
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: SizedBox(
                    width: 329,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (){
                        if(_isLoading){
                          null;
                        }else{
                          _login();
                          // StreamAuthScope.of(context).login(_emailController.text.trim(), _passController.text.trim());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text(
                      'Don’t have an account?',
                      style: TextStyle(
                        color: Color(0xFF837E93),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 2.5,
                    ),
                    InkWell(
                      onTap:  () => context.go(AppPath.register),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF755DC1),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: Color(0xFF755DC1),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}