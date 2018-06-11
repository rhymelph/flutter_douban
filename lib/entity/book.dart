import 'package:html/dom.dart';


import 'package:html/parser.dart';

class BookTitleList{
  final String title;
  final List<Book> bookList;
  BookTitleList(this.title, this.bookList);

  factory BookTitleList.format(String htmlDoc,String id){
    var document=parse(htmlDoc);
    var a=document.getElementsByClassName(id).first;
    String oneList=a.getElementsByTagName('span').first.text;
    List<Element> c=a.getElementsByClassName('bd').first.getElementsByTagName('li');
    List<Book> d=[];
    c.forEach((e){
      var f=e.getElementsByTagName('img').first.attributes;
      var g=e.getElementsByTagName('a').first.attributes;
      String address=g['href'];
      String imageAddress=f['src'];
      String name=f['alt'];

      List<Element> star=e.getElementsByClassName('entry-star-small');
      double starValue=0.0;
      if(star.length!=0){
        String value=star.first.getElementsByClassName('average-rating').first.text.replaceAll(" ", '');
        starValue=double.parse(value);
      }
      String author=e.getElementsByClassName('author').first.text.replaceAll(" ", '').replaceAll("\n", '');
      if(!author.contains('作者')){
        author='作者：$author';
      }
      d.add(Book(name, imageAddress,author,starValue,address)) ;
    });
    return  BookTitleList(oneList, d);
  }

  static List<BookTitleList> getFromHtml(String htmlDoc){
    List<BookTitleList> bookLists=<BookTitleList>[];
    bookLists.add( BookTitleList.format(htmlDoc, 'books-express'));
    bookLists.add( BookTitleList.format(htmlDoc, 'popular-books'));
    return bookLists;
  }
}

class Book{
  final String name;
  final String imageAddress;
  final double ratingsValue;
  final String author;
  final String address;

  Book(this.name, this.imageAddress, this.author,this.ratingsValue,this.address);
}