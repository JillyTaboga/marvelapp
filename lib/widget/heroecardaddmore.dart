import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:marvelheroes/blocs/main_bloc.dart';

class HeroeCardAddMore extends StatelessWidget {
  HeroeCardAddMore(this.onTap);
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(5, 5))]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    splashColor: Theme.of(context).accentColor,
                    onTap: (){onTap();},
                    child: Image.asset("assets/images/back.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.refresh, size: 50,
              ),
              SizedBox(
                height: 15,
              ),
              Text("Try to Reconect", textAlign: TextAlign.center, style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                shadows: [BoxShadow(color: Colors.black26, offset: Offset(8, 8))],
              )
              )
            ],
          ),
        )
      ],
    );
  }
}