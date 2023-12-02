import 'package:elibrary/pages/bookdetails.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../modules/fetch_books.dart';

class BookSlider extends StatefulWidget {
  const BookSlider({super.key});

  @override
  State<BookSlider> createState() => _BookSliderState();
}

class _BookSliderState extends State<BookSlider> {
  List<Books> _books = [];
  final ApiService _apiService = ApiService(
      'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/books.php');

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final books = await _apiService.fetchBooks();
      setState(() {
        _books = books;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 280,
        child: ScrollSnapList(
          itemBuilder: _buildListItem,
          itemCount: _books.length,
          itemSize: 150,
          onItemFocus: (index) {},
          dynamicItemSize: true,
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    Books books = _books[index];
    return GestureDetector(
      onTap: () {
        // Navigate to the detail page here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetails(book: books),
          ),
        );
      },
      child: SizedBox(
        width: 150,
        height: 350,
        child: Card(
          elevation: 12,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/novels/${books.cover}',
                  fit: BoxFit.cover,
                  width: 150,
                  height: 215,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    books.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    books.writer,
                    style: const TextStyle(
                      fontFamily: "Manrope",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Books {
  final String id;
  final String title;
  final String cover;
  final String writer;
  final String publisher;
  final String stock;
  final String category;
  final String description;
  final String genre;
  final String file;

  Books(this.id, this.title, this.cover, this.writer, this.publisher,
      this.stock, this.category, this.description, this.genre, this.file);

  get id_buku => null;
}
