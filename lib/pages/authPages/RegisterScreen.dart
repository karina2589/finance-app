import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthScope.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../route/router.dart';

void main() {
  runApp(MaterialApp(
    home: RegisterScreen(),
  ));
}

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _isLoading = false;
  String? errorMessage;

  late StreamAuthScope _authScope;

  void register() async{
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    String success = await StreamAuthScope.of(context).register(_usernameController.text.trim(), _passController.text.trim());
    errorMessage = success;

    if(success == "Registered"){
      print(success);
      setState(() {
        _isLoading = false;
      });
      context.go('/login');
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage!, style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600
        ),), backgroundColor: Colors.red,),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
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
                      height: 15,
                    ),
                    _textField(_passController, "Password", true),
                    const SizedBox(
                      height: 15,
                    ),
                    _textField(
                        _confirmPassController, "Confirm password", true),
                    const SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 55,
                          child: ElevatedButton(
                              onPressed: () {
                                print('Password: ${_passController.text}');
                                print('Confirm: ${_confirmPassController.text}');


                                if (_passController.text == _confirmPassController.text && _usernameController.text.isNotEmpty) {
                                  // Всё ок — продолжить регистрацию
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(content: Text('Successfully registered', style: GoogleFonts.poppins(
                                  //       color: Colors.white,
                                  //       fontSize: 16,
                                  //     fontWeight: FontWeight.w600
                                  //   ),),
                                  //     backgroundColor: Colors.green,
                                  //   ),
                                  // );
                                  register();
                                }
                                // else if(_passController.text != _confirmPassController.text && _usernameController.text.isEmpty){
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(content: Text("Please fill all text fields correctly", style: GoogleFonts.poppins(
                                //         color: Colors.white,
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w600
                                //     ),), backgroundColor: Colors.red,),
                                //   );
                                // }
                                //
                                // else if(_passController.text.isEmpty && _confirmPassController.text.isEmpty && _usernameController.text.isEmpty){
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(content: Text("Please fill all text fields correctly", style: GoogleFonts.poppins(
                                //         color: Colors.white,
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w600
                                //     ),), backgroundColor: Colors.red,),
                                //   );
                                // }
                                // else if(_usernameController.text.isEmpty || _usernameController.text == null){
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(content: Text("Username can't be empty", style: GoogleFonts.poppins(
                                //         color: Colors.white,
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w600
                                //     ),), backgroundColor: Colors.red,),
                                //   );
                                // }
                                // else{
                                //
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(content: Text('Passwords are different', style: GoogleFonts.poppins(
                                //       color: Colors.white,
                                //       fontSize: 16,
                                //         fontWeight: FontWeight.w600
                                //     ),), backgroundColor: Colors.red,),
                                //   );
                                //   // Повторная проверка на всякий случай
                                //   // setState(() {
                                //   //   errorMessage = 'Passwords are different';
                                //   // });
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.black)
                                  : Text(
                                      "Register",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                        )),
                    const SizedBox(
                      height: 35,
                    ),
                    Text(
                      'Already have an account?',
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
                      onTap: () => context.go(AppPath.login),
                      child: Text(
                        'Log In',
                        style: GoogleFonts.poppins(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  String? validatePassword(String value) {
    // Проверка длины
    if (value.length < 8 || value.length > 12) {
      return 'Password should contain 8-12 symbols';
    }

    // Проверка наличия латинских букв и цифр
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,12}$');
    if (!regex.hasMatch(value)) {
      return 'Password should contain digits and letters';
    }

    return null; // Всё хорошо
  }


  Widget _welcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.monetization_on_rounded,
          color: Colors.amber,
          size: 180,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Welcome to Balance Box!",
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 23),
          textAlign: TextAlign.center,
        ),
        Text(
          "Keep your savings in check",
          style: GoogleFonts.poppins(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400,
              fontSize: 16),
          textAlign: TextAlign.center,
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
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: NotVisible?
        (value) {
          if (value == null || value.isEmpty) {
            return 'Enter password';
          }
          return validatePassword(value);
        }: null,
          obscureText: NotVisible,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          decoration: InputDecoration(
              isDense: true,
              // Уменьшает плотность
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
              errorStyle:  GoogleFonts.poppins(
                  fontSize: 16,
                  height: 0.5,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600),
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
                  color: Colors.grey.shade600)),
      ),
    );
  }
}
