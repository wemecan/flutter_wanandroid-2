import 'package:equatable/equatable.dart';
import 'package:wanandroid/data/home_bean.dart';
import 'package:wanandroid/http/http_status.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class StartListEvent extends HomeEvent {}

class RefreshListEvent extends HomeEvent {}

class LoadListEvent extends HomeEvent {}

class HomeListEvent extends HomeEvent {
  final List<HomeList> homeLists;

  HomeListEvent(this.homeLists);

  @override
  List<Object> get props => [homeLists];
}

class HomeRefreshResEvent extends HomeEvent {
  final Resource res;

  HomeRefreshResEvent(this.res);

  @override
  List<Object> get props => [res];
}

class HomeLoadResEvent extends HomeEvent {
  final PageRes res;

  HomeLoadResEvent(this.res);

  @override
  List<Object> get props => [res];
}