// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide Flow;
import 'package:flutter_douban/utils/Utils.dart';
class DonateListTile extends StatelessWidget {
  const DonateListTile({
    Key key,
    this.icon: const Icon(null),
    this.child,
    this.authorDes,
    this.title,
  }) : super(key: key);
  final Widget icon;
  final Widget child;
  final String authorDes;
  final String title;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return new ListTile(
        leading: icon,
        title: child,
        onTap: () {
          showDonateDialog(
            context: context,
            authorDes: authorDes,
            title: title,
          );
        });
  }
}

void showDonateDialog({
  @required BuildContext context,
  String authorDes,
  String title,
}) {
  assert(context != null);
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return new DonateDialog(
          authorDes: authorDes,
          title: title,
        );
      });
}

class DonateDialog extends StatelessWidget {
  const DonateDialog({
    Key key,
    this.authorDes,
    this.title,
  }) : super(key: key);

  final String authorDes;
  final String title;

  @override
  Widget build(BuildContext context) {
    List<Widget> body = <Widget>[];
    body.add(new Expanded(
        child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new ListBody(children: <Widget>[
              new Text(title ?? '',style: Theme.of(context).textTheme.title),
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: new Text(authorDes ?? '',
                    style: Theme.of(context).textTheme.caption),
              )
            ]))));
    body = <Widget>[
      new Row(crossAxisAlignment: CrossAxisAlignment.start, children: body),
    ];
    return new AlertDialog(
        content: new SingleChildScrollView(
          child: new ListBody(children: body),
        ),
        actions: <Widget>[
          new DonateFlatButton(ercode: 'FKX05369RYXWBANXWYFR43',text: '好主意',),
        ]);
  }
}
