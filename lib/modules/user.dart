// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_action.dart';

Future<Profile> fetchUser() async {
  final String? token = await getToken();
  // print('Token: $token');
  final response = await http.get(
      Uri.parse(
          'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/user.php'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
        // "authorization": 'Bearer $token'
      });
  print(response.request!.headers);
  if (response.statusCode == 200) {
    final profile =
        Profile.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

    await saveUserId(profile.idUser);

    return profile;
    // return Profile.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception(response.statusCode);
  }
}

class Profile {
  final String idUser;
  final String? name;
  final String? username;
  final String? email;
  final String? password;

  const Profile(
      {required this.idUser,
      this.name,
      this.username,
      this.email,
      this.password});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      idUser: json['id_user'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
    );
  }
}

Future<void> saveUserId(String idUser) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', idUser);
}

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId') ?? '';
}
