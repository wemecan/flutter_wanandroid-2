import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wanandroid/data/base_bean.dart';

part 'home_bean.g.dart';

part 'home_bean.jorm.dart';

///首页列表
@JsonSerializable()
class HomeListPage extends PageBean {
  final List<HomeList> datas;

  HomeListPage(int offset, bool orver, int pageCount, int size, int total,
      int curPage, this.datas)
      : super(offset, orver, pageCount, size, total, curPage, datas);

  factory HomeListPage.fromJson(Map<String, dynamic> json) =>
      _$HomeListPageFromJson(json);

  Map<String, dynamic> toJson() => _$HomeListPageToJson(this);
}

///首页列表
@JsonSerializable()
class HomeList {
  final String apkLink;
  final int audit;
  final String author;
  final bool canEdit;
  final int chapterId;
  final String chapterName;
  final bool collect;
  final int courseId;
  final String desc;
  final String descMd;
  final String envelopePic;
  final bool fresh;
  @PrimaryKey(name: "_id", isNullable: false)
  final int id;
  final String link;
  final String niceDate;
  final String niceShareDate;
  final String origin;
  final String prefix;
  final String projectLink;
  final int publishTime;
  final int selfVisible;
  final int shareDate;
  final String shareUser;
  final int superChapterId;
  final String superChapterName;
  @HasMany(TagBean)
  final List<Tag> tags;
  final String title;
  final int type;
  final int userId;
  final int visible;
  final int zan;

  HomeList(
      this.apkLink,
      this.audit,
      this.author,
      this.canEdit,
      this.chapterId,
      this.chapterName,
      this.collect,
      this.courseId,
      this.desc,
      this.descMd,
      this.envelopePic,
      this.fresh,
      this.id,
      this.link,
      this.niceDate,
      this.niceShareDate,
      this.origin,
      this.prefix,
      this.projectLink,
      this.publishTime,
      this.selfVisible,
      this.shareDate,
      this.shareUser,
      this.superChapterId,
      this.superChapterName,
      this.tags,
      this.title,
      this.type,
      this.userId,
      this.visible,
      this.zan);

  factory HomeList.fromJson(Map<String, dynamic> json) =>
      _$HomeListFromJson(json);

  Map<String, dynamic> toJson() => _$HomeListToJson(this);
}

@GenBean()
class HomeListBean extends Bean<HomeList> with _HomeListBean{
  final TagBean tagBean;

  HomeListBean(Adapter adapter)
      : tagBean = TagBean(adapter),
        super(adapter);
}

///首页列表的tag
@JsonSerializable()
class Tag {
  @PrimaryKey(auto: true)
  int id;

  final String name;
  final String url;

  @JsonKey(ignore: true)
  @BelongsTo(HomeListBean,isNullable: false)
  int homeId;

  Tag(this.name, this.url);

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}

@GenBean()
class TagBean extends Bean<Tag> with _TagBean {
  HomeListBean _homeListBean;

  HomeListBean get homeListBean => _homeListBean??HomeListBean(adapter);

  TagBean(Adapter adapter) : super(adapter);

  @override
  String get tableName => "tags";
}

///首页的轮播图
@JsonSerializable()
class HomeBanner {
  final String desc;
  final int id;
  final String imagePath;
  final int isVisible;
  final int order;
  final String title;
  final int type;
  final String url;

  HomeBanner(this.desc, this.id, this.imagePath, this.isVisible, this.order,
      this.title, this.type, this.url);

  factory HomeBanner.fromJson(Map<String, dynamic> json) =>
      _$HomeBannerFromJson(json);

  Map<String, dynamic> toJson() => _$HomeBannerToJson(this);
}
