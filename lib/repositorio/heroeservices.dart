import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:marvelheroes/blocs/main_bloc.dart';
import 'package:marvelheroes/model/heroe.dart';
import 'package:marvelheroes/model/series.dart';
import 'package:marvelheroes/repositorio/helper.dart';

class HeroeServices {

  //Get HeroList
  static const String _privateKey = "311ec2c8656f5dccb8239e40a61b6b344b1dabfc";
  static const String _publicKey = "c55afed203edb807de245f137ee5912f";
  static String urlListaHeroe = "https://gateway.marvel.com:443/v1/public/characters";

  static Future<List<Heroe>> getHeroes({int offset, String name}) async {
    List<Heroe> listaHeroes = List();
      listaHeroes = await getHeroesInServer(offset: offset, name: name);
        return listaHeroes;
  }

  static Future<List<Heroe>> getHeroesInServer(
      {int offset, String name}) async {
    String url = urlListaHeroe;
    if (offset == null) {
      offset = 0;
    }
    List<Heroe> listaHeroes = List();
    try {
      Response response = await Dio().get(url,
          queryParameters: query(offset: offset, nameHeroe: name)
      );
      List<Heroe> listaHeroes = List();
      Map<dynamic, dynamic> json = response.data;
      if (json["data"]["results"] != null) {
        json["data"]["results"].forEach((heroi) {
          Heroe heroeTMP = Heroe.fromMap(heroi);
              if (heroeTMP.imagemHeroe !=
                  'http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg') {
                listaHeroes.add(heroeTMP);
          }
        });
      }
      return listaHeroes;
    } catch (e) {
      listaHeroes.add(Heroe.reconect());
      return listaHeroes;
    }
  }

  static Map<String, dynamic> query({int offset, String nameHeroe}) {
    String ts = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    String hash = Helper.generateMd5(ts + _privateKey + _publicKey).toString();
    Map <String, dynamic> query;
    if (offset == null) {
      offset = 0;
    }
    if (nameHeroe == null || nameHeroe == "") {
      query =
      {
        "ts": ts,
        "apikey": _publicKey,
        "hash": hash,
        "offset": offset,
        "orderBy": "name",
        "limit": "100",
      };
    } else {
      query =
      {
        "nameStartsWith": nameHeroe,
        "ts": ts,
        "apikey": _publicKey,
        "hash": hash,
        "offset": offset,
        "orderBy": "name",
        "limit": "100",
      };
    }
    return query;
  }

  static Future<List<Heroe>> getFavorite({int id}) async {
    String url = "https://gateway.marvel.com:443/v1/public/characters/$id";
    List<Heroe> listaHeroes = List();
    try {
      Response response = await Dio().get(url,
          queryParameters: favorito()
      );
      Map<dynamic, dynamic> json = response.data;
      if (json["data"]["results"] != null) {
        json["data"]["results"].forEach((heroi) {
          Heroe heroeTMP = Heroe.fromMap(heroi);
            if (heroeTMP.imagemHeroe !=
                'http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg') {
              listaHeroes.add(heroeTMP);
          }
        });
        return listaHeroes;
      }
    } catch (e) {
      print(e);
      listaHeroes.add(Heroe.reconect());
      return listaHeroes;
    }
  }

  static Map<String, dynamic> favorito() {
    String ts = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    String hash = Helper.generateMd5(ts + _privateKey + _publicKey).toString();
    Map <String, dynamic> query;
    query =
    {
      "ts": ts,
      "apikey": _publicKey,
      "hash": hash,
      "orderBy": "name",
      "limit": "100",
    };
    return query;
  }

  static Future<List<Series>> getSeries({int idHeroe, int offset}) async {
    String url = "https://gateway.marvel.com:443/v1/public/characters/$idHeroe/series";
    try {
      Response response = await Dio().get(url,
          queryParameters: querySeries(offset: offset)
      );
      Map<dynamic, dynamic> json = response.data;
      if (json["data"]["results"] != null) {
        List<Series> listaSeries = List();
        json["data"]["results"].forEach((serie) {
          Series serieTMP = Series.fromMap(serie);
          if (serieTMP.imageSerie !=
              'http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg') {
            listaSeries.add(serieTMP);
          }
        });
        return listaSeries;
      }
    } catch (e) {
      print(e);
    }
  }

  static Map<String, dynamic> querySeries({int offset, int idHeroe}) {
    String ts = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    String hash = Helper.generateMd5(ts + _privateKey + _publicKey).toString();
    Map <String, dynamic> query;
    if (offset == null) {
      offset = 0;
    }
    query =
    {
      "ts": ts,
      "apikey": _publicKey,
      "hash": hash,
      "offset": offset,
      "orderBy": "-startYear",
      "limit": "100",
    };
    return query;
  }

}

