// ignore_for_file: avoid_print

import 'package:elibrary/dashboard/appbar.dart';
import 'package:elibrary/modules/user.dart';
import 'package:elibrary/pages/bookdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../materials/bookslider.dart';
import '../materials/read_book.dart';

class Bookshelf extends StatefulWidget {
  const Bookshelf({super.key});

  @override
  State<Bookshelf> createState() => _BookshelfState();
}

class _BookshelfState extends State<Bookshelf> {
  BookshelfOption? selectedValue;
  bool borrowedOptionSelected = false;
  bool historyOptionSelected = false;
  List<Borrow> borrowedBooks = [];
  List<Borrow> history = [];

  @override
  void initState() {
    super.initState();
    selectedValue = BookshelfOption.allOption;
  }

  Future<void> fetchBorrowedBooks() async {
    const String apiUrl =
        'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/currentborrow.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_user': await getUserId(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 200 &&
            responseData['message'] == 'Success') {
          final List<Borrow> books = [];

          for (int i = 0; responseData.containsKey(i.toString()); i++) {
            final bookData = responseData[i.toString()];
            books.add(
              Borrow(
                bookData['id_buku'],
                bookData['judul'],
                'assets/images/novels/${bookData['gambar']}',
                bookData['tenggat'],
              ),
            );
          }

          setState(() {
            borrowedBooks = books;
          });
        } else {
          print('Error fetching borrowed books: ${responseData['message']}');
        }
      } else {
        print('Error fetching borrowed books: ${response.body}');
      }
    } catch (e) {
      print('Error fetching borrowed books: $e');
    }
  }

  Future<void> fetchHistory() async {
    const String apiUrl =
        'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/history.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_user': await getUserId(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 200 &&
            responseData['message'] == 'Success') {
          final List<Borrow> books = [];

          for (int i = 0; responseData.containsKey(i.toString()); i++) {
            final bookData = responseData[i.toString()];
            books.add(
              Borrow(
                bookData['id_buku'],
                bookData['judul'],
                'assets/images/novels/${bookData['gambar']}',
                bookData['tgl_kembali'],
              ),
            );
          }

          setState(() {
            history = books;
          });
        } else {
          print('Error fetching borrow history: ${responseData['message']}');
        }
      } else {
        print('Error fetching borrow history: ${response.body}');
      }
    } catch (e) {
      print('Error fetching borrow history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          const MyAppBar(btitle: "Bookshelf"),
          SliverToBoxAdapter(
            child: BookDropdown(
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                  borrowedOptionSelected =
                      value == BookshelfOption.borrowedOption;
                  historyOptionSelected =
                      value == BookshelfOption.historyOption;
                  if (borrowedOptionSelected) {
                    fetchBorrowedBooks();
                  } else if (historyOptionSelected) {
                    fetchHistory();
                  }
                });
              },
            ),
          ),
          SliverToBoxAdapter(
            child: borrowedOptionSelected
                ? BorrowList(borrowedBooks: borrowedBooks)
                : historyOptionSelected
                    ? HistoryList(history: history)
                    : null,
          ),
        ],
      ),
    );
  }
}

class BookDropdown extends StatefulWidget {
  final BookshelfOption? value;
  final ValueChanged<BookshelfOption?>? onChanged;

  const BookDropdown({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  State<BookDropdown> createState() => _BookDropdownState();
}

class _BookDropdownState extends State<BookDropdown> {
  List<BookshelfOption> options = [
    BookshelfOption.allOption,
    BookshelfOption.borrowedOption,
    BookshelfOption.historyOption
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<BookshelfOption?>(
        value: widget.value,
        onChanged: widget.onChanged,
        underline: const SizedBox(),
        isExpanded: true,
        items: options
            .map<DropdownMenuItem<BookshelfOption?>>((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.option.toString()),
                ))
            .toList(),
      ),
    );
  }
}

class BorrowList extends StatefulWidget {
  final List<Borrow> borrowedBooks;

  const BorrowList({Key? key, required this.borrowedBooks}) : super(key: key);

  @override
  State<BorrowList> createState() => _BorrowListState();
}

class _BorrowListState extends State<BorrowList> {
  bool showReturnButton = true;

  Future<void> returnAllBooks() async {
    const String apiUrl =
        'https://cc52-2001-448a-50a0-9aef-45cc-735f-6459-dda9.ngrok-free.app/api/elibrary/return.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_user': await getUserId(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 200 &&
            responseData['message'] == 'Book has been returned successfully') {
          print('All books returned successfully');
          setState(() {
            widget.borrowedBooks.clear();
            showReturnButton = false;
          });
        } else {
          print('Error returning books: ${responseData['message']}');
        }
      } else {
        print('Error returning books: ${response.body}');
      }
    } catch (e) {
      print('Error returning books: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showReturnButton && widget.borrowedBooks.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              returnAllBooks();
            },
            child: const Text('Return Books'),
          ),
        Container(
          height: 1000,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.borrowedBooks.length,
            itemBuilder: (_, index) {
              final book = widget.borrowedBooks[index];
              return Container(
                height: 110,
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      margin: const EdgeInsets.only(right: 15),
                      child: Image.asset(
                        book.cover,
                        width: 65,
                        height: 95,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "Manrope",
                              ),
                            ),
                            Text(
                              "Valid Until: ${book.date}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: "Manrope",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReadBook(bookID: book.bookId),
                                      ));
                                  // Navigator.pop(context);
                                },
                                child: const Text('Read'),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Icon(
                          CupertinoIcons.arrowtriangle_down_square,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class HistoryList extends StatefulWidget {
  final List<Borrow> history;

  const HistoryList({Key? key, required this.history}) : super(key: key);

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.history.length,
        itemBuilder: (_, index) {
          final book = widget.history[index];
          return Container(
            height: 110,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  margin: const EdgeInsets.only(right: 15),
                  child: Image.asset(
                    book.cover,
                    width: 65,
                    height: 95,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Manrope",
                          ),
                        ),
                        Text(
                          "Returned on ${book.date}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: "Manrope",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                        actions: [
                          CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReadBook(bookID: book.bookId),
                                ),
                              );
                            },
                            child: const Text('Read'),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            // Handle cancel
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Icon(
                      CupertinoIcons.arrowtriangle_down_square,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Borrow {
  final String bookId;
  final String title;
  final String cover;
  final String date;

  Borrow(this.bookId, this.title, this.cover, this.date);
}

class BookshelfOption {
  final int id;
  final String option;

  const BookshelfOption({required this.id, required this.option});

  static const BookshelfOption allOption = BookshelfOption(id: 0, option: "");
  static const BookshelfOption borrowedOption =
      BookshelfOption(id: 1, option: "Borrowed");
  static const BookshelfOption historyOption =
      BookshelfOption(id: 2, option: "History");
}
