import 'package:flutter/material.dart';
import 'package:flutter_douban/entity/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_douban/utils/Utils.dart';
import 'package:flutter_douban/info/movie_info.dart';

class MoviePage extends StatefulWidget {
  MoviePage(this.dataPath);

  final String dataPath;
  List<Movie> content;

  @override
  _MoviePageState createState() => new _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  loadData() async {
    String dataURL = 'https://api.douban.com${widget.dataPath}';
    print(dataURL);
    http.Response response = await http.get(dataURL);
    setState(() {
      widget.content = Movie.MovieList(json.decode(response.body));
    });
  }

  //刷新按钮
  Future<Null> _onRefresh() async {
    return new Future.delayed(new Duration(milliseconds: 1000), () {
        loadData();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        child: widget.content != null
            ? new RefreshIndicator(
                child: new ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: widget.content.length,
                    itemBuilder: (context, index) {
                      return new MovieItem(movie: widget.content[index]);
                    }),
                onRefresh: _onRefresh,
              )
            : new LoadingProgress(),
      ),
    );
  }
}

class MovieItem extends StatelessWidget {
  final Movie movie;

  MovieItem({this.movie});

  _onClick(BuildContext context) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new MovieInfoPage(
                  movie: movie,
                )));
  }

  String _formatGeners() {
    String sb = '';
    for (String item in movie.genres) {
      sb = sb + '$item ';
    }
    return sb;
  }

  String _formatCasts() {
    String sb = '';
    for (CastsBean item in movie.casts) {
      sb = sb + '${item.name},';
    }

    return sb.length > 1 ? sb.substring(0, sb.length - 1) : sb;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: () {
        _onClick(context);
      },
      child: new Card(
        child: new Container(
          padding: const EdgeInsets.all(8.0),
          child: new Row(
            children: <Widget>[
              new Image.network(
                movie.images.large,
                width: 100.0,
                height: 150.0,
              ),
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        movie.title,
                        style: Theme.of(context).textTheme.title,
                      ),
                      new Text('类型:${_formatGeners()}'),
                      new Text('年份:${movie.year}'),
                      new Text('主演:${_formatCasts()}'),
                      new Text('评分:${movie.rating.stars}'),
                      new Text(
                        '${movie.collect_count}人看过',
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1
                            .copyWith(color: Colors.red),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
