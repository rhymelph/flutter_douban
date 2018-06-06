import 'package:flutter/material.dart';
import 'package:flutter_douban/entity/movie.dart';
import 'package:flutter_douban/page/bookPage.dart';
import 'package:flutter_douban/page/moviePage.dart';
import 'package:flutter_douban/idea/donate.dart';
import 'package:flutter_douban/utils/Utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DouBan Power By Flutter',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  // This widget is home page
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //This widget is the home page change state widget
  int index = 0;

  //You change the tabView will select and position change
  _selectPosition(int index) {
    if (this.index == index) return; //if you select the same index will return
    setState(() {
      //update the tabView and TabBarView will change
      this.index = index;
    });
  }

  final List<MovieTab> movieTabs = <MovieTab>[
    MovieTab(Icons.whatshot, '正在热播', '/v2/movie/in_theaters'),
    MovieTab(Icons.compare, '即将上映', '/v2/movie/coming_soon'),
    MovieTab(Icons.vertical_align_top, 'Top250', '/v2/movie/top250'),
  ];
  var moviePage; // a movie page

  var bookPage; // a book age

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: movieTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: _getTitle(),
          bottom: index == 0 ? _movieTab() : null,
        ),
        body: _getBody(),
        drawer:  Drawer(
          elevation: 8.0,
          semanticLabel: '滑动抽屉',
          child: DrawerLayout(),
        ),
        bottomNavigationBar: _getBottomNavigationBar(),
      ),
    );
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

  _forMatchTitle(String data) {
    return Text(data);
  }

  //if you click the movie in bottomNavigationBar,this will happen.
  _movieTab() {
    return TabBar(
        isScrollable: false,
        tabs: movieTabs.map((MovieTab tab) {
          return Tab(
            text: tab.title,
            icon: Icon(tab.iconData),
          );
        }).toList());
  }

  _getBody() {
    switch (index) {
      case 0:
        if (moviePage == null) {
          moviePage = TabBarView(
              children: movieTabs.map((MovieTab tab) {
            if (tab.page == null) {
              tab.offset = 0.0;
              tab.page = MoviePage(tab.address, tab.offset);
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: tab.page,
            );
          }).toList());
        }
        return moviePage;
      case 1:
        if (bookPage == null) {
          double offset=0.0;
          bookPage = BookPage(offset);
        }
        return bookPage;
      case 2:
        return Center(
          child: Text('音乐'),
        );
    }
  }

  _getBottomNavigationBar() {
    return BottomNavigationBar(
        onTap: _selectPosition,
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        iconSize: 24.0,
        items: List<BottomNavigationBarItem>.generate(3, (index) {
          switch (index) {
            case 0:
              return BottomNavigationBarItem(
                  icon: this.index==0?Icon(Icons.movie_filter):Icon(Icons.movie), title: Text('电影'));
            case 1:
              return BottomNavigationBarItem(
                  icon: this.index==1?Icon(Icons.book):Icon(Icons.bookmark), title: Text('图书'));
            case 2:
              return BottomNavigationBarItem(
                  icon: this.index==2?Icon(Icons.music_video):Icon(Icons.music_note), title: Text('音乐'));
          }
        }));
  }
}

// if your slide right this drawerLayout will open
class DrawerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _getHeader(context),
        _getDonateItem(),
        _getAboutItem(),
      ],
    );
  }

  _getHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.grey[400],
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    child: Text('R'),
                  ),
                  Text('Rhyme', style: Theme.of(context).textTheme.title),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                QQCallText(qqNumber: '708959817'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: EmailText(
                    email: 'rhymelph@qq.com',
                    title: '关于flutter_douban应用的一些建议',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getDonateItem() {
    return DonateListTile(
      icon: Icon(Icons.supervisor_account),
      child: Text('支持'),
      authorDes: '给作者买颗七彩棒棒糖怎么样?',
      title: '支持一下',
    );
  }

  _getAboutItem() {
    return AboutListTile(
      icon: Icon(Icons.person),
      child: Text('关于'),
      applicationLegalese: '一个关于豆瓣内容的demo,本项目用于学习研究,如用于商业用途,后果自负',
      applicationName: '豆瓣Flutter版',
      applicationVersion: 'version:1.2',
    );
  }
}
