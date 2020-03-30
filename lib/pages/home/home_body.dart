import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid/data/home_bean.dart';
import 'package:wanandroid/http/http_status.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroid/pages/home/bloc/bloc.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context)
      ..add(StartListEvent());
  }

  void _onRefresh() async {
    _homeBloc.add(RefreshListEvent());
  }

  void _onLoading() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    /* items.add((items.length+1).toString());
    if(mounted)
      setState(() {

      });*/
    //_refreshController.loadComplete();

    _homeBloc.add(LoadListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
        buildWhen: (previous, current) {
      return current is UpdateHomeListState;
    }, builder: (context, state) {
      return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(
            complete: Text("刷新完成"),
          ),
          footer: _buildListFooter(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: _buildContent(state));
    }, listener: (context, state) {
      if (state is HomeRefreshResState) {
        if (state.res.status == Status.FAILE) {
          _refreshController.refreshFailed();
        } else if (state.res.status == Status.SUCCESS) {
          _refreshController.refreshCompleted();
        }
      } else if (state is HomeLoadResState) {
        if (state.res.status == PageStatus.FAILE) {
          _refreshController.loadFailed();
        } else if (state.res.status == PageStatus.COMPLETE) {
          _refreshController.loadComplete();
        } else if (state.res.status == PageStatus.END) {
          _refreshController.loadNoData();
        }
      }
    });
  }

  Widget _buildContent(HomeState state) {
    if (state is UpdateHomeListState) {
      return CustomScrollView(
        slivers: <Widget>[
          // 如果不是Sliver家族的Widget，需要使用SliverToBoxAdapter做层包裹
          SliverToBoxAdapter(
            child: null//_buildBanner(state.resource.data.item1),
          ),
          SliverList(
            delegate: _buildList(state.homeLists),
          )
        ],
      );
    } else {
      return null;
    }
  }

  Widget _buildListFooter() {
    return CustomFooter(builder: (context, mode) {
      Widget body;
      switch (mode) {
        case LoadStatus.idle:
          body = Text("上拉加载");
          break;
        case LoadStatus.loading:
          body = CircularProgressIndicator();
          break;
        case LoadStatus.failed:
          body = Text("加载失败！点击重试");
          break;
        case LoadStatus.canLoading:
          body = Text("松手,加载更多!");
          break;
        default:
          body = Text("没有更多数据了!");
      }
      return Container(
        height: 55.0,
        child: Center(
          child: body,
        ),
      );
    });
  }

  Widget _buildBanner(List<HomeBanner> banners) {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: Swiper(
          itemCount: banners.length,
          duration: 5000,
          pagination: new SwiperPagination(),
          itemBuilder: (context, index) {
            return Image.network(
              banners[index].imagePath,
              fit: BoxFit.fill,
            );
          },
        ));
  }

  SliverChildBuilderDelegate _buildList(List<HomeList> items) {
    return SliverChildBuilderDelegate(
      (context, index) {
        return _HomeListItemView(items[index]);
      },
      childCount: items.length,
    );
  }
}

class _HomeListItemView extends StatelessWidget {
  final HomeList item;

  _HomeListItemView(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            child: Image.asset(
              "assets/images/like_normal.png",
              width: 15,
              height: 15,
            ),
            margin: EdgeInsets.only(right: 10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  strutStyle: StrutStyle(height: 1.5),
                ),
                Row(children: <Widget>[
                  Container(
                      child: Row(children: <Widget>[
                    Text(
                      "作者：",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      item.author,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ])),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(children: <Widget>[
                        Text(
                          "分类：",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          "${item.superChapterName}/${item.chapterName}",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        )
                      ])),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Row(children: <Widget>[
                            Text(
                              "时间：",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Expanded(
                                child: Text(
                              item.niceDate,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ))
                          ]))),
                ])
              ],
            ),
          )
        ],
      ),
    );
  }
}