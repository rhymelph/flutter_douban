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
  final String read_address;
  final String intro_author; //作者简介
  final String indent; //目录
  final List<String> tags; //标签
  final String subject; //丛书信息
  final List<Comment> commentList;

  BookEntity(
      this.author,
      this.publish,
      this.origin_title,
      this.author_des,
      this.publish_year,
      this.page_count,
      this.price,
      this.Binding,
      this.series,
      this.ISBM,
      this.ratingValue,
      this.ratingCount,
      this.intro_content,
      this.read_address,
      this.intro_author,
      this.indent,
      this.tags,
      this.subject,
      this.commentList);

  factory BookEntity.forHtml(String htmlDoc) {
    Document doc = parse(htmlDoc);
    Element body = doc.body;
    var a = body.getElementsByClassName('subject');
    var b = a.first.text.replaceAll(' ', '').split("\n\n\n\n");
    String author;
    String publish;
    String originTitle;
    String authorDes;
    String publishYear;
    String page_count;
    String price;
    String Binding;
    String series;
    String ISBN;
    String intro_content='';
    String intro_author='';
    String indent;
    for(String text in b){
      if(text.isNotEmpty){
        String item=text.replaceAll("\n", '');
        if(text.contains("作者")){
          author=item;
        }else if(text.contains("出版社")){
          publish=item;
        }else if(text.contains("原作名")){
          originTitle=item;
        }else if(text.contains("译者")){
          authorDes=item;
        }else if(text.contains("出版年")){
          publishYear=item;
        }else if(text.contains("页数")){
          page_count=item;
        }else if(text.contains("定价")){
          price=item;
        }else if(text.contains("装帧")){
          Binding=item;
        }else if(text.contains("丛书")){
          series=item;
        }else if(text.contains("ISBN")){
          ISBN=item;
        }
      }
    }
    Element ratingSelf = body.getElementsByClassName('rating_self').first;
    String ratingNum = ratingSelf
        .getElementsByClassName('rating_num')
        .first
        .text
        .replaceAll(' ', '');
    String number;
    List<Element> rating_people=ratingSelf.getElementsByClassName('rating_people');

    if(rating_people!=null&&rating_people.length>0){
      number = ratingSelf
          .getElementsByClassName('rating_people')
          .first
          .getElementsByTagName('span')
          .first
          .text;
    }

    Element relatedInfo = body.getElementsByClassName('related_info').first;
    var intro = relatedInfo.getElementsByClassName('intro');
    if(intro.first!=null){
      List<Element> list=intro.first.getElementsByTagName('p');
      for(Element p in list){
        intro_content += '${p.text}\n';
      }
    }
    if(intro.last!=null){
      List<Element> list=intro.last.getElementsByTagName('p');
      for(Element p in list){
        intro_author += '${p.text}\n';
      }
    }
    intro_content=intro_content.replaceAll('(展开全部)', '');

    String read_address;

    var onlineRead=body.getElementsByClassName('online-read');
    if(onlineRead!=null&&onlineRead.length>0){
      var a=onlineRead.first.getElementsByTagName('a');
      if(a!=null&&a.length>0){
        read_address=a.first.attributes['href'];
      }
    }
    indent = relatedInfo
        .getElementsByClassName('indent')
        .elementAt(3)
        .text
        .replaceAll(' ', "")
        .replaceAll('\"', '');
    if(indent.contains('还没人写过短评呢')||(indent.contains('-')&&indent.contains('有用'))){
      indent='暂时没有目录';
    }
    indent=indent.replaceAll('(收起)', '');

    List<Element> tagsDoc=body.getElementsByClassName('tag');
    List<String> tags=new List.generate(tagsDoc.length, (index){
      return tagsDoc[index].text;
    });

    //
    Element subjectShow=body.getElementsByClassName('subject_show').first;
    Element divSubject=subjectShow.getElementsByTagName('div').first;
    String subject=divSubject.text;

    //获取书评
    List<Comment> commentList;

    if(body.getElementsByClassName('review-list')!=null&&body.getElementsByClassName('review-list').length>0){
      Element reviewList = body.getElementsByClassName('review-list').first;
      List<Element> reviewItem=reviewList.getElementsByClassName('review-item');
      commentList=new List.generate(reviewItem.length, (index){
        Element mainHd=reviewItem[index].getElementsByClassName('main-hd').first;
        Element avator=mainHd.getElementsByClassName('avator').first.getElementsByTagName('img').first;
        var attributes = avator.attributes;
        String avatorImg;
        avatorImg=attributes['src'];

        String name=mainHd.getElementsByClassName('name').first.text;
        Element mainTitleRating=mainHd.getElementsByClassName('main-title-rating').first;
        String ratingsValue=mainTitleRating.attributes['class'];
        ratingsValue=ratingsValue.substring(ratingsValue.indexOf('allstar')+7,ratingsValue.indexOf('allstar')+9);
        String ratingsDes=mainTitleRating.attributes['title'];

        String time=mainHd.getElementsByClassName('main-meta').first.text;

        Element mainBd=reviewItem[index].getElementsByClassName('main-bd').first;

        Element titleDoc=mainBd.getElementsByTagName('a').first;

        String title=titleDoc.text;

        String address=titleDoc.attributes['href'];

        String shortContent= mainBd.getElementsByClassName('short-content').first.text;
        return Comment(avatorImg,name,ratingsValue,ratingsDes,time,title.replaceAll('\n', '').replaceAll(' ', ''),address,shortContent.replaceAll('\n', '').replaceAll(' ', '').replaceAll('(展开)', ''));
      });
    }

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
        ISBN,
        ratingNum,
        number,
        intro_content,
        read_address,
        intro_author,
        indent,
        tags,
        subject,
        commentList);
  }
}

class Comment {
  final String avator;
  final String name;
  final String address;
  final String title;
  final String time;
  final String ratingsValue;
  final String ratingDes;
  final String shortContent;

  Comment(this.avator,this.name, this.ratingsValue,this.ratingDes, this.time, this.title, this.address,this.shortContent);
}
