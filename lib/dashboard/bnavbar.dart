import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:elibrary/dashboard/dashboard.dart';
import 'package:elibrary/pages/account.dart';
import 'package:elibrary/pages/books.dart';
import 'package:elibrary/pages/bookshelf.dart';
import 'package:elibrary/pages/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final items = const [
    Icon(
      CupertinoIcons.home,
      color: Colors.white,
    ),
    Icon(
      CupertinoIcons.book,
      color: Colors.white,
    ),
    Icon(
      CupertinoIcons.heart,
      color: Colors.white,
    ),
    Icon(
      CupertinoIcons.time,
      color: Colors.white,
    ),
    Icon(
      CupertinoIcons.person,
      color: Colors.white,
    ),
  ];
  final screens = const [
    Dashboard(),
    BooksPage(),
    WishlistPage(),
    Bookshelf(),
    ProfilePage()
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.black87,
        animationDuration: const Duration(milliseconds: 300),
        items: items,
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            index = _selectedIndex;
          });
        },
      ),
    );
  }
}
