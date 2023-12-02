// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:elibrary/modules/user.dart';
import 'package:elibrary/pages/bookshelf.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../materials/bookslider.dart';

class BookDetails extends StatefulWidget {
  final Books book;

  const BookDetails({Key? key, required this.book}) : super(key: key);
  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  Future<void> borrowBook(String bookId) async {
    const String apiUrl =
        'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/borrow.php';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_buku': bookId,
        'id_user': await getUserId(),
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      print('Book has been borrowed successfully');
    } else {
      print(response.body);
      print('Error borrowing book: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Books book = widget.book;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.left_chevron,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .4,
            padding: const EdgeInsets.only(bottom: 20),
            width: double.infinity,
            child: Image.asset('assets/images/novels/${book.cover}'),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.publisher,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Manrope",
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: "Manrope",
                              ),
                            ),
                            Text(
                              "${book.stock} copy(s)",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: "Manrope",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          book.writer,
                          style: const TextStyle(
                            fontFamily: "Manrope",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Kategori : ${book.category}",
                          style: const TextStyle(
                            fontFamily: "Manrope",
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Genre : ${book.genre}",
                          style: const TextStyle(
                            fontFamily: "Manrope",
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Sinopsis : \n${book.description}",
                          style: const TextStyle(
                            fontFamily: "Manrope",
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 65,
        color: Colors.grey.shade900,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: const Icon(
                CupertinoIcons.heart,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: InkWell(
                onTap: () {
                  borrowBook(book.id);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Bookshelf(),
                      ));
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "+ Borrow",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Manrope"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
