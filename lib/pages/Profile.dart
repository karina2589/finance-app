import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/models/EditableSalaryCard.dart';
import 'package:flutter_frontend/models/UserInfoCard.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/EditableTextRow.dart';
import '../requests/Authentication/StreamAuthScope.dart';

void main() {
  runApp(MaterialApp(
    home: Profile(),
    theme: AppTheme.lightTheme,
  ));
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [

            UserInfoCard(),
            SizedBox(height: 10,),

            /*
            account settings

            general -> change password
            notifications
            your data in balance box

             */

            _accountSettings(context),
            SizedBox(height: 10,),


            Divider(
              indent: 10,
              endIndent: 10,
            ),

            // sign out
            SizedBox(height: 10,),

              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                      onPressed: () {
                        StreamAuthScope.of(context).logout();
                      },
                      child: RichText(text: TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.logout_outlined, size: 20, color: Colors.black,)),
                            TextSpan(
                              text: '  Sign Out',
                              style: GoogleFonts.poppins(
                                  fontSize: 17, color: Colors.black, fontWeight: FontWeight.w400),
                            )
                          ]
                      ))


                  ))
          //  )

          ],
        ))
        //)
        );
  }

  Widget _accountSettings(BuildContext context){
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text('Account details',
          style: Theme.of(context).textTheme.titleMedium,),),
        //general
        TextButton(
            onPressed: () {},
            child: RichText(text: TextSpan(
                children: [
                  WidgetSpan(child: Icon(Icons.settings, size: 20, color: Colors.black,)),
                  TextSpan(
                    text: '  General',
                    style: GoogleFonts.poppins(
                        fontSize: 17, color: Colors.black, fontWeight: FontWeight.w400),
                  )
                ]
            ))
        ),

        //notifications
        TextButton(
            onPressed: () {},
            child: RichText(text: TextSpan(
                children: [
                  WidgetSpan(child: Icon(Icons.notifications_rounded, size: 20, color: Colors.black,)),
                  TextSpan(
                    text: '  Notifications',
                    style: GoogleFonts.poppins(
                        fontSize: 17, color: Colors.black, fontWeight: FontWeight.w400),
                  )
                ]
            )),
        ),

        //data security
        TextButton(
          onPressed: () {},
          child: RichText(text: TextSpan(
              children: [
                WidgetSpan(child: Icon(Icons.security_rounded, size: 20, color: Colors.black,)),
                TextSpan(
                  text: '  Your data in Balance Box',
                  style: GoogleFonts.poppins(
                      fontSize: 17, color: Colors.black, fontWeight: FontWeight.w400),
                )
              ]
          )),
        ),
      ],
    )
    );
  }
}
