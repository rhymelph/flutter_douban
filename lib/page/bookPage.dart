import 'package:flutter/material.dart';
import 'package:flutter_douban/entity/book.dart';
import 'package:flutter_douban/http/HttpManagert.dart' as HttpManager;
import 'package:flutter_douban/utils/Utils.dart';
import 'package:flutter_douban/info/book_info.dart';

class BookPage extends StatefulWidget {
  BookPage(this.offset);

  List<BookTitleList> bookTitleList;
  bool isLoad = false;
  ScrollController controller;
  double offset;

  @override
  _BookPageState createState() {
    return _BookPageState();
  }
}

class _BookPageState extends State<BookPage> {
  bool isSuccess = true;

  //save the listView offset
  void _initController() {
    widget.controller = ScrollController(initialScrollOffset: widget.offset);
    widget.controller.addListener(() {
      widget.offset = widget.controller.offset;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isLoad) {
      _loadData();
    }
  }

  _loadData() async {
    String url = 'https://book.douban.com/';
    print(url);
    HttpManager.get(
      url: url,
      onSend: () {
        setState(() {
          isSuccess = true;
        });
      },
      onSuccess: (String body) {
        List<BookTitleList> temp = BookTitleList.getFromHtml(body);
        setState(() {
          widget.isLoad = true;
          widget.bookTitleList = temp;
        });
      },
      onError: (Object e) {
        setState(() {
          widget.bookTitleList = null;
          isSuccess = false;
        });
      },
    );
  }

  _getLoading() {
    if (isSuccess) {
      return LoadingProgress();
    } else {
      return LoadingError(
        voidCallback: _loadData,
      );
    }
  }

  _getBody() {
    _initController();
    List<Widget> bookList = [];
    widget.bookTitleList.forEach((list) {
      bookList.add(
        SliverPersistentHeader(
          delegate: BookTitle(
            title: list.title,
          ),
        ),
      );
      bookList.add(SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (
              BuildContext context,
              index,
            ) {
              return BookItem(
                book: list.bookList[index],
              );
            },
            childCount: list.bookList.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.7,
          )));
    });

    return CustomScrollView(
      controller: widget.controller,
      slivers: bookList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: widget.bookTitleList == null ? _getLoading() : _getBody(),
      ),
    );
  }
}

//title项
class BookTitle extends SliverPersistentHeaderDelegate {
  final String title;

  BookTitle({@required this.title, this.height});

  final double height;
  BuildContext context;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    this.context = context;
    return Container(
        child: Center(
            child: Text(
      title ?? '标题',
      style: Theme.of(context).textTheme.title,
    )));
  }

  // TODO: implement maxExtent
  @override
  double get maxExtent => height ?? 60.0;

  // TODO: implement minExtent
  @override
  double get minExtent => height ?? Theme.of(context).textTheme.title.fontSize;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}

//item项
class BookItem extends StatelessWidget {
  final Book book;

  BookItem({this.book}) : super(key: ObjectKey(book));

  _getRatings() {
    int starCount = (book.ratingsValue ~/ 2).toInt();
    var starWidget = new List<Widget>.generate(starCount, (index) {
      return new Icon(
        Icons.star,
        color: Colors.yellow,
        size: 15.0,
      );
    });
    var noStarWidget = new List<Widget>.generate(5 - starCount, (index) {
      return new Icon(
        Icons.star,
        color: Colors.grey,
        size: 15.0,
      );
    });
    starWidget.addAll(noStarWidget);
    starWidget.add(new Text(
      '${book.ratingsValue}',
      style: new TextStyle(color: Colors.white),
    ));
    return starWidget;
  }

  _onclick(BuildContext context) {
    Navigator.push(
        context,
        new PageRouteBuilder(
            pageBuilder: (BuildContext context, _, __) {
              return BookInfo(
                book: book,
              );
            },
            opaque: false,
            transitionDuration: new Duration(milliseconds: 200),
            transitionsBuilder:
                (___, Animation<double> animation, ____, Widget child) {
              return new FadeTransition(
                opacity: animation,
                child: new ScaleTransition(
                  scale: new Tween<double>(begin: 0.5, end: 1.0)
                      .animate(animation),
//                  position: new Tween<Offset>(begin: const Offset(-1.0, 0.0),end: Offset.zero)
//                      .animate(animation),
                  child: child,
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: () {
        _onclick(context);
      },
      child: Card(
        child: Stack(
          children: <Widget>[
            Image.network(
              book.imageAddress,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                center: const Alignment(0.0, -0.5),
                colors: <Color>[
                  const Color(0x00000000),
                  const Color(0x70000000),
                ],
                radius: 0.60,
                stops: <double>[0.3, 1.0],
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      book.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Text(
                      book.author,
                      style: Theme
                          .of(context)
                          .textTheme
                          .subhead
                          .copyWith(color: Colors.white, fontSize: 10.0),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _getRatings(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
