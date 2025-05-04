import 'dart:convert';
import 'dart:io';
import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:http_parser/http_parser.dart'; // нужен для MediaType
import 'package:flutter_frontend/jsonModels/FileInfo.dart';
import 'package:flutter_frontend/jsonModels/StatementTransaction.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankStatement {
  /*
  {

    "transactions": [
        {
            "createdAt": "2025-02-17T00:00:00.000Z",
            "amount": 1900,
            "type": "EXPENSE",
            "title": "ХОЗТОВАРЫ"
        },
        {
            "createdAt": "2025-02-17T00:00:00.000Z",
            "amount": 1900,
            "type": "INCOME",
            "title": "From Kaspi Deposit"
        }
    ]
}
   */

  // final FileInfo fileInfo;
  final List<StatementTransaction> statementTransactions;

  BankStatement({
    // required this.fileInfo,
    required this.statementTransactions
  });

  factory BankStatement.fromJson(List<dynamic> json) {
    print(json);
    return BankStatement(
      // fileInfo: FileInfo.fromJson(json['file']),
      statementTransactions: StatementTransaction.fromJsonList(json),
    );
  }

  // static Future<void> pickFileAndUpload(int cardId) async {
  //   final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom, allowedExtensions: ['pdf']);
  //
  //   if (result != null && result.files.single.path != null) {
  //     final file = File(result.files.single.path!);
  //     await uploadFile(file, cardId);
  //   } else {
  //     print("Файл не выбран");
  //   }
  // }


  static Future<BankStatement?> uploadFile(String filePath, int cardId, String bank) async {
    final uri = Uri.parse(AppConfig.statementUploadEndPoint).replace(queryParameters: {
      'bank': bank, // e.g., 'week', 'month', 'year'
    });
    final request = http.MultipartRequest('POST', uri);

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      request.headers['user-id'] = "2cbbbf55-81f0-4475-8fe0-e29c664b6aa3";
      request.fields['cardId'] = cardId.toString();

      request.files.add(
        await http.MultipartFile.fromPath(
          'bankstatement',
          filePath,
          contentType: MediaType('application', 'pdf'),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(responseBody);
        final List<StatementTransaction> transactions =
        StatementTransaction.fromJsonList(json);

        return BankStatement(statementTransactions: transactions);
      } else {
        print("❌ Upload failed: ${response.statusCode}");
        print(responseBody);
        return null;
      }
    }
  }
}


void main() async{
 // await BankStatement.pickFileAndUpload(9);
}
