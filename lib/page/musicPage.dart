import 'package:flutter/material.dart';
import 'package:flutter_douban/http/HttpManagert.dart' as HttpManager;
import 'package:flutter_douban/value.dart';
import 'package:flutter_douban/utils/Utils.dart';
import 'package:flutter_douban/entity/music.dart';

class MusicPage extends StatefulWidget {
  MusicPage(this.offset);

  double offset;
  ScrollController controller;
  bool isLoad = false;
  MusicList data;

  @override
  _MusicPageState createState() => new _MusicPageState();
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
          MusicList musicList = new MusicList.fromHtml(result);
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
    return new NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          new SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            child: _getTopWidgets(),
          ),
        ];
      },
      body: new Builder(
        builder: (BuildContext context) {
          return _getCenterWidgets(context);
        },
      ),
    );
  }

  //顶部banner
  _getTopWidgets() {
    List<Widget> widgets =
        new List<Widget>.generate(widget.data.bannerList.length, (index) {
      return new Image.network(
        widget.data.bannerList[index].imageAddress,
        fit: BoxFit.cover,
      );
    });
    return SliverPersistentHeader(
      delegate: SliverBanner(childs: widgets),
    );
  }

  //滑动部分
  _getCenterWidgets(BuildContext context) {
    return new CustomScrollView(
      slivers: <Widget>[
        new SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverMusicTitle(widget.data.m250List.title),
        SliverList(
          delegate: new SliverChildListDelegate([_get250Widget(),]),
        ),
        SliverMusicTitle(widget.data.editList.title),
        SliverList(
          delegate: new SliverChildListDelegate([_getEditWidget(),]),
        ),
      ],
    );
  }
  //获取顶部
  _get250Widget() {
    List<Widget> m250List =
        new List.generate(widget.data.m250List.itemList.length, (index) {
      Music250Item music250item = widget.data.m250List.itemList[index];
      return new Padding(
        padding: const EdgeInsets.all(4.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new ClipOval(
              child: new Image.network(
                music250item.imageAddress,
                width: 70.0,
                height: 70.0,
              ),
            ),
            new Container(
              child: Text(music250item.title),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
            ),
          ],
        ),
      );
    });
    return new SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: new Row(
        children: m250List,
      ),
    );
  }

//   _getScrollerWidget(){
//    List<Widget> widgets=;
////    widgets.addAll(_getFashionWidget());
//    return widgets;
//  }

  _getFashionWidget(){
    List<Widget> widgets=[];
    widget.data.fashionList.forEach((e){
        widgets.add(SliverMusicTitle(e.title));
        widgets.add(SliverGrid(
          delegate: SliverChildBuilderDelegate(
                (
                BuildContext context,
                index,
                ) {
              return Text(e.itemList[index].name);
            },
            childCount: e.itemList.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.7,
          ),
        ));
    });
    return widgets;
  }

  //编辑推荐
  _getEditWidget() {
    List<Widget> editList =
    new List.generate(widget.data.editList.itemList.length, (index) {
      MusicEditItem musicedititem = widget.data.editList.itemList[index];
      return new Padding(
        padding: const EdgeInsets.all(4.0),
        child: new Card(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.network(
                musicedititem.imageAddress,
              ),
               Container(
                child: Text(musicedititem.name,style: Theme.of(context).textTheme.title,),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                child: Text(musicedititem.des,style: Theme.of(context).textTheme.body2,),
                alignment: Alignment.center,
              ),
              Container(
                width: 150.0,
                padding: const EdgeInsets.fromLTRB(4.0,8.0,4.0,8.0),
                child: Text(musicedititem.summery,style: Theme.of(context).textTheme.body2,),
                alignment: Alignment.center,
              ),
            ],
          ),
        ),
      );
    });
    return new SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: editList,
      ),
    );
  }
}

class SliverMusicTitle extends StatelessWidget {
  SliverMusicTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: SliverTitle(title: title),
    );
  }
}
class SliverTitle extends SliverPersistentHeaderDelegate{

  SliverTitle({@required this.title, this.height});
  final String title;
  final double height;
  BuildContext context;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    this.context=context;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.centerLeft,
        child: Text(
          title ?? '标题',
          style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).primaryColor),
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
class SliverBanner extends SliverPersistentHeaderDelegate {
  SliverBanner({@required this.childs});

  final List<Widget> childs;
  int position;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return PageView.builder(
      onPageChanged: _setPosition,
      scrollDirection: Axis.vertical,
      itemBuilder: (build, index) {
        return childs[index];
      },
      itemCount: childs.length,
    );
  }

  _setPosition(int index) {
    position = index;
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
