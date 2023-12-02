import 'package:elibrary/dashboard/appbar.dart';
import 'package:elibrary/materials/recom.dart';
import 'package:elibrary/pages/books.dart';
import 'package:flutter/material.dart';

import '../materials/bookslider.dart';
import '../modules/fetch_books.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          MyAppBar(btitle: "Wishlist"),
          SliverToBoxAdapter(
            child: Recommendation(),
          )
        ],
      ),
    );
  }
}
