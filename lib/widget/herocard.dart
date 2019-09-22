import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marvelheroes/model/heroe.dart';
import 'package:marvelheroes/widget/fichaheroe.dart';

class HeroCard extends StatefulWidget {
  HeroCard({this.heroe, this.onFav, this.desFav, this.favStream});
  final Heroe heroe;
  final Function onFav;
  final Function desFav;
  final Stream favStream;

  @override
  _HeroCardState createState() => _HeroCardState(heroe: heroe, onFav: onFav, favStream: favStream, desFav: desFav);
}

class _HeroCardState extends State<HeroCard> {
  _HeroCardState({this.heroe, this.onFav, this.desFav, this.favStream});

  Heroe heroe;
  final String semImagem = "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg";
  Function onFav;
  Function desFav;
  Stream favStream;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(HeroCard oldWidget) {
    if (oldWidget != widget) {
      setState(() {
        this.heroe = widget.heroe;
        this.onFav = widget.onFav;
        this.desFav = widget.desFav;
        this.favStream = widget.favStream;
      });
      super.didUpdateWidget(oldWidget);
    }
  }

  abrirDetalhesPersonagem({Heroe heroe}){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return new FichaHeroe(heroe);
        }
    );
  }

    @override
    Widget build(BuildContext context) {
      return Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: (){
                      abrirDetalhesPersonagem(heroe: heroe);
                    },
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, offset: Offset(6, 6))
                          ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: heroe.imagemHeroe == semImagem ? Image.asset(
                          "assets/images/back.png", fit: BoxFit.cover,) : Image
                            .network(heroe.imagemHeroe,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(heroe.nameHeroe, textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      BoxShadow(color: Colors.black26, offset: Offset(4, 4))
                    ],
                  ),)
              ],
            ),
          ),
          heroe.imagemHeroe == semImagem ? Center(
            child: Text("Image not provided"),) : Container(),
          StreamBuilder<List<int>>(
              initialData: List(),
              stream: favStream,
              builder: (context, listFav) {
                return !listFav.hasData
                    ? CircularProgressIndicator()
                    : InkWell(
                  onTap: () {
                    if (listFav.data.contains(heroe.idHeroe)) {
                      desFav(heroe.idHeroe);
                    } else {
                      onFav(heroe.idHeroe);
                    }
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
                    child: Icon(listFav.data.contains(heroe.idHeroe)
                        ? Icons.star
                        : Icons.star_border, size: 30,),
                  ),
                );
              }
          )
        ],
      );
    }
  }

