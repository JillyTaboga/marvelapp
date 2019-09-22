import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:marvelheroes/blocs/main_bloc.dart';
import 'package:marvelheroes/widget/herocard.dart';
import 'package:marvelheroes/widget/heroeblankcard.dart';
import 'package:marvelheroes/widget/heroecardaddmore.dart';

import 'model/heroe.dart';

class InicialScreen extends StatefulWidget {
  @override
  _InicialScreenState createState() => _InicialScreenState();
}

class _InicialScreenState extends State<InicialScreen> {
  StreamSubscription _listenerHeroes;
  StreamSubscription _listenerFavoritos;
  List<int> listaFavoritos = List();
  final MainBloc _mainBloc = BlocProvider.getBloc<MainBloc>();
  TextEditingController nameController = TextEditingController();

  setListenerFavoritos(){
    _listenerFavoritos = _mainBloc.outListaFavoritos.listen((data){
      print(data);
      if (data != null){
          listaFavoritos = data;
      }
    });
  }

  @override
  void initState() {
    setListenerFavoritos();
    setListenerHeroe();
    verificarFavoritos();
    tocarSom();
    super.initState();
  }

  verificarFavoritos()async{
    await _mainBloc.recuperarFavoritosDoArquivo();
    if(_mainBloc.listaFavoritosController.value != null){
      print("not null");
      if(_mainBloc.listaFavoritosController.value.length > 0) {
        _mainBloc.inFiltrandoFav.add(true);
        filtrarFavoritos();
      }else{
        _mainBloc.getHeroeHeroeList();
      }
    }else{
      _mainBloc.getHeroeHeroeList();
    }
}

  AudioCache player = AudioCache();
  AudioPlayer play;
  tocarSom()async{
    player.clearCache();
    play = await player.loop("avengertheme.mp3", volume: 0.1);
  }

  @override
  void dispose() {
    _listenerFavoritos.cancel();
    _listenerHeroes.cancel();
    play.stop();
    player.clearCache();
    play = null;
    super.dispose();
  }

  @override
  void deactivate() {
    play.stop();
    player.clearCache();
    play = null;
    super.deactivate();
  }

  desligarSom()async{
    if(play != null){
      play.stop();
      play=null;
      player.clearCache();
      _mainBloc.inSom.add(false);
    }else{
      play = await player.loop("avengertheme.mp3", volume: 0.1);
      _mainBloc.inSom.add(true);
    }
  }

  enviarTextPesquisa (String texto) async{
    _mainBloc.loading();
    _mainBloc.inFiltrandoFav.add(false);
    _mainBloc.inTextName.add(texto);
    await _mainBloc.getHeroeHeroeList();
    _mainBloc.idle();
  }

  chamarMais20(int offset,int tamanho) async{
    if(nameController.value != null || nameController.value != ""){
      return;
    }
    if(_mainBloc.filtrandoFavController.value){
      return;
    }
    if(tamanho == 1){
      return;
    }
    if(offset == tamanho-1){
     bool erro = await _mainBloc.trocar20();
    }
  }

  setListenerHeroe()async{
    _listenerHeroes = _mainBloc.outListaHeroes.listen((data)async{
      if(data != null) {
        _mainBloc.inLoading.add(true);
        await data.sort((a,b) => a.nameHeroe.compareTo(b.nameHeroe));
        for (Heroe heroeTMP in data) {
          if(heroeTMP.idHeroe == 666){
            _mainBloc.adicionarCardsHeroes(HeroeCardAddMore(filtrarFavoritos));
          }else {
            _mainBloc.adicionarCardsHeroes(HeroCard(
              heroe: heroeTMP,
              onFav: _mainBloc.favoritar,
              desFav: desfav,
              favStream: _mainBloc.outListaFavoritos,
            )
            );
          }
        }
      }
    });
  }

  desfav (int heroID){
    _mainBloc.desfavoritar(heroID);
    if(_mainBloc.filtrandoFavController.value) {
      filtrarFavoritos();
    }
  }

  filtrarFavoritos()async{
    _mainBloc.inLoading.add(true);
    nameController.clear();
    _mainBloc.inTextName.add(null);
    _mainBloc.inFiltrandoFav.add(true);
    _mainBloc.listHeroCard.clear();
    print(_mainBloc.listaFavoritosController.value);
    List<int> ids = _mainBloc.listaFavoritosController.value;
    ids.sort();
    for(int idTMP in ids){
     await _mainBloc.getFavorito(id: idTMP);
    }
    _mainBloc.inLoading.add(false);
  }

  desfiltrarFavoritos()async{
    _mainBloc.inLoading.add(true);
    _mainBloc.inFiltrandoFav.add(false);
    await _mainBloc.getHeroeHeroeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/marvellogo.png"),
        centerTitle: true,
        leading: StreamBuilder<bool>(
          stream: _mainBloc.outSom,
          initialData: true,
          builder: (context, outSom) {
            return IconButton(
                icon: Icon(outSom.data? Icons.volume_off : Icons.audiotrack),
                onPressed: desligarSom);
          }
        ),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<List<Widget>>(
              stream: _mainBloc.outListaCardsHeroes,
              builder: (context, heroeList) {
                return StreamBuilder<List<int>>(
                  stream: _mainBloc.outListaFavoritos,
                  builder: (context, snapshot) {
                    return StreamBuilder<bool>(
                      initialData: true,
                      stream: _mainBloc.outLoading,
                      builder: (context, loadingStream) {
                        return loadingStream.data? CircularProgressIndicator() : !heroeList.hasData? Center(child: CircularProgressIndicator(),)
                            : CarouselSlider(
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          onPageChanged: (position){chamarMais20(position, heroeList.data.length);},
                          autoPlay: heroeList.data.length>1,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          pauseAutoPlayOnTouch: Duration(seconds: 10),
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          height: MediaQuery.of(context).size.height/1.5,
                          items: heroeList.data.length==0? [HeroeBlankCard()] :
                          heroeList.data
                        );
                      }
                    );
                  }
                );
              }
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(top: 5),
              alignment: Alignment.center,
              height: 55,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<bool>(
                        initialData: false,
                        stream: _mainBloc.outFiltrandoFav,
                        builder: (context, favoritado) {
                          return InkWell(
                            onTap: (){
                              if(favoritado.data){
                                desfiltrarFavoritos();
                              }else{
                                filtrarFavoritos();
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10, bottom: 5),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                color: favoritado.data? Theme.of(context).backgroundColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Favorites"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(favoritado.data?Icons.star : Icons.star_border),
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                  VerticalDivider(
                    indent: 5,
                    endIndent: 5,
                    thickness: 2,
                  ),
                  Expanded(
                    child: StreamBuilder<String>(
                      stream: _mainBloc.outTextName,
                      builder: (context, text) {
                        return Container(
                          margin: EdgeInsets.only(right: 10, bottom: 5),
                          padding: EdgeInsets.only(right: 30),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                              color: text.data!=null? text.data!=""? Theme.of(context).backgroundColor : Colors.transparent : Colors.transparent,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextFormField(
                            controller: nameController,
                            maxLines: 1,
                            minLines: 1,
                            onFieldSubmitted:
                                (texto){
                              enviarTextPesquisa(texto);
                            },
                            onSaved: (texto){
                              enviarTextPesquisa(texto);
                            },
                            textInputAction: TextInputAction.search,
                            textCapitalization: TextCapitalization.words,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Hero Name",
                                hintStyle: TextStyle(
                                    fontSize: 14
                                ),
                                suffixIcon: Icon(Icons.search)
                            ),
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
