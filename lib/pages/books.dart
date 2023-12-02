import 'dart:convert';
import 'package:elibrary/dashboard/appbar.dart';
import 'package:elibrary/dashboard/dashboard.dart';
import 'package:elibrary/pages/bookdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../materials/bookslider.dart';
import '../modules/fetch_books.dart';
import '../modules/user.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          MyAppBar(btitle: "Books"),
          SliverToBoxAdapter(
            child: CardView(),
          ),
        ],
      ),
    );
  }
}

class CardView extends StatefulWidget {
  const CardView({super.key});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  List<Books> _books = [];
  final ApiService _apiService = ApiService(
      'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/books.php');

  @override
  void initState() {
    super.initState();
    fetchBooks(searchKeyword: null);
  }

  void onSearch(String? value) {
    fetchBooks(searchKeyword: value);
  }

  Future<void> fetchBooks({required searchKeyword}) async {
    try {
      final books =
          await _apiService.fetchBooks(searchKeyword: searchKeyword ?? '');
      setState(() {
        _books = books;
      });
    } catch (e) {
      print(e);
    }
  }

  final Map<String, Future<void>> _toggleIconFutures = {};

  late bool isInWishlist = false;
  Future<void> checkWishlistStatus(Books book) async {
    String? userId = await getUserId();
    final response = await http.post(
      Uri.parse('https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/check_wishlist.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_buku': book.id,
        'id_user': userId,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        isInWishlist = true;
      });
    } else {
      setState(() {
        isInWishlist = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          MySearchBar(onSearch: onSearch),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 375,
            ),
            itemCount: _books.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              final book = _books[index];
              // checkWishlistStatus(book);
              return Container(
                width: 250,
                height: 375,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 250,
                            width: 150,
                            clipBehavior: Clip.hardEdge,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/images/novels/${book.cover}',
                              width: 100,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            book.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "Manrope",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            book.writer,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "Manrope",
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FutureBuilder<void>(
                                future: _toggleIconFutures[book.id],
                                builder: (context, snapshot) {
                                  bool isLoading = snapshot.connectionState ==
                                      ConnectionState.waiting;

                                  return IconButton(
                                    icon: Icon(
                                      isInWishlist
                                          ? CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      color: Colors.black,
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            setState(() {
                                              _toggleIconFutures[book.id] =
                                                  _toggleIcon(book);
                                            });
                                          },
                                  );
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookDetails(book: book),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                child: const Text(
                                  "Details",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Manrope",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _toggleIcon(Books book) async {
    final apiUrl = isInWishlist
        ? 'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/removewishlist.php'
        : 'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/addwishlist.php';

    final userId = await getUserId();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_buku': book.id,
        'id_user': userId,
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _toggleIconFutures[book.id] = Future.value();
        isInWishlist = !isInWishlist;
      });
    } else {
      print(response.body);
    }
  }
}
