import 'package:flutter/material.dart';
import 'package:marvelheroes/model/series.dart';
import 'package:url_launcher/url_launcher.dart';

class SerieCard extends StatelessWidget {
  SerieCard(this.serie);
  Series serie;
  final String notImagem = 'http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
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
              child: InkWell(
                onTap: (){
                  launch(serie.url);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: serie.imageSerie==notImagem? Image.asset("assets/images/back.png", fit: BoxFit.cover,)
                      : Image.network(serie.imageSerie,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(serie.titleSerie, textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                shadows: [
                  BoxShadow(color: Colors.black26, offset: Offset(4, 4))
                ],
              ),),
          )
        ],
      ),
    );
  }
}
