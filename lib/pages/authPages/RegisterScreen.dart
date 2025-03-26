import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../route/router.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Column(
        children: [
          Padding(padding: EdgeInsets.all(100), child: Row(
            children: [
              const Text(
                'Already have an account?',
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
                onTap:  () => context.go(AppPath.login),
                child: const Text(
                  'Sign In',
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
          )
        ],
      ),
    )
    );
  }

}