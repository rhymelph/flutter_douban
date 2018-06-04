import 'package:flutter/material.dart';

class MovieTab {
  final IconData iconData;
  final String title;
  final String address;
  Widget page;
  double offset;
  MovieTab(this.iconData,this.title, this.address);
}
class Movie{
  final String title;//标题
  final String originalTitle;//原标题
  final RatingBean rating;
  final int collectCount;
  final String subtype;
  final String year;
  final ImagesBean images;
  final String alt;
  final String id;
  final List<String> genres;
  final List<CastsBean> casts;
  final List<DirectorsBean> directors;

  Movie(this.title, this.originalTitle, this.rating, this.collectCount, this.subtype, this.year, this.images, this.alt, this.id, this.genres, this.casts, this.directors);

  factory Movie.formJson(Map<String,dynamic> json){
    List<String> genres=json['genres']!=null? List<String>.generate(json['genres'].length, (index){
      return json['genres'][index];
    }):null;

    List<CastsBean> casts=json['casts']!=null? List<CastsBean>.generate(json['casts'].length, (index){
      var obj=json['casts'][index];
      return  CastsBean(obj['alt'], obj['avatars']==null?null: AvatarsBean(obj['avatars']['small'], obj['avatars']['large'], obj['avatars']['medium']), obj['name'], obj['id']);
    }):null;

    List<DirectorsBean> directors=json['directors']!=null? List<DirectorsBean>.generate(json['directors'].length, (index){
      var obj=json['directors'][index];
      return  DirectorsBean(obj['alt'], obj['avatars']==null?null: AvatarsBean(obj['avatars']['small'], obj['avatars']['large'], obj['avatars']['medium']), obj['name'], obj['id']);
    }):null;


    return  Movie(json['title'], json['original_title']
        ,  RatingBean(double.parse('${json['rating']['max']}') , double.parse('${json['rating']['average']}') , json['rating']['stars'] , double.parse('${json['rating']['min']}') )
        , json['collect_count'], json['subtype'], json['year']
        ,  ImagesBean(json['images']['small'], json['images']['large'], json['images']['medium'])
        , json['alt'], json['id']
        , genres
        , casts
        , directors ) ;
  }

  static List<Movie> movieList(Map<String,dynamic> json){
    List<Movie> movieList= List<Movie>
        .generate(json['subjects'].length, (index){
       var obj= json['subjects'][index];
       return  Movie.formJson(obj);
    });
    return movieList;
  }
}

class DirectorsBean {
  final String alt;
  final AvatarsBean avatars;
  final String name;
  final String id;

  DirectorsBean(this.alt, this.avatars, this.name, this.id);
}


class CastsBean {
  final String alt;
  final AvatarsBean avatars;
  final String name;
  final String id;

  CastsBean(this.alt, this.avatars, this.name, this.id);
}

class AvatarsBean {
  final String small;
  final String large;
  final String medium;

  AvatarsBean(this.small, this.large, this.medium);
}

class ImagesBean {

  final String small;
  final String large;
  final String medium;

  ImagesBean(this.small, this.large, this.medium);
}

class RatingBean{
  final double max;
  final double average;
  final String stars;
  final double min;

  RatingBean(this.max, this.average, this.stars, this.min);
}