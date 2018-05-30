import 'package:html/dom.dart';

import 'package:html/dom_parsing.dart';

import 'package:html/parser.dart';

import 'package:html/parser_console.dart';
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
      String image_addrress;
      String name;
      f.forEach((a,b){
        if(a.toString()=='src'){
          image_addrress=b;
        }else if(a.toString() =='alt'){
          name=b;
        }
      });
      List<Element> star=e.getElementsByClassName('entry-star-small');
      double star_value=0.0;
      if(star.length!=0){
        String value=star.first.getElementsByClassName('average-rating').first.text.replaceAll(" ", '');
        star_value=double.parse(value);
      }
      String author=e.getElementsByClassName('author').first.text.replaceAll(" ", '').replaceAll("\n", '');
      if(!author.contains('作者')){
        author='作者：$author';
      }
      d.add(Book(name, image_addrress,author,star_value)) ;
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
  final String image_address;
  final double ratings_value;
  final String author;

  Book(this.name, this.image_address, this.author,this.ratings_value);
}