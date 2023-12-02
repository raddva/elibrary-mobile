import 'dart:convert';
import 'package:http/http.dart' as http;

import '../materials/bookslider.dart';

class ApiService {
  final String apiUrl;

  ApiService(this.apiUrl);

  Future<List<Books>> fetchBooks({String? searchKeyword}) async {
    final response = await http.get(Uri.parse(
        '$apiUrl${searchKeyword != null ? '?find=$searchKeyword' : ''}'));
    // print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('status') && data['status'] == 200) {
        final List<Books> books = [];

        for (int i = 0; data.containsKey(i.toString()); i++) {
          final bookData = data[i.toString()];
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
        return books;
      } else {
        throw Exception('Invalid status code or missing status field');
      }
    } else {
      throw Exception('Failed to load books');
    }
  }
}
