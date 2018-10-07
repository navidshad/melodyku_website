class Album {
  String name;
  String singer;
  String description;

  Album({this.name, this.singer, this.description});

  factory Album.fromjson(dynamic detail)
  {
    try {
      return Album(
        name: (detail['name']) ? detail['name'] : '',
        singer: (detail['singer']) ? detail['singer'] : '',
        description: (detail['description']) ? detail['description'] : '',
        );
    } 
    catch (e) {
      print('convert album from json $detail');
      print(e);
    }
  }
}