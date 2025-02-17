import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthScope.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../requests/AuthProvider.dart';

class UserInfoCard extends StatefulWidget {
  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  final TextEditingController _nameController =
      TextEditingController(text: "Robert");
  final TextEditingController _surnameController =
      TextEditingController(text: "Johnson");
  final TextEditingController _emailController =
      TextEditingController(text: "robertjj@gmail.com");

  bool _isEditing = false; // Флаг режима редактирования
  bool _hasChanges = false; // Флаг изменения текста

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing && _hasChanges) {
        // Логика сохранения данных (если нужно)
        print(
            "Сохранено: ${_nameController.text}, ${_surnameController.text}, ${_emailController.text}");
      }
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: AppTheme.widgetColor,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700
                      ),
                        onPressed: () {
                        StreamAuthScope.of(context).logout();
                        },
                        child: Text('Log Out')),
                  )
                ],
              ),
              SizedBox(height: 10),
              _buildEditableRow("Name", _nameController),
              _buildEditableRow("Surname", _surnameController),
              _buildEditableRow("Email", _emailController),
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
        children: [
          SizedBox(
              width: 80,
              child:
                  Text(label, style: Theme.of(context).textTheme.titleSmall)),
          Expanded(
              child: _isEditing
                  ? TextField(
                      controller: controller,
                      onChanged: _onTextChanged,
                      style: Theme.of(context).textTheme.titleSmall,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      child: Text(controller.text,
                          style: Theme.of(context).textTheme.titleSmall),
                    )
              // Text(controller.text, style: Theme.of(context).textTheme.bodyMedium, ),
              ),
        ],
      ),
    );
  }
}
