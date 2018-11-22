import 'package:angular_router/angular_router.dart';

import '../services/language_service.dart';
import '../class/page/page_definition.dart';
import '../class/types.dart';
import '../pages/vitrin/vitrin_page_component.template.dart' as vitrin_page_template;
import '../pages/artists/artists_page_component.template.dart' as artists_page_template;
import '../class/widgets/menu_item.dart';

class PageRoutes
{
  LanguageService _lang;
  var _pageDefinitions;

  PageRoutes(this._lang)
  {
    createPages();
  }

  get pageDefinitions =>
    _pageDefinitions;

  createPages()
  {
        _pageDefinitions = 
    {
      // main menu drawer =======================
      'vitrin' : PageDefinition( _lang,
        title         : 'vitrin',
        position      : MenuPosition.mainMenuDrawer,
        permissionType: PermissionType.freemium_access,
        route         : RouteDefinition(
                          routePath: RoutePath(path: 'vitrin'),
                          component: vitrin_page_template.VitrinPageComponentNgFactory,
                        ),
        iconImgRef    : 'assets/imgs/icons/home.png',
      ),

      'albums' : PageDefinition( _lang,
        title         : 'albums',
        position      : MenuPosition.mainMenuDrawer,
        permissionType: PermissionType.freemium_access,
        route         : null,
        iconImgRef    : 'assets/imgs/icons/albums.png',
      ),

      'artists' : PageDefinition( _lang,
        title         : 'artists',
        position      : MenuPosition.mainMenuDrawer,
        permissionType: PermissionType.freemium_access,
        route         : RouteDefinition(
                          routePath: RoutePath(path: 'artists'),
                          component: artists_page_template.ArtistsPageComponentNgFactory,
                        ),
        iconImgRef    : 'assets/imgs/icons/artists.png', 
      ),

      'genres' : PageDefinition( _lang,
        title         : 'genres',
        position      : MenuPosition.mainMenuDrawer,
        permissionType: PermissionType.freemium_access,
        route         : null,
        iconImgRef    : 'assets/imgs/icons/genres.png',
      ),

      'top_tracks' : PageDefinition( _lang,
        title         : 'topTracks',
        position      : MenuPosition.mainMenuDrawer,
        permissionType: PermissionType.freemium_access,
        route         : null,
        iconImgRef    : 'assets/imgs/icons/top_tracks.png',
      ),

      // profile drawer ===========================
      'favorites' : PageDefinition( _lang,
        title         : 'favorites',
        position      : MenuPosition.profileDrawer,
        permissionType: PermissionType.freemium_access,
        route         : null,
        iconImgRef    : 'assets/imgs/icons/favorites.png',
      ),

      'history' : PageDefinition( _lang,
        title         : 'history',
        position      : MenuPosition.profileDrawer,
        permissionType: PermissionType.freemium_access,
        route         : null,
        iconImgRef    : 'assets/imgs/icons/history.png',
      ),

      'downloads' : PageDefinition( _lang,
        title         : 'downloads',
        position      : MenuPosition.profileDrawer,
        permissionType: PermissionType.freemium_access,
        route         : null,
        iconImgRef    : 'assets/imgs/icons/downloads.png',
      ),
    };
  }

  List<RouteDefinition> getAll()
  {
    List<RouteDefinition> list = [
      // redirect from home to vitrin
      RouteDefinition.redirect(
        path: '',
        redirectTo: pageDefinitions['vitrin'].route.toUrl() // RoutePaths.vitrin.toUrl()
      )
    ];

    // add all other routers
    pageDefinitions.forEach((String name, PageDefinition page) 
      { 
        //print('get router of $name');
        if(page.route != null) list.add(page.route); 
      });

    return list;
  }

  List<MenuItem> getMainMenuItems()
  {
    MenuPosition pType = MenuPosition.mainMenuDrawer;
    List<MenuItem> list = [];

    pageDefinitions.forEach((String name, PageDefinition page) 
    { if(page.position == pType) list.add(page.toMenuItem()); });

    return list;
  }

  List<MenuItem> getProfileMenuItems()
  {
    MenuPosition pType = MenuPosition.profileDrawer;
    List<MenuItem> list = [];

    pageDefinitions.forEach((String name, PageDefinition page) 
    { if(page.position == pType) list.add(page.toMenuItem()); });

    return list;
  }
}
