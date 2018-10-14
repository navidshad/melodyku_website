class Album {
  String name;
  String singer;
  String description;
  String thumbnail;

  Album({this.name, this.singer, this.description, this.thumbnail});

  factory Album.fromjson(dynamic detail)
  {
    Album album;
    try {
      album = Album(
        name: (detail['name']) ? detail['name'] : '',
        singer: (detail['singer']) ? detail['singer'] : '',
        description: (detail['description']) ? detail['description'] : '',
        thumbnail: (detail['thumbnail']) ? detail['thumbnail'] : '',
        );
    } 
    catch (e) {
      print('convert album from json $detail');
      print(e);
    }

    return album;
  }

  dynamic toDynamic()
  {
    return {
      'name'   : name,
      'singer' : singer,
      'description' : description,
      'thumbnail'   : thumbnail,
    };
  }
}