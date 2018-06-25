import 'package:flutter/material.dart';
import 'package:flutter_douban/http/HttpManagert.dart' as HttpManager;
import 'package:flutter_douban/value.dart';
import 'package:flutter_douban/utils/Utils.dart';
import 'package:flutter_douban/entity/music.dart';
import 'package:flutter_douban/info/music_info.dart';

class MusicPage extends StatefulWidget {
  MusicPage(this.offset);

  double offset;
  ScrollController controller;
  bool isLoad = false;
  MusicList data;

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  bool isSuccess = true;

  _loadData() async {
    HttpManager.get(
        url: Value.musicPath,
        onSend: () {
          setState(() {
            isSuccess = true;
          });
        },
        onSuccess: (result) {
          MusicList musicList = MusicList.fromHtml(result);
          setState(() {
            widget.data = musicList;
          });
        },
        onError: (error) {
          setState(() {
            widget.data = null;
            isSuccess = false;
          });
        });
  }

  //获取加载中跟加载失败的widget
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
  void initState() {
    super.initState();
    if (!widget.isLoad) {
      _loadData();
    }
  }

  //载入列表滚动控制器
  _initController() {
    widget.controller = ScrollController(initialScrollOffset: widget.offset);
    widget.controller.addListener(() {
      widget.offset = widget.controller.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.data == null ? _getLoading() : _body();
  }

  //body
  _body() {
    _initController();
    return NestedScrollView(
      controller: widget.controller,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            child: _getTopWidgets(),
          ),
        ];
      },
      body: Builder(
        builder: (BuildContext context) {
          return _getCenterWidgets(context);
        },
      ),
    );
  }

  _click(String address) async {
    if (await canLaunch(address)) {
      await launch(address, forceWebView: true);
    }
  }

  //顶部banner
  _getTopWidgets() {
    List<Widget> widgets =
        new List<Widget>.generate(widget.data.bannerList.length, (index) {
      return new GestureDetector(
        onTap: () => _click(widget.data.bannerList[index].address),
        child: new Image.network(
          widget.data.bannerList[index].imageAddress,
          fit: BoxFit.cover,
        ),
      );
    });
    return SliverPersistentHeader(
      delegate: SliverBanner(childs: widgets),
    );
  }

  //轮播图下面滑动部分
  _getCenterWidgets(BuildContext context) {
    return new CustomScrollView(
      slivers: _getCustomBody(context),
    );
  }

  //滑动部分的widget集合
  _getCustomBody(BuildContext context) {
    List<Widget> widgets = <Widget>[
      new SliverOverlapInjector(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      ),
      SliverTitle(widget.data.m250List.title),
      SliverList(
        delegate: SliverChildListDelegate([
          _get250Widget(),
        ]),
      ),
      SliverTitle(widget.data.editList.title),
      SliverList(
        delegate: SliverChildListDelegate([
          _getEditWidget(),
        ]),
      ),
    ];
    widgets.addAll(_getFashionWidget());

    return widgets;
  }

  //豆瓣250
  _get250Widget() {
    List<Widget> m250List =
        new List.generate(widget.data.m250List.itemList.length, (index) {
      Music250Item music250item = widget.data.m250List.itemList[index];
      return new GestureDetector(
        onTap: () => _getInfo(widget.data.m250List.itemList[index].address),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: new Image.network(
                  music250item.imageAddress,
                  width: 70.0,
                  height: 70.0,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                child: Text(music250item.title),
                width: 70.0,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
              ),
            ],
          ),
        ),
      );
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: m250List,
      ),
    );
  }

  void _getInfo(String address) {
    print(address);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MusicInfo(
              address: address,
            )));
  }

  //编辑推荐
  _getEditWidget() {
    List<Widget> editList =
        new List.generate(widget.data.editList.itemList.length, (index) {
      MusicEditItem musicedititem = widget.data.editList.itemList[index];
      return new GestureDetector(
        onTap: () => _getInfo(widget.data.editList.itemList[index].address),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  musicedititem.imageAddress,
                ),
                Container(
                  child: Text(
                    musicedititem.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(
                    musicedititem.des,
                    style: Theme.of(context).textTheme.body2,
                  ),
                  alignment: Alignment.center,
                ),
                Container(
                  width: 150.0,
                  padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
                  child: Text(
                    musicedititem.summery,
                    style: Theme.of(context).textTheme.body2,
                  ),
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: editList,
      ),
    );
  }

  //本周流行
  _getFashionWidget() {
    List<Widget> widgets = [];
    widget.data.fashionList.forEach((e) {
      widgets.add(SliverTitle(e.title));
      widgets.add(SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (
            BuildContext context,
            index,
          ) {
            return new GestureDetector(
              onTap: () => _getInfo(e.itemList[index].address),
              child: Card(
                child: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          e.itemList[index].imageAddress,
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: 200.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                e.itemList[index].name,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(color: Colors.white),
                              ),
                              Text(
                                e.itemList[index].type,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.black54,
                                Colors.black12,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            );
          },
          childCount: e.itemList.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 1.0,
        ),
      ));
    });
    return widgets;
  }
}

//Sliver的标题头部
class SliverTitle extends StatelessWidget {
  SliverTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: SliverTitleDelegate(title: title),
    );
  }
}

//delegate标题头部
class SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  SliverTitleDelegate({@required this.title, this.height});

  final String title;
  final double height;
  BuildContext context;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    this.context = context;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        alignment: Alignment.centerLeft,
        child: new Opacity(
          opacity: shrinkOffset > minExtent
              ? (maxExtent - shrinkOffset) / maxExtent
              : 1.0,
          child: Text(
            title ?? '标题',
            style: Theme.of(context).textTheme.title.copyWith(
                color: Theme.of(context).primaryColor, fontFamily: 'Merri'),
          ),
        ));
  }

  @override
  double get maxExtent => height ?? 60.0;

  @override
  double get minExtent => height ?? Theme.of(context).textTheme.title.fontSize;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

//sliver轮播图
class SliverBanner extends SliverPersistentHeaderDelegate {
  SliverBanner({@required this.childs});

  final List<Widget> childs;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Opacity(
      opacity: (maxExtent - shrinkOffset) / maxExtent,
      child: ViewPager(
        children: childs,
        isShowIndicator: shrinkOffset == 0,
      ),
    );
  }

  @override
  double get maxExtent => 200.0;

  @override
  double get minExtent => 0.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

