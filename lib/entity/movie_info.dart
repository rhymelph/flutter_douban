
import 'package:flutter_douban/entity/movie.dart';

class MovieInfo{
  final RatingBean rating;
  final int reviews_count;//影评
  final int wish_count;//想看
  final String douban_site;//
  final String year;//年代
  final ImagesBean images;//图片
  final String alt;//条目url
  final String id;//id
  final String mobile_url;//移动网站
  final String title;//标题
  final Object do_count;//再看人数
  final String share_url;//分享地址
  final Object seasons_count;//总季数
  final String schedule_url;//影讯
  final Object episodes_count;//当前季数
  final int collect_count;//看过人数
  final Object current_season;//当前季数
  final String original_title;//原名
  final String summary;//简介
  final String subtype;//条目分类
  final int comments_count;//短评论
  final int ratings_count;//评分人数
  final List<String> countries;//国家
  final List<String> genres;//类型
  final List<CastsBean> casts;//演员
  final List<DirectorsBean> directors;//导演
  final List<String> aka;
  MovieInfo(this.rating, this.reviews_count, this.wish_count, this.douban_site, this.year, this.images, this.alt, this.id, this.mobile_url, this.title, this.do_count, this.share_url, this.seasons_count, this.schedule_url, this.episodes_count, this.collect_count, this.current_season, this.original_title, this.summary, this.subtype, this.comments_count, this.ratings_count, this.countries, this.genres, this.casts, this.directors, this.aka);
  factory MovieInfo.forJson(Map<String,dynamic> json){
    List<String> genres=new List<String>.generate(json['genres'].length, (index){
      return json['genres'][index];
    });
    List<String> countries=new List<String>.generate(json['countries'].length, (index){
      return json['countries'][index];
    });
    List<String> aka=new List<String>.generate(json['aka'].length, (index){
      return json['aka'][index];
    });
    List<CastsBean> casts=new List<CastsBean>.generate(json['casts'].length, (index){
      var obj=json['casts'][index];
      return new CastsBean(obj['alt'], obj['avatars']==null?null:new AvatarsBean(obj['avatars']['small'], obj['avatars']['large'], obj['avatars']['medium']), obj['name'], obj['id']);
    });

    List<DirectorsBean> directors=new List<DirectorsBean>.generate(json['directors'].length, (index){
      var obj=json['directors'][index];
      return new DirectorsBean(obj['alt'], obj['avatars']==null?null:new AvatarsBean(obj['avatars']['small'], obj['avatars']['large'], obj['avatars']['medium']), obj['name'], obj['id']);
    });
    return new MovieInfo(new RatingBean(double.parse('${json['rating']['max']}') , double.parse('${json['rating']['average']}') , json['rating']['stars'] , double.parse('${json['rating']['min']}') )
        , json['reviews_count'], json['wish_count'], json['douban_site'], json['year']
        , new ImagesBean(json['images']['small'], json['images']['large'], json['images']['medium'])
        , json['alt'], json['id'], json['mobile_url'], json['title'], json['do_count'], json['share_url'], json['seasons_count'], json['schedule_url'], json['episodes_count'], json['collect_count'], json['current_season'], json['original_title']
        , json['summary'], json['subtype']
        , json['comments_count'], json['ratings_count'], countries, genres, casts, directors,aka);
  }
}
