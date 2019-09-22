class Heroe {
  int idHeroe;
  String nameHeroe;
  String descriptionHeroe;
  String imagemHeroe;

  Heroe.fromMap(Map<String, dynamic> map) {
    idHeroe = map["id"];
    nameHeroe = map["name"];
    descriptionHeroe = map["description"];
    imagemHeroe = "${map["thumbnail"]["path"]}.${map["thumbnail"]["extension"]}";
  }

  Heroe.reconect(){
    idHeroe = 666;
  }
}

