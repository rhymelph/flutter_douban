import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_douban/http/HttpManagert.dart' as HttpManager;
import 'package:flutter_douban/utils/Utils.dart';
import 'package:flutter_douban/entity/music_info.dart';

class MusicInfo extends StatefulWidget {
  MusicInfo({this.address});

  final String address;

  @override
  _MusicInfoState createState() => _MusicInfoState();
}

class _MusicInfoState extends State<MusicInfo> {

  bool isSuccess = true;
  MusicInfo1 result;

  IconData iconData=Icons.info;


  _loadData() async {
    HttpManager.get(
        url: widget.address,
        onSend: () {
          setState(() {
            isSuccess = true;
          });
        },
        onSuccess: (result) {
          setState(() {
            this.result = new MusicInfo1.json(result);
          });
        },
        onError: (error) {
          setState(() {
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


  _getBody() {
    return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // ignore: conflicting_dart_import
          Image.network(
            result.image,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.transparent),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(const Radius.circular(8.0)),
                color: Colors.grey.shade600.withOpacity(0.5),
              ),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 250.0,
                    backgroundColor: Colors.transparent,
                    title: Text(result.name),
                    flexibleSpace: Image.network(result.image,fit: BoxFit.cover,),
                    actions: <Widget>[
                      new IconButton(
                          icon: Icon(iconData),
                          onPressed: (){_showInfoBottomSheet();})
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
  }

  List<Widget> _getTextList(){
    List<Widget> widgetList=[];
    if(result.otherName!=null&&result.otherName.isNotEmpty){
      widgetList.add(_getText(result.otherName));
    }
    if(result.author!=null&&result.author.isNotEmpty){
      widgetList.add(_getText(result.author));
    }
    if(result.schools!=null&&result.schools.isNotEmpty){
      widgetList.add(_getText(result.schools));
    }
    if(result.Album!=null&&result.Album.isNotEmpty){
      widgetList.add(_getText(result.Album));
    }
    if(result.medium!=null&&result.medium.isNotEmpty){
      widgetList.add(_getText(result.medium));
    }
    if(result.releaseTime!=null&&result.releaseTime.isNotEmpty){
      widgetList.add(_getText(result.releaseTime));
    }
    if(result.publisher!=null&&result.publisher.isNotEmpty){
      widgetList.add(_getText(result.publisher));
    } if(result.recordsNumber!=null&&result.recordsNumber.isNotEmpty){
      widgetList.add(_getText(result.recordsNumber));
    } if(result.barCode!=null&&result.barCode.isNotEmpty){
      widgetList.add(_getText(result.barCode));
    }if(result.isrc!=null&&result.isrc.isNotEmpty){
      widgetList.add(_getText(result.isrc));
    }
    return widgetList;
  }
  _getText(String text){
    return ListTile(title: Text(text,style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: result == null ? _getLoading() : _getBody(),
    );
  }

  _onClose(){
    setState(() {
      iconData=Icons.info;

    });
  }

  _showInfoBottomSheet() {
    setState(() {
    iconData=Icons.info_outline;
    });
    showModalBottomSheet<Null>(context: context, builder: (BuildContext context) => _DemoDrawer(_getTextList(),));

  }
}
class _DemoDrawer extends StatelessWidget {
  final List<Widget> list;

   _DemoDrawer(this.list);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: list,
      ),
    );
  }
}