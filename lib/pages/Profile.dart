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
        backgroundColor: AppTheme.mainBackColor,
        body:
        // Center(
        //     child:
            SingleChildScrollView(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     border: Border.symmetric(horizontal: BorderSide(color: AppTheme.widgetColor, width: 2))
            //   ),
            //   child: Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text(
            //       'Robert Johnson',
            //       style:   GoogleFonts.inder(textStyle: Theme.of(context).textTheme.titleLarge)
            //   ),),
            // ),
            UserInfoCard(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700),
                  onPressed: () {
                    StreamAuthScope.of(context).logout();
                  },
                  child: Text('Log Out')),
            )
          ],
        ))
    //)
    );
  }
}
