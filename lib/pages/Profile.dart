import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/models/EditableSalaryCard.dart';
import 'package:flutter_frontend/models/UserInfoCard.dart';

// void main() {
//   runApp(MaterialApp(home: Profile(), theme: AppTheme.lightTheme,));
// }

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppTheme.mainBackColor,
        body: Center(
            child: SingleChildScrollView(
                child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: AppTheme.iconsSecond,
            )),
        Text(
          'Robert Johnson',
          style: Theme.of(context).textTheme.titleLarge,
        ),
       UserInfoCard(),
        SizedBox(
          height: 350,
          child: EditableProfileCard(),
        ),
      ],
    ))));
  }

}



