import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_douban/value.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'dart:async';

export 'package:url_launcher/url_launcher.dart';
const utils_platform = const MethodChannel('samples.flutter.io/utils');

//分享按钮
class ShareIconButton extends StatelessWidget {
  ShareIconButton({this.title, this.url, this.summary});

  final String title;
  final String url;
  final String summary;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
        icon: Icon(Icons.share),
        onPressed: () => Share
            .share("$title\n介绍:\n$summary\n详情请看:\n$url\n来自flutter_douban应用"));
  }
}

//加载网页按钮
class WebIconButton extends StatelessWidget {
  WebIconButton({@required this.url, this.errorTip});

  final String url;
  final String errorTip;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
        icon: Icon(Icons.web),
        onPressed: () {
          openByWeb(context, url, errorTip, true);
        });
  }
}

//加载网页按钮
class WebButton extends StatelessWidget {
  WebButton({@required this.text, @required this.url, this.errorTip});

  final String text;
  final String url;
  final String errorTip;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RaisedButton(
      child: Text(text),
      onPressed: () {
        openByWeb(context, url, errorTip, false);
      },
    );
  }
}

//加载网页文字
class WebText extends StatelessWidget {
  WebText({@required this.text, @required this.url, this.errorTip});

  final String text;
  final String url;
  final String errorTip;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Text(
        text,
        style: Theme.of(context).textTheme.title.copyWith(color: Colors.blue),
      ),
      onTap: () {
        openByWeb(context, url, errorTip, true);
      },
    );
  }
}

openByWeb(BuildContext context, String url, String errorTip,
    bool forceWebView) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: forceWebView);
  } else {
    _showDialog(
        context: context, content: errorTip ?? Value.loadingWebErrorTip);
  }
}

_showDialog({@required BuildContext context, String content}) {
  assert(context != null);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(Value.tip),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(Value.sure),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//捐献按钮
class DonateFlatButton extends StatelessWidget {
  DonateFlatButton({@required this.ercode, this.text});

  final String ercode;
  final String text;

  _donateAndroid(BuildContext context) async {
    bool isSuccess =
        await utils_platform.invokeMethod(Value.ZhiFuMethodValue, [ercode]);
    if (!isSuccess) {
      _showDialog(context: context, content: Value.noSupportZhiFu);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          _donateAndroid(context);
        },
        child: Text(text));
  }
}

class EmailText extends StatelessWidget {
  EmailText({@required this.email, this.title, this.body});

  final String email;
  final String title;
  final String body;

  _sendEmail() {
    String emailCode = 'mailto:${email ?? ''}?subject=${title ??
        ''}&body=${body ?? ''}';
    launch(emailCode);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: _sendEmail,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'E-mail:',
            style: Theme.of(context).textTheme.subhead,
          ),
          Text(
            email,
            style: Theme.of(context).textTheme.subhead.copyWith(
                  color: Colors.lightBlue,
                ),
          ),
        ],
      ),
    );
  }
}

class QQCallText extends StatelessWidget {
  QQCallText({@required this.qqNumber});

  final String qqNumber;

  _callQQ(BuildContext context) async {
    bool isSuccess =
        await utils_platform.invokeMethod(Value.QQMethodValue, [qqNumber]);
    if (!isSuccess) {
      _showDialog(context: context, content: Value.QQNoSupport);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _callQQ(context);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'QQ:',
            style: Theme.of(context).textTheme.subhead,
          ),
          Text(
            qqNumber,
            style: Theme.of(context).textTheme.subhead.copyWith(
                  color: Colors.lightBlue,
                ),
          ),
        ],
      ),
    );
  }
}

//显示加载转圈
class LoadingProgress extends StatelessWidget {
  getProgressDialog() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getProgressDialog();
  }
}

class LoadingError extends StatelessWidget {
  LoadingError({@required this.voidCallback});

  final VoidCallback voidCallback;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: RaisedButton(
          textColor: Colors.green,
          child: Text(Value.loadingErrorTip),
          onPressed: voidCallback),
    );
  }
}
//轮播图
class ViewPager extends StatefulWidget {
  ViewPager(
      {Key key,
      @required this.children,
      this.isShowIndicator,
      this.delayMilliseconds: 5000,
      this.moveMilliseconds: 500})
      : super(key: key);
  final List<Widget> children;
  final bool isShowIndicator;
  final int delayMilliseconds;
  final int moveMilliseconds;

  @override
  _ViewPagerState createState() => new _ViewPagerState();
}

class _ViewPagerState extends State<ViewPager> {
  int position = 0;
  final PageController controller = new PageController();
  bool isDisPose = false;

  _setPosition(int index) {
    setState(() {
      position = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startViewPager();
  }

  @override
  void dispose() {
    isDisPose = true;
    super.dispose();
  }

  _startViewPager() async {
    new Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
      if (!isDisPose) {
        setState(() {
          position = position + 1;
          if (position == (widget.children.length)) {
            position = 0;
          }
          controller.animateToPage(position,
              duration: Duration(milliseconds: widget.moveMilliseconds),
              curve: Curves.easeIn);
        });
      }
      _startViewPager();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView.builder(
          controller: controller,
          onPageChanged: _setPosition,
          scrollDirection: Axis.vertical,
          itemBuilder: (build, index) {
            return widget.children[index];
          },
          itemCount: widget.children.length,
        ),
        Opacity(
          opacity: widget.isShowIndicator ? 1.0 : 0.0,
          child: Align(
            alignment: Alignment.bottomRight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children:
                    List<Widget>.generate(widget.children.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Icon(
                      Icons.brightness_1,
                      size: 7.0,
                      color: position == index ? Colors.grey : Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
