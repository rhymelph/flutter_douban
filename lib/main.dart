import 'package:flutter/material.dart';
import 'package:flutter_douban/entity/movie.dart';
import 'package:flutter_douban/page/bookPage.dart';
import 'package:flutter_douban/page/moviePage.dart';
import 'package:flutter_douban/idea/donate.dart';
import 'package:flutter_douban/utils/Utils.dart';
import 'value.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Value.appName,
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
    MovieTab(Icons.whatshot, Value.justHot, Value.justHotPath),
    MovieTab(Icons.compare, Value.willUp, Value.willUpPath),
    MovieTab(Icons.vertical_align_top, Value.top250, Value.top250Path),
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
        drawer: Drawer(
          elevation: 8.0,
          semanticLabel: Value.drawerLabel,
          child: DrawerLayout(),
        ),
        bottomNavigationBar: _getBottomNavigationBar(),
      ),
    );
  }

  _getTitle() {
    switch (index) {
      case 0:
        return _forMatchTitle(Value.movie);
      case 1:
        return _forMatchTitle(Value.book);
      case 2:
        return _forMatchTitle(Value.music);
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
          double offset = 0.0;
          bookPage = BookPage(offset);
        }
        return bookPage;
      case 2:
        return Center(
          child: Text(Value.music),
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
                  icon: this.index == 0
                      ? Icon(Icons.movie_filter)
                      : Icon(Icons.movie),
                  title: Text(Value.movie));
            case 1:
              return BottomNavigationBarItem(
                  icon:
                      this.index == 1 ? Icon(Icons.book) : Icon(Icons.bookmark),
                  title: Text(Value.book));
            case 2:
              return BottomNavigationBarItem(
                  icon: this.index == 2
                      ? Icon(Icons.music_video)
                      : Icon(Icons.music_note),
                  title: Text(Value.music));
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
                    child: Text(Value.author[0]),
                  ),
                  Text(Value.author, style: Theme.of(context).textTheme.title),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                QQCallText(qqNumber: Value.QQ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: EmailText(
                    email: Value.eMail,
                    title: Value.eMailContent,
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
      child: Text(Value.support),
      authorDes: Value.supportTip,
      title: Value.supportTitle,
    );
  }

  _getAboutItem() {
    return AboutListTile(
      icon: Icon(Icons.person),
      child: Text(Value.about),
      applicationLegalese: Value.aboutDes,
      applicationName: Value.appName,
      applicationVersion: 'version:${Value.appVersion}',
    );
  }
}
