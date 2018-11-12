import 'routes.dart';

class DrawerItem {
  String name;
  String icon;
  String img_ref;
  String url;

  DrawerItem(this.name, this.icon, this.img_ref, this.url);
}
List<DrawerItem> menuItems = [
  DrawerItem('ویترین', null, 'assets/imgs/icons/home.png', RoutePaths.vitrin.toUrl()),
  DrawerItem('ویترین', null, 'assets/imgs/icons/albums.png', ''),
  DrawerItem('ویترین', null, 'assets/imgs/icons/artists.png', RoutePaths.artists.toUrl()),
  DrawerItem('ویترین', null, 'assets/imgs/icons/genres.png', ''),
  DrawerItem('ویترین', null, 'assets/imgs/icons/top_tracks.png', ''),
];