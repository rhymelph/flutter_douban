import 'package:html/dom.dart';


import 'package:html/parser.dart';

class BookEntity {
  final String author; //作者
  final String publish; //出版社
  final String origin_title; //原名
  final String author_des; //译者
  final String publish_year; //出版年
  final String page_count; //页数
  final String price; //价格
  final String Binding; //装帧
  final String series; //丛书
  final String ISBM; //ISBM
  final String ratingValue; //评分
  final String ratingCount; //评价
  final String intro_content; //内容简介
  final String intro_author; //作者简介
  final String indent; //目录
  final List<String> tags; //标签
  final String subject; //丛书信息
  final List<Comment> commentList;

  BookEntity(this.author, this.publish, this.origin_title, this.author_des,
      this.publish_year, this.page_count, this.price, this.Binding, this.series,
      this.ISBM, this.ratingValue, this.ratingCount, this.intro_content,
      this.intro_author, this.indent, this.tags, this.subject,
      this.commentList);

  factory BookEntity.forHtml(String htmlDoc){
    Document doc = parse(htmlDoc);
    Element body = doc.body;
    var info = body
        .getElementsByClassName("subject")
        .first
        .getElementsByClassName("p1");
    String author;
    String publish;
    String originTitle;
    String authorDes;
    String publishYear;
    String page_count;
    String price;
    String Binding;
    String series;
    String ISBM;
    String intro_content;
    String intro_author;
    String indent;

    for (int i = 0; i < info.length; i++) {
      var e = info[i];
      String text = e.text.replaceAll(' ', '');
      if (text.contains("作者")) {
        author = e.text;
      } else if (text.contains("出版社")) {
        publish = text;
      } else if (text.contains('原作名')) {
        originTitle = text;
      } else if (text.contains('出版年:')) {
        publishYear = text;
      } else if (text.contains('译者')) {
        authorDes = text;
      } else if (text.contains('页数')) {
        page_count = text;
      } else if (text.contains('定价')) {
        price = text;
      } else if (text.contains('装帧')) {
        Binding = text;
      } else if (text.contains('丛书')) {
        series = text;
      } else if (text.contains('ISBN')) {
        ISBM = text;
      }
    }
    Element ratingSelf=body.getElementsByClassName('rating_self').first;
    String ratingNum=ratingSelf.getElementsByClassName('rating_num').first.text.replaceAll(' ', '');
    String number=ratingSelf.getElementsByClassName('rating_people').first.getElementsByTagName('span').first.text;

    Element related_info=body.getElementsByClassName('related_info').first;
    var intro =related_info.getElementsByClassName('intro');
    intro.forEach((e){
      if(intro_content==null){
        e.getElementsByTagName('p').forEach((p){
          intro_content +=p.text+'\n';
        });
      }else if(intro_author==null){
        e.getElementsByTagName('p').forEach((p){
          intro_author +=p.text+'\n';
        });
      }
    });
    indent= related_info.getElementsByClassName('indent').last.text.replaceAll(' ',"").replaceAll('\"', '');
    
    return new BookEntity(
        author,
        publish,
        originTitle,
        authorDes,
        publishYear,
        page_count,
        price,
        Binding,
        series,
        ISBM,
        ratingNum,
        number,
        intro_content,
        intro_author,
        indent,
        null,
        null,
        null);
  }
}

class Comment {
  final String name;
  final String address;
  final String title;
  final String time;
  final String ratingsValue;

  Comment(this.name, this.address, this.title, this.time, this.ratingsValue);
}