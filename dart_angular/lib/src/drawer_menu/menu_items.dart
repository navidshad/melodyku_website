import '../routting/routes.dart';

class Item {
  String name;
  String icon;
  String img_ref;
  String url;

  Item(this.name, this.icon, this.img_ref, this.url);
}
List<Item> items = [
  Item('ویترین', null, 'assets/imgs/icons/home.png', RoutePaths.vitrin.toUrl()),
  Item('ویترین', null, 'assets/imgs/icons/albums.png', ''),
  Item('ویترین', null, 'assets/imgs/icons/artists.png', RoutePaths.artists.toUrl()),
  Item('ویترین', null, 'assets/imgs/icons/genres.png', ''),
  Item('ویترین', null, 'assets/imgs/icons/top_tracks.png', ''),
];