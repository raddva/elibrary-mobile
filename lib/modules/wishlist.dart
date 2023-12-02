import 'dart:convert';
import 'package:elibrary/modules/user.dart';
import 'package:http/http.dart' as http;

import '../materials/bookslider.dart';

class WishlistApi {
  final String apiUrl;

  WishlistApi(this.apiUrl);

  Future<List<Books>> fetchWishlist(String? id) async {
    final Uri uri = Uri.parse(apiUrl);

    final response = await http.post(
        uri,
        headers: <String, String>{
      'Content-Type': "application/json; charset=UTF-8"
      },
      body: jsonEncode(
        <String, String?>{
          'id_user': id,
        },
      )
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('Response Body: ${response.body}');
      if (data.isNotEmpty && response.statusCode == 200) {
        final List<Books> books = [];

        data.forEach((key, bookData) {
          // Skip the 'status' key
          if (key != 'status') {
            final book = Books(
              bookData['id_buku'],
              bookData['judul'],
              bookData['gambar'],
              bookData['penulis'],
              bookData['penerbit'],
              bookData['stok'],
              bookData['kategori'],
              bookData['deskripsi'],
              bookData['genre'],
              bookData['file'],
            );
            books.add(book);
          }
        });
        return books;
      } else {
        throw Exception('Invalid status code or missing status field');
      }
    } else {
      throw Exception('Failed to load books');
    }
  }
}
