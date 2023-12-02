import 'package:elibrary/pages/account.dart';
import 'package:elibrary/pages/books.dart';
import 'package:elibrary/dashboard/dashboard.dart';
import 'package:elibrary/pages/bookshelf.dart';
import 'package:elibrary/pages/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MyDrawer(),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Widget page = const Dashboard();
  final _drawerController = ZoomDrawerController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: MenuPage(
        onPageChanged: (a) {
          setState(() {
            page = a;
          });
        },
      ),
      mainScreen: page,
      showShadow: true,
      borderRadius: 24.0,
      style: DrawerStyle.defaultStyle,
      drawerShadowsBackgroundColor: Colors.transparent,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuBackgroundColor: Colors.grey.shade900,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
      controller: _drawerController,
    );
  }
}

class MenuPage extends StatelessWidget {
  MenuPage({super.key, required this.onPageChanged});
  final Function(Widget) onPageChanged;
  final List<ListItems> drawerItems = [
    ListItems(
        const Icon(CupertinoIcons.home),
        const Text("Home", style: TextStyle(fontFamily: "Manrope")),
        const Dashboard()),
    ListItems(
        const Icon(CupertinoIcons.book),
        const Text("Books", style: TextStyle(fontFamily: "Manrope")),
        const BooksPage()),
    ListItems(
        const Icon(CupertinoIcons.heart),
        const Text("Wishlist", style: TextStyle(fontFamily: "Manrope")),
        const WishlistPage()),
    ListItems(
        const Icon(CupertinoIcons.chart_bar_alt_fill),
        const Text("Bookshelf", style: TextStyle(fontFamily: "Manrope")),
        const Bookshelf()),
    ListItems(
        const Icon(CupertinoIcons.person_alt_circle),
        const Text("Account", style: TextStyle(fontFamily: "Manrope")),
        const AccountPage()),
    ListItems(const Icon(CupertinoIcons.square_arrow_left),
        const Text("Logout", style: TextStyle(fontFamily: "Manrope")), null),
  ];

  void handleLogout(BuildContext context) async {
    Future<void> clearToken() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
    }

    Future<void> clearID() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('userId');
    }

    void confirmLogout() {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('No'),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  await clearToken();
                  await clearID();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const App(),
                    ),
                  );
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );
    }

    confirmLogout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Theme(
        data: ThemeData.dark(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: drawerItems
              .map((e) => ListTile(
                    onTap: () {
                      if (e.page != null) {
                        onPageChanged(e.page!);
                      } else {
                        handleLogout(context);
                      }
                      onPageChanged(e.page!);
                    },
                    title: e.title,
                    leading: e.icon,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class ListItems {
  final Icon icon;
  final Text title;
  final Widget? page;
  ListItems(this.icon, this.title, this.page);
}
