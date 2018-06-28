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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  //加载数据...
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
      key: scaffoldKey,
      body: bookEntity == null ? _loading() : _body(),
      floatingActionButton: bookEntity == null
          ? null
          : bookEntity.commentList == null
              ? null
              : FloatingActionButton(
                  child: Icon(Icons.comment),
                  onPressed: _showComment,
                ),
    );
  }

  _showComment() {
    scaffoldKey.currentState.showBottomSheet((context) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return ListView.builder(
              itemCount: bookEntity.commentList.length,
              itemBuilder: (context, index) {
                Comment comment = bookEntity.commentList[index];
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 0.0),
                    child: _listTitleComment(comment),
                  );
                }
                return _listTitleComment(comment);
              });
        },
      );
    });
  }

  _listTitleComment(Comment comment) {
    return ListTile(
      dense: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getCommentTop(comment),
      ),
      subtitle: Column(
        children: <Widget>[
          WebText(
            text: comment.title,
            url: comment.address,
          ),
          Text(
            comment.shortContent,
            style: Theme.of(context).textTheme.body1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.green,
              height: 1.0,
            ),
          )
        ],
      ),
    );
  }

  _getCommentTop(Comment comment) {
    List<Widget> commentWidget = [];
    commentWidget.add(new Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.green,
          // ignore: conflicting_dart_import
          child: Text(comment.name[0]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            comment.name,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Chip(
              backgroundColor: Colors.white,
              label: Text(comment.ratingDes ?? ''),
            ),
          ),
        )
      ],
    ));
    if(comment.ratingsValue!=null){
      int startCount = (double.parse(comment.ratingsValue) ~/ 10).toInt();
      List<Widget> starWidget = new List<Widget>.generate(startCount, (index) {
        return new Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20.0,
        );
      });
      starWidget.addAll(new List<Widget>.generate(5 - startCount, (index) {
        return new Icon(
          Icons.star,
          size: 20.0,
        );
      }));
      commentWidget.add(new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: starWidget,
        ),
      ));
    }
    commentWidget.add(new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Text(comment.time),
    ));
    return commentWidget;
  }

  _body() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
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
                  child: Center(child: Text(bookEntity.introContent))),
              _readButton(),
              TitleItem('作者简介'),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text(bookEntity.introAuthor))),
              TitleItem('目录'),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: _formatTextBlack(bookEntity.indent))),
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

  //顶部内容
  _getTop() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // ignore: conflicting_dart_import
        Image.network(
          widget.book.imageAddress,
          fit: BoxFit.fitWidth,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getBookInfo(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //试读button
  _readButton() {
    if (bookEntity.readAddress != null) {
      return Container(
        child: WebButton(
          text: '立即试读',
          url: bookEntity.readAddress,
          errorTip: '试读失败',
        ),
      );
    } else {
      return Container(
        child: null,
      );
    }
  }

  //图书信息
  _getBookInfo() {
    List<Widget> widgets = [];
    if (widget.book.name != null) {
      widgets.add(Text(
        '书名：${widget.book.name}',
        overflow: TextOverflow.ellipsis,
        style:
            Theme.of(context).textTheme.headline.copyWith(color: Colors.white),
      ));
    }
    if (bookEntity.originTitle != null) {
      widgets.add(Text(
        bookEntity.originTitle ?? '',
        overflow: TextOverflow.ellipsis,
        style: Theme
            .of(context)
            .textTheme
            .subhead
            .copyWith(color: Colors.white, fontStyle: FontStyle.italic),
      ));
    }
    widgets.add(Row(
      children: _getRatings(),
    ));
    if (bookEntity.publish != null) {
      widgets.add(_formatTextWhile(bookEntity.publish ?? ''));
    }
    if (bookEntity.author != null) {
      widgets.add(_formatTextWhile(bookEntity.author ?? ''));
    }
    if (bookEntity.authorDes != null) {
      widgets.add(_formatTextWhile(bookEntity.authorDes ?? ''));
    }
    if (bookEntity.publishYear != null) {
      widgets.add(_formatTextWhile(bookEntity.publishYear ?? ''));
    }
    if (bookEntity.pageCount != null) {
      widgets.add(_formatTextWhile(bookEntity.pageCount ?? ''));
    }
    if (bookEntity.price != null) {
      widgets.add(_formatTextWhile(bookEntity.price ?? ''));
    }
    if (bookEntity.binding != null) {
      widgets.add(_formatTextWhile(bookEntity.binding ?? ''));
    }
    if (bookEntity.series != null) {
      widgets.add(_formatTextWhile(bookEntity.series ?? ''));
    }

    if (bookEntity.ISBM != null) {
      widgets.add(_formatTextWhile(bookEntity.ISBM ?? ''));
    }

    return widgets;
  }

  //标签
  _getTags() {
    return new List.generate(bookEntity.tags.length, (index) {
      return new Padding(
        padding: const EdgeInsets.all(2.0),
        child: Chip(
          label: Text(bookEntity.tags[index]),
          labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      );
    });
  }

  //获取评价
  _getRatings() {
    List<Widget> ratingsWidgets = [];
    ratingsWidgets.add(_formatTextWhile('评价：'));
    if (bookEntity.ratingValue == null || bookEntity.ratingValue.isEmpty) {
      ratingsWidgets.add(Text(
        '暂无评价',
        style: Theme.of(context).textTheme.body1.copyWith(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
      ));
    } else {
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
      ratingsWidgets.addAll(starWidget);
      ratingsWidgets.add(Text(
        '${bookEntity.ratingCount}人评分',
        style: Theme
            .of(context)
            .textTheme
            .body1
            .copyWith(color: Colors.white, fontStyle: FontStyle.italic),
      ));
    }
    return ratingsWidgets;
  }

  //返回黑色字体text
  _formatTextBlack(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.subhead,
    );
  }

  //返回白色字体text
  _formatTextWhile(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white),
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
