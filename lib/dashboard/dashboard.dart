import 'package:elibrary/dashboard/appbar.dart';
import 'package:elibrary/materials/bookslider.dart';
import 'package:elibrary/materials/carousel.dart';
import 'package:elibrary/materials/recom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          MyAppBar(btitle: "Dashboard"),
          SliverToBoxAdapter(child: Carousel()),
          // SliverToBoxAdapter(child: MySearchBar()),
          SliverToBoxAdapter(child: Headings(heading: "Popular Books")),
          BookSlider(),
          SliverToBoxAdapter(child: Headings(heading: "Our Recommendations")),
          SliverToBoxAdapter(child: Recommendation()),
        ],
      ),
    );
  }
}

class MySearchBar extends StatefulWidget {
  final Function(String?) onSearch; // Define the onSearch callback

  const MySearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<MySearchBar> createState() => _MySearchBarState();

}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: CupertinoSearchTextField(
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Manrope",
          ),
          controller: _textEditingController,
          onChanged: (value) async {
            widget.onSearch(value.isNotEmpty ? value : null); // Call the callback function
          },
        ),
      ),
    );
  }
}


class Headings extends StatefulWidget {
  final String heading;

  const Headings({super.key, required this.heading});

  @override
  State<Headings> createState() => _HeadingsState();
}

class _HeadingsState extends State<Headings> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
        const SizedBox(height: 25),
        Text(
          widget.heading,
          style: const TextStyle(
            fontFamily: "Manrope",
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 15)
      ],
    ));
  }
}


// class ProductCards extends StatelessWidget {
//   const ProductCards({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate(
//         (BuildContext context, int index) {
//           return Padding(
//             padding: const EdgeInsets.only(
//               left: 10,
//               bottom: 20,
//               right: 10,
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               height: 200,
//               width: MediaQuery.of(context).size.width,
//             ),
//           );
//         },
//         childCount: 12,
//       ),
//     );
//   }
// }
