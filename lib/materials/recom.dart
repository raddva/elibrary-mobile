import 'package:elibrary/modules/user.dart';
import 'package:elibrary/modules/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modules/fetch_books.dart';
import 'bookslider.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({super.key});

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  List<Books> _books = [];
  final WishlistApi _apiService = WishlistApi(
      'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/wishlist.php');

  Map<String, bool> bookToggleState = {};

  @override
  void initState() {
    super.initState();
    fetchBooks(searchKeyword: null);
  }

  Future<void> fetchBooks({required searchKeyword}) async {
    try {
      final books =
      await _apiService.fetchWishlist(await getUserId());
      setState(() {
        _books = books;
      });

      for (var book in _books) {
        bookToggleState[book.id] = false;
      }
    } catch (e) {
      print(e);
    }
  }

  void _toggleIcon(String bookId) {
    setState(() {
      bookToggleState[bookId] = !bookToggleState[bookId]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
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
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 23,
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
                          IconButton(
                            icon: Icon(
                              bookToggleState[book.id] == true
                                  ? CupertinoIcons.heart
                                  : CupertinoIcons.heart_fill,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _toggleIcon(book.id);
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {},
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
