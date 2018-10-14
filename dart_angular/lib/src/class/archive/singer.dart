class Singer {
  String name;
  String description;
  String thumbnail;

  Singer({this.name, this.description, this.thumbnail});

  factory Singer.fromjson(dynamic detail)
  {
    Singer singer;
    try {
      singer =  Singer(
        name: (detail['name']) ? detail['name'] : '',
        description: (detail['description']) ? detail['description'] : '',
        thumbnail: (detail['thumbnail']) ? detail['thumbnail'] : '',
        );
    } 
    catch (e) {
      print('convert singer from json $detail');
      print(e);
    }
    return singer;
  }

  dynamic toDynamic()
  {
    return {
      'name'        : name,
      'description' : description,
      'thumbnail'   : thumbnail
    };
  }
}