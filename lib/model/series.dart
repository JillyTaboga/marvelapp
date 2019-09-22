class Series {

  int idSerie;
  String titleSerie;
  String url;
  int startYear;
  int endYear;
  String imageSerie;

  Series.fromMap(Map<String, dynamic> map) {
    idSerie = map["id"];
    titleSerie = map["title"];
    url = map["urls"][0]["url"];
    startYear = map["startYear"];
    endYear = map["endYear"];
    imageSerie = "${map["thumbnail"]["path"]}.${map["thumbnail"]["extension"]}";
  }

}