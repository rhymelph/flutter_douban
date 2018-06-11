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
  bool isSuccess=true;

  _loadData() async {
    HttpManager.get(
        url: Value.musicPath,
        onSend: () {
          setState(() {
            isSuccess=true;
          });
        },
        onSuccess: (result) {
           MusicList musicList=new MusicList.fromHtml(result);
          setState(() {
            widget.data=musicList;
          });
        },
        onError: (error) {
          setState(() {
            widget.data=null;
            isSuccess=false;
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

  _body() {
    _initController();
    return Center(
      child: Text(widget.data.fashionList[0].title,style: TextStyle(fontFamily: 'Merri'),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.data==null?_getLoading():_body();
  }
}
