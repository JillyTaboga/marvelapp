import 'package:marvelheroes/repositorio/database.dart';

class Favorite {

  static setFavorite (List<int> listaFavoritos){
    Database.saveData(listaFavoritos);
  }

}