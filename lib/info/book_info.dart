import 'package:flutter/material.dart';
import 'package:flutter_douban/entity/book.dart';
import 'package:flutter_douban/entity/book_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_douban/utils/Utils.dart';
import 'package:flutter_douban/http/HttpManagert.dart' as HttpManager;

class BookInfo extends StatefulWidget {
  BookInfo({@required this.book});

  final Book book;

  @override
  _BookInfoState createState() => new _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {

  BookEntity bookEntity;
  bool isSuccess=true;

  _loadData() {
    String url = widget.book.address;
    HttpManager.get(
      url: url,
      onSend: () {
      setState(() {
        isSuccess=true;

      });
      },
      onSuccess: (String body) {
        bookEntity=new BookEntity.forHtml(body);

      },
      onError: (Object error) {
        setState(() {
          bookEntity=null;
          isSuccess=false;
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(widget.book.name),
      ),
      body: bookEntity==null?_loading():_body(),
    );
  }

  _body() {
    return new Text('你好！！');
  }

  _loading() {
    if(isSuccess){
      return LoadingProgress();
    }else{
      return LoadingError(voidCallback: _loadData,);

    }
  }
}
