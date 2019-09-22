import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:marvelheroes/blocs/series_bloc.dart';
import 'package:marvelheroes/model/heroe.dart';
import 'package:marvelheroes/model/series.dart';
import 'package:marvelheroes/widget/seriecard.dart';

import 'heroeblankcard.dart';

class FichaHeroe extends StatefulWidget {
  FichaHeroe(this.heroe);
  final Heroe heroe;

  @override
  _FichaHeroeState createState() => _FichaHeroeState(heroe);
}

class _FichaHeroeState extends State<FichaHeroe> {
  _FichaHeroeState(this.heroe);
  Heroe heroe;

  final SeriesBloc _seriesBloc = BlocProvider.getBloc<SeriesBloc>();
  StreamSubscription _listenerSeries;

  @override
  void initState() {
    print("init");
    _seriesBloc.inSerieCard.add(List());
    _seriesBloc.inLoading.add(true);
    setListenerSeries();
    _seriesBloc.getSeries(heroe.idHeroe);
    super.initState();
  }


  @override
  void reassemble() {
    print("reassemble");
    _seriesBloc.inLoading.add(true);
    super.reassemble();
  }

  @override
  void dispose() {
    _listenerSeries.cancel();
    print("dispose");
    _seriesBloc.inLoading.add(true);
    _seriesBloc.inListSeries.add(null);
    super.dispose();
  }

  @override
  void didUpdateWidget(FichaHeroe oldWidget) {
    if(oldWidget.heroe != widget.heroe){
      this.heroe = widget.heroe;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  setListenerSeries () {
    _listenerSeries = _seriesBloc.outListSeries.listen((data){
      if(data != null){
        List<Series> listSeries = data;
        List<Widget> listCards = List();
        for(Series serieTMP in listSeries){
          SerieCard serieCard = SerieCard(serieTMP);
          listCards.add(serieCard);
        }
        _seriesBloc.inSerieCard.add(listCards);
        _seriesBloc.inLoading.add(false);
      } else{
        _seriesBloc.inSerieCard.add(List());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(heroe.idHeroe);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, left: 10, bottom: 10, right: 5),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).backgroundColor
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 100),
                      padding: EdgeInsets.only(left: 10, right: 20,top: 13, bottom: 8),
                      height: 70,
                      alignment: Alignment.center,
                      child: AutoSizeText(heroe.nameHeroe,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700
                        ),
                      )
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    width: MediaQuery.of(context).size.width,
//                    height: MediaQuery.of(context).size.height/2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black26,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 40, top: 3),
                            child: Text("Description", textAlign: TextAlign.center, style: TextStyle(
                              fontWeight: FontWeight.w700
                            ),),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                              child: SingleChildScrollView(
                                child: Container(
                                  child: heroe.descriptionHeroe==""? Text(
                                    "Description not provided by Marvel... maybe it want to stay in shadows",
                                    textAlign: TextAlign.center,)
                                      : Text(heroe.descriptionHeroe, textAlign: TextAlign.justify,),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            flex: 3,
                            child: StreamBuilder<List<Widget>>(
                              stream: _seriesBloc.outSerieCard,
                              builder: (context, listCard) {
                                return StreamBuilder<bool>(
                                  initialData: true,
                                  stream: _seriesBloc.outLoading,
                                  builder: (context, loading) {
                                    return loading.data? Center(child: CircularProgressIndicator(),) :
                                    !listCard.hasData? Center(child: CircularProgressIndicator(),) :
                                    CarouselSlider(
                                        viewportFraction: 0.8,
                                        initialPage: 0,
                                        enableInfiniteScroll: false,
                                        reverse: false,
                                        autoPlay: listCard.data.length>1,
                                        autoPlayInterval: Duration(seconds: 5),
                                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                                        pauseAutoPlayOnTouch: Duration(seconds: 10),
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                        height: MediaQuery.of(context).size.height/1.5,
                                        items: listCard.data.length==0? [HeroeBlankCard()] :
                                        listCard.data
                                    );
                                  }
                                );
                              }
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(120),
                color: Theme.of(context).backgroundColor
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Image.network(heroe.imagemHeroe, fit: BoxFit.cover,),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [BoxShadow(color: Colors.black26,
                        offset: Offset(2, 4))
                    ],
                    color: Theme
                        .of(context)
                        .accentColor
                ),
                child: Icon(Icons.close, size: 30,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}