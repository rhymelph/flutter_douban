import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_douban/entity/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_douban/entity/movie_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_douban/utils/Utils.dart';
class MovieInfoPage extends StatefulWidget {
  MovieInfoPage({this.movie});

  final Movie movie;

  @override
  _MovieInfoPageState createState() => new _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  MovieInfo info;

  @override
  void initState() {
    // TODO: implement initState
    _initData();
    super.initState();
  }

  _showProgress() {
    return new Center(child: new CircularProgressIndicator());
  }

  _initData() async {
    String infoUrl = '$movie_page${widget.movie.id}';
    print(infoUrl);
    http.Response info_res = await http.get(infoUrl);

    //权限问题,影评暂时不获取
//    String commentUrl='$movie_page${widget.movie.id}/reviews';
//
//    http.Response comment_res=await http.get(commentUrl);
//    print(comment_res.body);

    setState(() {
      info = new MovieInfo.forJson(json.decode(info_res.body));
    });
  }

  String _formatString(List<String> strings) {
    String sb = '';
    for (String item in strings) {
      sb = sb + '${item},';
    }
    return sb.length > 1 ? sb.substring(0, sb.length - 1) : sb;
  }

  _getCastList() {
    return new List<Widget>.generate(info.casts.length, (index) {
      CastsBean castsBean = info.casts[index];
      return new Expanded(
          child: new Column(
        children: <Widget>[
          new Image.network(
            castsBean.avatars == null ? "" : castsBean.avatars.medium,
            width: 100.0,
            height: 100.0,
          ),
          new Text(castsBean.name),
        ],
      ));
    });
  }

  _getComment() {}

  _getDirectors() {
    return new List<Widget>.generate(info.directors.length, (index) {
      DirectorsBean directorsBean = info.directors[index];
      return new Expanded(
          child: new Column(
        children: <Widget>[
          new Image.network(
            directorsBean.avatars == null ? "" : directorsBean.avatars.medium,
            width: 100.0,
            height: 100.0,
          ),
          new Text(directorsBean.name),
        ],
      ));
    });
  }

  _getBody() {
    return new ListView(
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.all(8.0),
          child: new Row(
            children: <Widget>[
              new Image.network(
                info.images.medium,
                width: 150.0,
                height: 200.0,
              ),
              new Expanded(
                  child: new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      '原名:${info.original_title}',
                      style: Theme.of(context).textTheme.title,
                    ),
                    new Text('年代:${info.year}'),
                    new Text('影评数:${info.reviews_count}'),
                    new Text('评分人数:${info.ratings_count}'),
                    new Text('类型:${_formatString(info.genres)}'),
                    new Text('制片国家/地区:${_formatString(info.countries)}'),
                    new Text(
                      '${info.wish_count}人想看',
                      style: Theme
                          .of(context)
                          .textTheme
                          .body1
                          .copyWith(color: Colors.red),
                    ),
                    new Text(
                      '${info.collect_count}人看过',
                      style: Theme
                          .of(context)
                          .textTheme
                          .body1
                          .copyWith(color: Colors.red),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
        new Align(
          alignment: Alignment.topLeft,
          child: new Container(
              padding: const EdgeInsets.all(4.0),
              child: new Text(
                '导演:',
                style: Theme
                    .of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.blue),
              )),
        ),
        new Row(
          children: _getDirectors(),
        ),
        new Align(
          alignment: Alignment.topLeft,
          child: new Container(
              padding: const EdgeInsets.all(4.0),
              child: new Text(
                '主演:',
                style: Theme
                    .of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.blue),
              )),
        ),
        new Row(
          children: _getCastList(),
        ),
        new Align(
          alignment: Alignment.topLeft,
          child: new Container(
              padding: const EdgeInsets.all(4.0),
              child: new Text(
                '介绍:',
                style: Theme
                    .of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.blue),
              )),
        ),
        new Container(
            padding: const EdgeInsets.all(4.0), child: new Text(info.summary)),
        new Divider(
          height: 1.0,
          color: Colors.red,
        ),
        new Align(
          alignment: Alignment.topLeft,
          child: new Container(
              padding: const EdgeInsets.all(4.0),
              child: new Text(
                '影评:(豆瓣api无权限,所以没有)',
                style: Theme
                    .of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.blue),
              )),
        ),
      ],
    );
  }

  _getActions(){
    return info==null?null:
        <Widget>[
          new WebIconButton(url: info.mobile_url),
          new ShareIconButton(
            title: info.title,
            url: info.mobile_url,
            summary: info.summary,
          ),
        ];

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.movie.title),
        actions: _getActions(),
      ),
      body: info == null ? _showProgress() : _getBody(),
    );
  }
}

const String movie_page = 'https://api.douban.com/v2/movie/subject/';
