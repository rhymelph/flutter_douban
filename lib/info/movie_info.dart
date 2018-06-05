import 'package:flutter/material.dart';
import 'package:flutter_douban/entity/movie.dart';
import 'package:flutter_douban/http/HttpManagert.dart' as HttpManager;
import 'dart:convert';
import 'package:flutter_douban/entity/movie_info.dart';
import 'package:flutter_douban/utils/Utils.dart';

class MovieInfoPage extends StatefulWidget {
  MovieInfoPage({this.movie});

  final Movie movie;

  @override
  _MovieInfoPageState createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  MovieInfo info;
  bool isSuccess=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  _loadData() async {
    String url = '$movie_page${widget.movie.id}';
    print(url);
    HttpManager.get(url: url,
    onSend: (){
      setState(() {
        isSuccess=true;
      });
    },
    onSuccess: (String body){
      setState(() {
        info = MovieInfo.forJson(json.decode(body));
      });
    },
    onError: (Object error){
      setState(() {
        info=null;
        isSuccess=false;
      });
    });
  }

  String _formatString(List<String> strings) {
    String sb = '';
    for (String item in strings) {
      sb = sb + '$item,';
    }
    return sb.length > 1 ? sb.substring(0, sb.length - 1) : sb;
  }

  _getCastList() {
    //获取演员
    return List<Widget>.generate(info.casts.length, (index) {
      CastsBean castsBean = info.casts[index];
      return Expanded(
          child: Column(
        children: <Widget>[
          Image.network(
            castsBean.avatars == null ? "" : castsBean.avatars.medium,
            width: 100.0,
            height: 100.0,
          ),
          Text(
            castsBean.name,
            maxLines: 1,
          ),
        ],
      ));
    });
  }

  _getDirectors() {
    //获取导演
    return List<Widget>.generate(info.directors.length, (index) {
      DirectorsBean directorsBean = info.directors[index];
      return Expanded(
          child: Column(
        children: <Widget>[
          Image.network(
            directorsBean.avatars == null ? "" : directorsBean.avatars.medium,
            width: 100.0,
            height: 100.0,
          ),
          Text(
            directorsBean.name,
            maxLines: 1,
          ),
        ],
      ));
    });
  }

  _getBody() {
    //获取主要界面
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Image.network(
                info.images.medium,
                width: 150.0,
                height: 200.0,
              ),
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '原名:${info.originalTitle}',
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text('年代:${info.year}'),
                    Text('影评数:${info.reviewsCount}'),
                    Text('评分人数:${info.ratingsCount}'),
                    Text('类型:${_formatString(info.genres)}'),
                    Text('制片国家/地区:${_formatString(info.countries)}'),
                    Text(
                      '${info.wishCount}人想看',
                      style: Theme
                          .of(context)
                          .textTheme
                          .body1
                          .copyWith(color: Colors.red),
                    ),
                    Text(
                      '${info.collectCount}人看过',
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
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '导演:',
                style: Theme
                    .of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.blue),
              )),
        ),
        Row(
          children: _getDirectors(),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '主演:',
                style: Theme
                    .of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.blue),
              )),
        ),
        Row(
          children: _getCastList(),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '介绍:',
                style: Theme
                    .of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.blue),
              )),
        ),
        Container(
            padding: const EdgeInsets.all(4.0), child: Text(info.summary)),
        Divider(
          height: 1.0,
          color: Colors.red,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Text(
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

  _getActions() {
    //获取顶部action,两个按钮
    return info == null
        ? null
        : <Widget>[
            WebIconButton(url: info.mobileUrl),
            ShareIconButton(
              title: info.title,
              url: info.mobileUrl,
              summary: info.summary,
            ),
          ];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: _getActions(),
      ),
      body: info == null ? _getLoading() : _getBody(),
    );
  }
}

const String movie_page = 'https://api.douban.com/v2/movie/subject/';
