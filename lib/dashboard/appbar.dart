import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MyAppBar extends StatefulWidget {
  final String btitle;
  const MyAppBar({super.key, required this.btitle});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => ZoomDrawer.of(context)!.toggle(),
        icon: const Icon(CupertinoIcons.line_horizontal_3),
      ),
      title: Text(
        widget.btitle,
        style: const TextStyle(fontFamily: "Manrope"),
      ),
      centerTitle: true,
    );
  }
}
// class MyAppBar extends StatelessWidget {
//   const MyAppBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar.large(
//       backgroundColor: Colors.transparent,
//       leading: IconButton(
//         onPressed: () => ZoomDrawer.of(context)!.toggle(),
//         icon: const Icon(CupertinoIcons.line_horizontal_3),
//       ),
//       title: const Text(
//         "Dashboard",
//         style: TextStyle(fontFamily: "Manrope"),
//       ),
//       centerTitle: true,
//     );
//   }
// }
