class Singer {
  String name;
  String description;

  Singer({this.name, this.description});

  factory Singer.fromjson(dynamic detail)
  {
    try {
      return Singer(
        name: (detail['name']) ? detail['name'] : '',
        description: (detail['description']) ? detail['description'] : '',
        );
    } 
    catch (e) {
      print('convert singer from json $detail');
      print(e);
    }
  }
}