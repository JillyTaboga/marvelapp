import 'package:flutter/material.dart';

class HeroeBlankCard extends StatelessWidget {
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
                  child: Image.asset("assets/images/back.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text("No Hero for Hire", textAlign: TextAlign.center, style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              shadows: [BoxShadow(color: Colors.black26, offset: Offset(4, 4))],
            ),
            ),
            Text("try another name", textAlign: TextAlign.center, style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              shadows: [BoxShadow(color: Colors.black26, offset: Offset(4, 4))],
            ),
            ),
          ],
        ),
      ],
    );
  }
}
