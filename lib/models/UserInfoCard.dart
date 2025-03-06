import 'package:flutter/material.dart';
import 'package:flutter_frontend/jsonModels/User.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthScope.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../pages/surveyPages/surveyModels/ScrollableDate.dart';

class UserInfoCard extends StatefulWidget {
  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  int? _selectedGender; // 0 - Female, 1 - Male

  //gender + dob

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }

  loadUserData() async {
    final user = await User.fetchData();
    if (user != null) {
      if(mounted){
      setState(() {
        _nameController.text = user.username;
        _fullnameController.text = user.fullname ?? "";
        _emailController.text = user.email ?? "";
        _dobController.text = user.dob ?? "";
        _selectedGender = user.gender?.toLowerCase().trim() == "male"
            ? 1
            : user.gender?.toLowerCase().trim() == "female"
            ? 0
            : null;
      });
      print(user.gender);
      }
    }
  }

  bool _isEditing = false; // Флаг режима редактирования
  bool _hasChanges = false; // Флаг изменения текста

  @override
  void dispose() {
    _nameController.dispose();
    _fullnameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void showTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Отступ от верхнего края
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Автоматически убираем через 2 секунды
    Future.delayed(Duration(seconds: 15), () {
      overlayEntry.remove();
    });
  }


  void _toggleEdit() async {
    if (_isEditing && _hasChanges) {
      String updateStatus = await User.updateUserData(
        fullname: _fullnameController.text,
        username: _nameController.text,
        email: _emailController.text,
        dob: _dobController.text,
        gender: _selectedGender == 0
            ? "Female"
            : _selectedGender == 1
            ? "Male"
            : null,
      );

      showTopSnackBar(context, updateStatus);

      print("Сохранено: ${_nameController.text}, ${_fullnameController.text}, ${_emailController.text}");
    }

    // Теперь изменяем состояние внутри setState() синхронно
    setState(() {
      _isEditing = !_isEditing;
      _hasChanges = false;
    });
  }

  void _onTextChanged(String _) {
    setState(() {
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.grey.shade50,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Account details',
                      style: Theme.of(context).textTheme.titleMedium),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 20),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.red.shade700
                  //     ),
                  //       onPressed: () {
                  //       StreamAuthScope.of(context).logout();
                  //       },
                  //       child: Text('Log Out')),
                  // )
                ],
              ),
              SizedBox(height: 10),
              _buildEditableRow("Username", _nameController),
              _buildEditableRow("Full name", _fullnameController),
              _buildEditableRow("Email", _emailController),
              _datePicker(context, "Date of Birth", _dobController),
              _buildGenderSelection(),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _toggleEdit,
                  child: Text(
                      _isEditing ? (_hasChanges ? "Save" : "Cancel") : "Edit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 100,
            child: Text(
                textAlign: TextAlign.center,
                label,
                style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
          ),
          Expanded(
              child: _isEditing
                  ? SizedBox(
                      height: 40,
                      child: TextField(
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        controller: controller,
                        onChanged: _onTextChanged,
                        style: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(controller.text,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300)),
                    )
              // Text(controller.text, style: Theme.of(context).textTheme.bodyMedium, ),
              ),
        ],
      ),
    );
  }

  Widget _datePicker(
      BuildContext context, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 100,
            child: Text(
                textAlign: TextAlign.center,
                label,
                style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
          ),
          Expanded(
              child: _isEditing
                  ? SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ScrollableDate(
                        date: controller,
                        onDateSelected: _onTextChanged,
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(controller.text,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300)),
                    )
              // Text(controller.text, style: Theme.of(context).textTheme.bodyMedium, ),
              ),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "Gender",
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            child: _isEditing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _genderButton("Female", 0),
                      _genderButton("Male", 1),
                    ],
                  )
                : _genderDisplay(), // Показывает текущий выбор в неактивном режиме
          ),
        ],
      ),
    );
  }

  /// Отображает выбранный пол в неактивном режиме
  Widget _genderDisplay() {
    String genderText;
    switch (_selectedGender) {
      case 0:
        genderText = "Female";
        break;
      case 1:
        genderText = "Male";
        break;
      default:
        genderText = "Not Specified";
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        genderText,
        textAlign: TextAlign.center,
        style: GoogleFonts.ubuntu(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300),
      ),
    );
  }

  /// Кнопки выбора пола
  Widget _genderButton(String label, int? value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedGender = value;
          _hasChanges = true;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _selectedGender == value ? Colors.blue : Colors.grey.shade300,
        foregroundColor: _selectedGender == value ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }
}
