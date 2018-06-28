import 'package:html/dom.dart';

import 'package:flutter_douban/value.dart';
import 'package:html/parser.dart';

class MusicInfo1{
  final String name;//名字
  final String image;//图片
  final String otherName;//又名
  final String author;//表演者
  final String schools;//流派
  final String Album;//专辑
  final String medium;//介质
  final String releaseTime;//发行时间
  final String publisher;//出版者
  final String recordsNumber;//唱片数
  final String barCode;//条形码
  final String isrc;//isrc
  final String indent;//曲目
  final String introContent;//介绍

  MusicInfo1(this.name,this.image, this.otherName, this.author, this.schools, this.Album, this.medium, this.releaseTime, this.publisher, this.recordsNumber, this.barCode, this.isrc, this.indent, this.introContent);

  factory MusicInfo1.json(String htmldoc){
    var doc=parse(htmldoc);
    var body=doc.body;

    var a = body.getElementsByClassName('nbg').first;
    var b = a.attributes['href'];//图片
    var c=a.getElementsByTagName('img').first.attributes['alt'];//名字

    var d=body.getElementsByClassName('ckd-collect').last;
    var e=d.text.replaceAll('  ', '').split('\n\n\n\n');

    String otherName;
    String author;
    String schools;
    String Album;
    String medium;
    String releaseTime;
    String publisher;
    String recordsNumber;
    String barCode;
    String isrc;

    for(String text in e){
      if(text.isNotEmpty){
        String item;
        if(text.contains('\n\n\n')){
          var split = text.split('\n\n\n');
            item='';
            split.forEach((a){
              if(item.isEmpty){
                item =a.replaceAll('\n', '');
              }else{
                item +='\n${a.replaceAll('\n', '')}';
              }
            });
        }else{
          item=text.replaceAll("\n", '');
        }
        if(text.contains("又名:")){
          otherName=item;
        }else if(text.contains("表演者:")){
          author=item;
        }else if(text.contains("流派:")){
          schools=item;
        }else if(text.contains("专辑类型:")){
          Album=item;
        }else if(text.contains("介质:")){
          medium=item;
        }else if(text.contains("发行时间:")){
          releaseTime=item;
        }else if(text.contains("出版者:")){
          publisher=item;
        }else if(text.contains("唱片数:")){
          recordsNumber=item;
        }else if(text.contains("条形码:")){
          barCode=item;
        }else if(text.contains("其他版本:")||text.contains('ISRC')){
          if(isrc!=null){
            if(text.contains(':')){
              isrc +='\n$item';
            }else{
              isrc +=item;
            }
          }else{
            isrc=item;
          }
        }
      }
    }

    var f=body.getElementsByClassName('related_info');
    //简介
    var g = f.first.getElementsByClassName('all');
    String h='';//介绍
    if(g.length>0){
      h=g.first.text.replaceAll('\n', '').replaceFirst('　　', '');
      h=h.replaceAll('　　', '　　\n    ');
      h='   $h';
    }
    var i=body.getElementsByClassName('track-list');
    String j='';//曲目
    if(i.length>0){
      j=i.first.text.replaceAll('\n', '').replaceAll(' ', '');
      j=j.replaceAll(RegExp("[0-9]\d*"), "\n");
      j=j.replaceAll('.', '');
      j=j.replaceFirst('\n', '');
    }

    return new MusicInfo1(c,b,otherName,author,schools,Album,medium,releaseTime,publisher,recordsNumber,barCode,isrc,h,j);

  }
}

class HapplyComment{
  String name;
  String ratingValue;
  String time;
  String content;
  String title;
  String address;

}