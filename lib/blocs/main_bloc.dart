
import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:marvelheroes/model/heroe.dart';
import 'package:marvelheroes/repositorio/database.dart';
import 'package:marvelheroes/repositorio/heroeservices.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc extends BlocBase{
  MainBloc (){
    setAutoSaveFavoritos();
    filtrandoFavController.sink.add(false);
    inListaHeroes.add(List());
    inLoading.add(false);
  }

  List<Widget> listHeroCard = List();

  //Loading
  BehaviorSubject<bool> _loadingController = BehaviorSubject();
  Observable<bool> get outLoading => _loadingController.stream;
  Sink<bool> get inLoading => _loadingController.sink;
  loading(){
    inLoading.add(true);
  }
  idle(){
    inLoading.add(false);
  }

  //Lista de Herois
  BehaviorSubject<List<Heroe>> _listaHeroesController = BehaviorSubject();
  Observable<List<Heroe>> get outListaHeroes => _listaHeroesController.stream;
  Sink<List<Heroe>> get inListaHeroes => _listaHeroesController.sink;

  getHeroeHeroeList({int offset})async{
    if(offset == null){
      offSetController.sink.add(0);
      listHeroCard.clear();
    }
    List<Heroe> listHeroes = await HeroeServices.getHeroes(offset: offset, name: _textNameController.value);
    if(!filtrandoFavController.value) {
      _listaHeroesController.sink.add(listHeroes);
    }
  }

//Controles de Herois por filtro de nome
  BehaviorSubject<String> _textNameController = BehaviorSubject();
  Observable<String> get outTextName => _textNameController.stream;
  Sink<String> get inTextName => _textNameController.sink;

  //Cards de Herois
  BehaviorSubject<List<Widget>> _listaCardsHeroesController = BehaviorSubject();
  Observable<List<Widget>> get outListaCardsHeroes => _listaCardsHeroesController.stream;
  Sink<List<Widget>> get inListaCardsHeroes => _listaCardsHeroesController.sink;

  adicionarCardsHeroes (Widget listCards){
    listHeroCard.add(listCards);
    _listaCardsHeroesController.sink.add(listHeroCard);
    inLoading.add(false);
  }

  //OffSet
  BehaviorSubject<int> offSetController = BehaviorSubject();
  Observable<int> get outOffSet => offSetController.stream;
  Sink<int> get inOffSet => offSetController.sink;

  Future<bool> trocar20 ()async{
    if(offSetController.value == null){
      offSetController.sink.add(0);
    }
    int of = await offSetController.value+100;
    getHeroeHeroeList(offset: of);
    print(of);
    offSetController.sink.add(of);
  }

  //Favoritos
  BehaviorSubject<int> _idHeroeController = BehaviorSubject();
  Observable<int> get outIdHeroe => _idHeroeController.stream;
  Sink<int> get inIdHeroe => _idHeroeController.sink;

  BehaviorSubject<List<int>> listaFavoritosController = BehaviorSubject();
  Stream<List<int>> get outListaFavoritos => listaFavoritosController.stream;
  Sink<List<int>> get inListaFavoritos => listaFavoritosController.sink;

  List<int> listaFavoritos = List();

  favoritar (int idHeroe){
    listaFavoritos.add(idHeroe);
    listaFavoritos.sort();
    listaFavoritosController.sink.add(listaFavoritos);
    print(listaFavoritos);
  }

  desfavoritar (int idHeroe){
    listaFavoritos.remove(idHeroe);
    listaFavoritos.sort();
    listaFavoritosController.sink.add(listaFavoritos);
  }

  getFavorito({int id})async{
    loading();
    List<Heroe> listTMP = await HeroeServices.getFavorite(id: id);
    if(_listaHeroesController.value != null) {
      _listaHeroesController.value.clear();
    }
    _listaHeroesController.sink.add(listTMP);
    idle();
  }

  BehaviorSubject<bool> filtrandoFavController = BehaviorSubject();
  Observable<bool> get outFiltrandoFav => filtrandoFavController.stream;
  Sink<bool> get inFiltrandoFav => filtrandoFavController.sink;

  StreamSubscription _autoSaveFavoritos;
  setAutoSaveFavoritos(){
    _autoSaveFavoritos = outListaFavoritos.listen((data){
      Database.saveData(data);
    });
  }

  recuperarFavoritosDoArquivo () async{
    String a = await Database.readData();
    print(a);
    if(a == null || a == ""){
      List<int> data = List();
      data.addAll([1009220,1009351,1009718]);
      Database.saveData(data);
    }
    List<dynamic> listFav = json.decode(await Database.readData());
    print(listFav);
    List<int> listaFavInt = List();
    for(int idString in listFav){
      listaFavInt.add(idString);
    }
    listaFavoritos = listaFavInt;
    inListaFavoritos.add(listaFavInt);
  }

//Controle de Som
  BehaviorSubject<bool> _somController = BehaviorSubject();
  Observable<bool> get outSom => _somController.stream;
  Sink<bool> get inSom => _somController.sink;

  @override
  void dispose() {
    _listaHeroesController.close();
    _listaCardsHeroesController.close();
    _idHeroeController.close();
    offSetController.close();
    _loadingController.close();
    _somController.close();
    _textNameController.close();
    listaFavoritosController.close();
    filtrandoFavController.close();
    super.dispose();
  }

}