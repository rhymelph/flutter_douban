
class Movie{
  final String title;//标题
  final String original_title;//原标题
  final RatingBean rating;
  final int collect_count;
  final String subtype;
  final String year;
  final ImagesBean images;
  final String alt;
  final String id;
  final List<String> genres;
  final List<CastsBean> casts;
  final List<DirectorsBean> directors;

  Movie(this.title, this.original_title, this.rating, this.collect_count, this.subtype, this.year, this.images, this.alt, this.id, this.genres, this.casts, this.directors);

  factory Movie.formJson(Map<String,dynamic> json){
    List<String> genres=new List<String>.generate(json['genres'].length, (index){
      return json['genres'][index];
    });

    List<CastsBean> casts=new List<CastsBean>.generate(json['casts'].length, (index){
      var obj=json['casts'][index];
      return new CastsBean(obj['alt'], obj['avatars']==null?null:new AvatarsBean(obj['avatars']['small'], obj['avatars']['large'], obj['avatars']['medium']), obj['name'], obj['id']);
    });

    List<DirectorsBean> directors=new List<DirectorsBean>.generate(json['directors'].length, (index){
      var obj=json['directors'][index];
      return new DirectorsBean(obj['alt'], obj['avatars']==null?null:new AvatarsBean(obj['avatars']['small'], obj['avatars']['large'], obj['avatars']['medium']), obj['name'], obj['id']);
    });


    return new Movie(json['title'], json['original_title']
        , new RatingBean(double.parse('${json['rating']['max']}') , double.parse('${json['rating']['average']}') , json['rating']['stars'] , double.parse('${json['rating']['min']}') )
        , json['collect_count'], json['subtype'], json['year']
        , new ImagesBean(json['images']['small'], json['images']['large'], json['images']['medium'])
        , json['alt'], json['id']
        , genres
        , casts
        , directors ) ;
  }

  static List<Movie> MovieList(Map<String,dynamic> json){
    List<Movie> movieList=new List<Movie>
        .generate(json['subjects'].length, (index){
       var obj= json['subjects'][index];
       return new Movie.formJson(obj);
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