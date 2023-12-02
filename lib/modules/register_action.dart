import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_action.dart';

class RegisterRepository {
  Future<http.Response> register(
      String name, String username, String password, String email) {
    return http.post(
      Uri.parse(
          'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/register.php'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'username': username,
        'email': email,
        'password': password,
      }),
    );
  }
}

class RegisterController {
  final RegisterRepository _repository = RegisterRepository();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  Future<Object> register() async {
    http.Response result = await _repository.register(
      nameController.text,
      usernameController.text,
      passwordController.text,
      emailController.text,
    );

    Map<String, dynamic> myBody = jsonDecode(result.body);
    MyResponse<User> myResponse = MyResponse.fromJson(myBody, User.fromJson);

    debugPrint(myResponse.message);
    if (result.statusCode == 201) {
      return myResponse;
    } else {
      return myResponse;
    }
  }
}
