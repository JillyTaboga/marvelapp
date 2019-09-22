
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/widgets.dart';
import 'package:marvelheroes/model/series.dart';
import 'package:marvelheroes/repositorio/heroeservices.dart';
import 'package:rxdart/rxdart.dart';

class SeriesBloc extends BlocBase {
  SeriesBloc(){
    inLoading.add(true);
  }

  BehaviorSubject<List<Series>> _listSeriesController = BehaviorSubject();
  Observable<List<Series>> get outListSeries => _listSeriesController.stream;
  Sink<List<Series>> get inListSeries => _listSeriesController.sink;

  getSeries(int idHeroe)async{
    inLoading.add(true);
    inListSeries.add(await HeroeServices.getSeries(idHeroe: idHeroe));
  }

  BehaviorSubject<List<Widget>> _listSerieCardController = BehaviorSubject();
  Observable<List<Widget>> get outSerieCard => _listSerieCardController.stream;
  Sink<List<Widget>> get inSerieCard => _listSerieCardController.sink;

  BehaviorSubject<bool> _loadingController = BehaviorSubject();
  Observable<bool> get outLoading => _loadingController.stream;
  Sink<bool> get inLoading => _loadingController.sink;

  @override
  void dispose() {
    _listSeriesController.close();
    _listSerieCardController.close();
    _loadingController.close();
    super.dispose();
  }

}