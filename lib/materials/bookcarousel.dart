import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PopularSlider extends StatefulWidget {
  const PopularSlider({super.key});

  @override
  State<PopularSlider> createState() => _PopularSliderState();
}

class _PopularSliderState extends State<PopularSlider> {
  final List _books = [
    {
      'title': "Holy Mother",
      'cover': "assets/images/novels/hm.jpg",
      'writer': "Akiyoshi Rikako"
    },
    {
      'title': "Your Name",
      'cover': "assets/images/novels/ynharu.jpg",
      'writer': "Shinkai Makoto"
    },
    {
      'title': "Real Face",
      'cover': "assets/images/novels/rf.jpg",
      'writer': "Chinen Mikito"
    },
  ];

  // int _current = 0;
  dynamic _selectedBook = {};
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 450,
          aspectRatio: 16 / 9,
          viewportFraction: 0.55,
          enlargeCenterPage: true,
          autoPlay: true,
          scrollDirection: Axis.horizontal,
        ),
        items: _books.map((book) {
          return Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (_selectedBook == book) {
                      _selectedBook = {};
                    } else {
                      _selectedBook = book;
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(microseconds: 200),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: _selectedBook == book
                        ? Border.all(
                            color: Colors.grey.shade900,
                            width: 3,
                          )
                        : null,
                    boxShadow: _selectedBook == book
                        ? [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ]
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          width: 200,
                          clipBehavior: Clip.hardEdge,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                            book['cover'],
                            width: 100,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['title'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Manrope",
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              book['writer'],
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontFamily: "Manrope",
                                fontSize: 18,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
