import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthScope.dart';
import 'package:flutter_frontend/route/router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _welcome(),
                const SizedBox(
                  height: 45,
                ),
                _textField(_usernameController, "Username", false),
                const SizedBox(
                  height: 10,
                ),
                _textField(_passController, "Password", true),
                const SizedBox(
                  height: 25,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 55,
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
                        backgroundColor: Colors.amber,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          :  Text(
                        'Sign In',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      'Don’t have an account?',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 2.5,
                    ),
                    InkWell(
                      onTap:  () => context.go(AppPath.register),
                      child:  Text(
                        'Register!',
                        style: GoogleFonts.poppins(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                 Text(
                  'Forget Password?',
                  style: GoogleFonts.poppins(
                    color: Colors.amber,
                    fontSize: 14,
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
  Widget _welcome(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.monetization_on_rounded, color: Colors.amber,size:  180,),
        SizedBox(height: 15,),
        Text("Welcome to Balance Box!", style: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 23
        ),textAlign: TextAlign.center,
        ),
        Text("Keep your savings in check", style: GoogleFonts.poppins(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w400,
            fontSize: 16
        ),textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget _textField(
      TextEditingController controller, String title, bool NotVisible) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 55,
      alignment: Alignment.center,
      child: TextField(
          obscureText: NotVisible,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          decoration: InputDecoration(
              isDense: true, // Уменьшает плотность
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            // Reduce height
              filled: true,
              fillColor: Colors.grey.shade200,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey.shade200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.amber,
                ),
              ),
              labelText: title,
              labelStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600)
      )
      ),
    );
  }
}