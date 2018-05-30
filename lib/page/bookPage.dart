import 'package:flutter/material.dart';
import 'package:flutter_douban/entity/book.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_douban/utils/Utils.dart';

class BookPage extends StatefulWidget {
  List<BookTitleList> bookTitleList;

  @override
  _BookPageState createState() => new _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    String dataURL = 'https://book.douban.com/';
    print(dataURL);
    http.Response response = await http.get(dataURL);
    String body = response.body;
    List<BookTitleList> temp = BookTitleList.getFromHtml(body);
    setState(() {
      widget.bookTitleList = temp;
    });
//    setState(() {
//      widget.content = Movie.MovieList(json.decode(response.body));
//    });
  }
  _getCount(){
    int count=0;
    for(BookTitleList list in widget.bookTitleList){
      count= count+list.bookList.length;
    }
    return count;
  }

  _getbody() {
    int index=0;
    int length=0;
    return new GridView.builder(
        shrinkWrap: true,
        itemCount: _getCount(),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.7),
        itemBuilder: (context, index2) {
          if(index2>widget.bookTitleList[index].bookList.length){
            length =length+widget.bookTitleList[index].bookList.length;
            index++;
          }
          return new BookItem(
            book: widget.bookTitleList[index].bookList[index2-length],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        child:
            widget.bookTitleList == null ? new LoadingProgress() : _getbody(),
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final Book book;

  const BookItem({Key key, this.book}) : super(key: key);

  _getRatings() {
    int star_count = (book.ratings_value ~/ 2).toInt();
    var star_widget = new List<Widget>.generate(star_count, (index) {
      return new Icon(
        Icons.star,
        color: Colors.yellow,
        size: 15.0,
      );
    });
    var nostar_widget = new List<Widget>.generate(5 - star_count, (index) {
      return new Icon(
        Icons.star,
        color: Colors.grey,
        size: 15.0,
      );
    });

    star_widget.addAll(nostar_widget);
    star_widget.add(new Text(
      '${book.ratings_value}',
      style: new TextStyle(color: Colors.white),
    ));
    return star_widget;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Card(
      child: new Stack(
        children: <Widget>[
          new Image.network(
            book.image_address,
          ),
          new DecoratedBox(
            decoration: new BoxDecoration(
                gradient: new RadialGradient(
              center: const Alignment(0.0, -0.5),
              colors: <Color>[
                const Color(0x00000000),
                const Color(0x70000000),
              ],
              radius: 0.60,
              stops: <double>[0.3, 1.0],
            )),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Center(
                  child: new Text(
                    book.name,
                    style: Theme
                        .of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ),
                ),
                new Center(
                  child: new Text(
                    book.author,
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: Colors.white, fontSize: 10.0),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _getRatings(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
