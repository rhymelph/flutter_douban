import 'package:flutter/material.dart';
import 'package:flutter_douban/entity/movie.dart';
import 'package:flutter_douban/http/HttpManagert.dart' as HttpManager;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_douban/utils/Utils.dart';
import 'package:flutter_douban/info/movie_info.dart';

class MoviePage extends StatefulWidget {
  MoviePage(this.dataPath, this.offset);

  final String dataPath;
  List<Movie> movieList;

  ScrollController controller;
  bool isLoad = false;
  double offset;

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  bool isSuccess = true;

  loadData() async {
    String url = 'https://api.douban.com${widget.dataPath}';
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
            widget.isLoad = true;//加载成功后，将已加载状态设置为true
            widget.movieList = Movie.movieList(json.decode(body));
          });
        },
        onError: (Object e) {
          setState(() {
            widget.movieList = null;
            isSuccess = false;
          });
        });
  }

  //加载中。。。
  _loading() {
    if (isSuccess) {
      return LoadingProgress();
    } else {
      return LoadingError(
        voidCallback: loadData,
      );
    }
  }

  //加载成功显示。。。
  _body() {
    _initController();
    return RefreshIndicator(
      child: ListView.builder(
          controller: widget.controller,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: widget.movieList.length,
          itemBuilder: (context, index) {
            return MovieItem(movie: widget.movieList[index]);
          }),
      onRefresh: _onRefresh,
    );
  }

  //刷新按钮
  Future<Null> _onRefresh() async {
    return Future.delayed(Duration(milliseconds: 1000), () {
      loadData();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.isLoad) {
      loadData();
    }
  }

  //save the listView offset
  void _initController() {
    widget.controller = ScrollController(initialScrollOffset: widget.offset);
    widget.controller.addListener(() {
      widget.offset = widget.controller.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: Container(
        child: widget.movieList == null ? _loading() : _body(),
      ),
    );
    return body;
  }
}

class MovieItem extends StatelessWidget {
  final Movie movie;

  MovieItem({this.movie}) : super(key: new ObjectKey(movie));

  _onClick(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MovieInfoPage(
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
    return GestureDetector(
      onTap: () {
        _onClick(context);
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Image.network(
                movie.images.large,
                width: 100.0,
                height: 150.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.title,
                      ),
                      Text('类型:${_formatGeners()}'),
                      Text('年份:${movie.year}'),
                      Text('主演:${_formatCasts()}'),
                      Text('评分:${movie.rating.stars}'),
                      Text(
                        '${movie.collectCount}人看过',
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
