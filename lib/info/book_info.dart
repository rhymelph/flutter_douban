import 'package:flutter/material.dart';
import 'package:flutter_douban/entity/book.dart';
import 'package:flutter/foundation.dart';
class BookInfo extends StatelessWidget {
  BookInfo({@required this.book });
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(book.name),
      ),
    );
  }
}
