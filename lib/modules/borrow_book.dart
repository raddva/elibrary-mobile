import 'dart:convert';
import 'package:elibrary/modules/user.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> borrowBook(String bookId) async {
  const String apiUrl =
      'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/borrow.php'; // Replace with your PHP API URL
  var user = getUserId();
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'id_buku': bookId,
      'id_user': user,
    }),
  );

  if (response.statusCode == 200) {
    return {'success': true, 'message': 'Book has been borrowed successfully'};
  } else {
    return {
      'success': false,
      'message': 'Error borrowing book: ${response.body}',
    };
  }
}
