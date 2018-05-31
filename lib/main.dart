import 'package:flutter/material.dart';
import 'package:flutter_douban/page/bookPage.dart';
import 'package:flutter_douban/page/moviePage.dart';
import 'package:flutter_douban/idea/donate.dart';
import 'package:flutter_douban/utils/Utils.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int index = 0;


  _selectPosition(int index) {
    if (this.index == index) return;
    setState(() {
      this.index = index;
    });
  }

  var moviePage;
  var bookPage;

  _getbody() {
    switch (index) {
      case 0:
        if (moviePage == null) {
          moviePage = new TabBarView(
              children: movie_tabs.map((MovieTab tab){
                if(tab.page==null){
                  tab.offset=0.0;
                  tab.page=new MoviePage(tab.address,tab.offset);
                }
                return new Padding(padding: const EdgeInsets.all(8.0),
                child: tab.page,);
              }).toList());
        }
        return moviePage;
      case 1:
        if(bookPage==null){
          bookPage=new BookPage();

        }
        return bookPage;
      case 2:
        return new Center(
          child: new Text('音乐'),
        );
    }
  }

  _getTitle() {
    switch (index) {
      case 0:
        return _forMatchTitle('电影');
      case 1:
        return _forMatchTitle('图书');
      case 2:
        return _forMatchTitle('音乐');
    }
  }

  //formatch标题
  _forMatchTitle(String data){
    return new Text(data);

  }
  
  _MovieTab(){
    return new TabBar(
        isScrollable: false
        ,tabs:movie_tabs.map((MovieTab tab){
          return new Tab(
            text: tab.title,
            icon: new Icon(tab.iconData),
          );
        }).toList());

  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(

      length: movie_tabs.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: _getTitle(),
          bottom: index==0?_MovieTab():null,
        ),
        body: _getbody(),
        drawer: new Drawer(
          elevation: 8.0,
          semanticLabel: '滑动抽屉',
          child: new DrawerLayout(),
        ),
        bottomNavigationBar: new BottomNavigationBar(
            onTap: _selectPosition,
            currentIndex: index,
            type: BottomNavigationBarType.fixed,
            iconSize: 24.0,
            items: new List<BottomNavigationBarItem>.generate(3, (index) {
              switch (index) {
                case 0:
                  return new BottomNavigationBarItem(
                      icon: new Icon(Icons.movie), title: new Text('电影'));
                case 1:
                  return new BottomNavigationBarItem(
                      icon: new Icon(Icons.book), title: new Text('图书'));
                case 2:
                  return new BottomNavigationBarItem(
                      icon: new Icon(Icons.music_note), title: new Text('音乐'));
              }
            })),
      ),
    );
  }
}

class DrawerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new DrawerHeader(
          decoration: new BoxDecoration(
            color: Colors.grey[400],
          ),
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new Align(
                  alignment: Alignment.bottomCenter,
                  child: new Column(
                    children: <Widget>[
                      new CircleAvatar(
                        child: new Text('R'),
                      ),
                      new Text('Rhyme',style: Theme.of(context).textTheme.title),
                    ],
                  ),
                ),
              ),
              new Align(
                alignment: Alignment.bottomLeft,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new QQCallText(qqNumber: '708959817'),
                    new Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: new EmailText(email: 'rhymelph@qq.com',title: '关于flutter_douban应用的一些建议',),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        new DonateListTile(
          icon: new Icon(Icons.supervisor_account),
          child: new Text('支持'),
          authorDes: '给作者买颗七彩棒棒糖怎么样?',
          title: '支持一下',
        ),
        new AboutListTile(
          icon: new Icon(Icons.person),
          child: new Text('关于'),
          applicationLegalese: '一个关于豆瓣内容的demo,本项目用于学习研究,如用于商业用途,后果自负',
          applicationName: '豆瓣Flutter版',
          applicationVersion: 'version:1.1-debug',
        ),
      ],
    );
  }
}

final List<MovieTab> movie_tabs=<MovieTab>[
    new MovieTab(Icons.whatshot,'正在热播', '/v2/movie/in_theaters'),
    new MovieTab(Icons.compare,'即将上映', '/v2/movie/coming_soon'),
    new MovieTab(Icons.vertical_align_top,'Top250', '/v2/movie/top250'),
];

class MovieTab {
  final IconData iconData;
  final String title;
  final String address;
   Widget page;
   double offset;

  MovieTab(this.iconData,this.title, this.address);
}


