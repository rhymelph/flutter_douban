import 'dart:ui';

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
  bool isSuccess = true;

  _loadData() {
    String url = widget.book.address;
    print(url);
    HttpManager.get(
      url: url,
      onSend: () {
        setState(() {
          isSuccess = true;
        });
      },
      onSuccess: (String body) {
        setState(() {
          bookEntity = new BookEntity.forHtml(body);
        });
      },
      onError: (Object error) {
        setState(() {
          bookEntity = null;
          isSuccess = false;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bookEntity == null ? _loading() : _body(),
    );
  }

  _getTags() {
    return new List.generate(bookEntity.tags.length, (index) {
      return new Padding(
        padding: const EdgeInsets.all(3.0),
        child: Chip(
          label: Text(bookEntity.tags[index]),
          labelPadding: const EdgeInsets.all(2.0),
        ),
      );
    });
  }

  _getBookInfo() {
    List<Widget> widgets = [];
    if (bookEntity.origin_title != null) {
      widgets.add(Text(
        bookEntity.origin_title ?? '',
        style:
            Theme.of(context).textTheme.headline.copyWith(color: Colors.white),
      ));
    }
    if (bookEntity.publish != null) {
      widgets.add(_formatTextWhile(bookEntity.publish ?? ''));
    }
    if (bookEntity.author != null) {
      widgets.add(_formatTextWhile(bookEntity.author ?? ''));
    }
    if (bookEntity.author_des != null) {
      widgets.add(_formatTextWhile(bookEntity.author_des ?? ''));
    }
    if (bookEntity.publish_year != null) {
      widgets.add(_formatTextWhile(bookEntity.publish_year ?? ''));
    }
    if (bookEntity.page_count != null) {
      widgets.add(_formatTextWhile(bookEntity.page_count ?? ''));
    }
    if (bookEntity.price != null) {
      widgets.add(_formatTextWhile(bookEntity.price ?? ''));
    }
    if (bookEntity.Binding != null) {
      widgets.add(_formatTextWhile(bookEntity.Binding ?? ''));
    }
    if (bookEntity.series != null) {
      widgets.add(_formatTextWhile(bookEntity.series ?? ''));
    }

    if (bookEntity.ISBM != null) {
      widgets.add(_formatTextWhile(bookEntity.ISBM ?? ''));
    }
    return widgets;
  }

  _getTop() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // ignore: conflicting_dart_import
        Image.network(
          widget.book.imageAddress,
          fit: BoxFit.fitWidth,
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: new SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(const Radius.circular(16.0)),
                  color: Colors.grey.shade600.withOpacity(0.5)),
              child: new Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _getBookInfo(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _getRatings(),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  _getRatings() {
    if (bookEntity.ratingValue == null) {
      return Text(
        '暂无评价',
        style: Theme
            .of(context)
            .textTheme
            .body1
            .copyWith(color: Colors.red, fontStyle: FontStyle.italic),
      );
    }
    int startCount = (double.parse(bookEntity.ratingValue) ~/ 2).toInt();
    List<Widget> starWidget = new List<Widget>.generate(startCount, (index) {
      return new Icon(
        Icons.star,
        color: Colors.yellow,
        size: 15.0,
      );
    });
    starWidget.addAll(new List<Widget>.generate(5 - startCount, (index) {
      return new Icon(
        Icons.star,
        size: 15.0,
      );
    }));
    return new Column(
      children: <Widget>[
        _formatTextWhile('评分'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: starWidget,
        ),
        _formatTextWhile('${bookEntity.ratingCount}人评分'),
      ],
    );
  }

  _formatText(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.subhead,
    );
  }

  _formatTextWhile(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white),
    );
  }

  _body() {
    return new CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: new Text(widget.book.name),
          pinned: false,
          flexibleSpace: _getTop(),
          expandedHeight: 360.0,
          snap: false,
        ),
        SliverList(
          delegate: new SliverChildListDelegate(
            <Widget>[
              TitleItem('内容简介'),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text(bookEntity.intro_content))),
              TitleItem('作者简介'),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text(bookEntity.intro_author))),
              TitleItem('目录'),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: _formatText(bookEntity.indent))),
              TitleItem('标签'),
              Wrap(
                children: _getTags(),
              ),
            ],
          ),
        )
      ],
    );
  }

  _loading() {
    if (isSuccess) {
      return LoadingProgress();
    } else {
      return LoadingError(
        voidCallback: _loadData,
      );
    }
  }
}

class TitleItem extends StatelessWidget {
  TitleItem(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme
              .of(context)
              .textTheme
              .headline
              .copyWith(color: Colors.blue, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
