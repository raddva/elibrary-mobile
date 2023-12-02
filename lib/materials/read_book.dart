import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReadBook extends StatefulWidget {
  final String bookID;

  const ReadBook({Key? key, required this.bookID}) : super(key: key);

  @override
  State<ReadBook> createState() => _ReadBookState();
}

class _ReadBookState extends State<ReadBook> {
  late String pdfUrl = '';

  @override
  void initState() {
    super.initState();
    fetchPdfUrl();
  }

  Future<void> fetchPdfUrl() async {
    final String apiUrl =
        'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/read.php?id=${widget.bookID}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final String file = data[0]['file'];

        if (data.isNotEmpty) {
          setState(() {
            pdfUrl = 'assets/files/$file';
          });
        } else {
          print(response.body);
        }
      } else {
        print(response.body);
      }
    } catch (e) {
      print("ERROR! $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pdfUrl.isNotEmpty
          ? PDFView(
              filePath: pdfUrl,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
