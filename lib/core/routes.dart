/// {@nodoc}
library routes;

import 'package:angular_router/angular_router.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/page/page.dart';
import 'types.dart';
import 'widgets/menu_item.dart';

// pages
import 'package:melodyku/src/pages/_login/login.template.dart' as login_template;

import 'package:melodyku/src/pages/m_albums/albums_page.template.dart' as albums_page_template;
import 'package:melodyku/src/pages/m_playlists/playlists_page.template.dart' as playlists_page_template;
import 'package:melodyku/src/pages/m_artists/artists_page.template.dart' as artists_page_template;
import 'package:melodyku/src/pages/m_genres/genres_page.template.dart' as genres_page_template;
import 'package:melodyku/src/pages/m_top_tracks/top_tracks_page.template.dart' as top_tracks_page_template;
import 'package:melodyku/src/pages/m_vitrin/vitrin_page.template.dart' as vitrin_page_template;

import 'package:melodyku/src/pages/p_archive_artistList/archive_artistList_page.template.dart' as archive_artistList_template;
import 'package:melodyku/src/pages/p_archive_artist/archive_artist_page.template.dart' as archive_artist_template;
import 'package:melodyku/src/pages/p_archive_album/archive_album_page.template.dart' as archive_album_template;

import 'package:melodyku/src/pages/p_advanced_settings/advanced_settings_page.template.dart' as advanced_settings_template;
import 'package:melodyku/src/pages/p_archive_categories/archive_categories_page.template.dart' as archive_categories_template;
import 'package:melodyku/src/pages/p_archive_convert/archive_convert_page.template.dart' as archive_convert_template;
import 'package:melodyku/src/pages/p_downloads/downloads_page.template.dart' as downloads_template;
import 'package:melodyku/src/pages/p_favorites/favorites_page.template.dart' as favorites_template;
import 'package:melodyku/src/pages/p_history/history_page.template.dart' as history_template;
import 'package:melodyku/src/pages/p_profile/profile_page.template.dart' as profile_template;
import 'package:melodyku/src/pages/p_users/users_page.template.dart' as users_template;
import 'package:melodyku/src/pages/p_subscription/subscription_page.template.dart' as subscription_template;
import 'package:melodyku/src/pages/p_slideshows/slideshows_page.template.dart' as slideshows_template;
import 'package:melodyku/src/pages/p_slideshow/slideshow_page.template.dart' as slideshow_template;


import 'package:melodyku/src/pages/s_artist/artist_page.template.dart' as artsit_template;
import 'package:melodyku/src/pages/s_album/album_page.template.dart' as album_template;
import 'package:melodyku/src/pages/s_playlist/playlist_page.template.dart' as playlist_template;
import 'package:melodyku/src/pages/s_search/search_page.template.dart' as search_template;

Map<String, PageDefinition> pageDefinitions = pageDefinitions = 
{
  // user validation ========================
  'login' : PageDefinition(
    title         : 'login',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'login'),
                      component: login_template.LoginPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/home.png',
  ), 

  // main menu drawer =======================
  'vitrin' : PageDefinition(
    title         : 'vitrin',
    position      : MenuPosition.mainMenuDrawer,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'vitrin'),
                      component: vitrin_page_template.VitrinPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/home.png',
  ),

  'albums' : PageDefinition(
    title         : 'albums',
    position      : MenuPosition.mainMenuDrawer,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'albums'),
                      component: albums_page_template.AlbumsPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/albums.png',
  ),

  'playlists' : PageDefinition(
    title         : 'playlists',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'playlists'),
                      component: playlists_page_template.PlaylistsPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/playlists.png',
  ),

  'artists' : PageDefinition(
    title         : 'artists',
    position      : MenuPosition.mainMenuDrawer,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'artists'),
                      component: artists_page_template.ArtistsPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/artists.png', 
  ),

  'genres' : PageDefinition(
    title         : 'genres',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'genres'),
                      component: genres_page_template.GenresPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/genres.png',
  ),

  'top_tracks' : PageDefinition(
    title         : 'topTracks',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'top-tracks'),
                      component: top_tracks_page_template.TopTracksPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/top_tracks.png',
  ),

  // profile drawer ===========================
  // user
  'favorites' : PageDefinition(
    title         : 'favorites',
    position      : MenuPosition.profileDrawer,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'favorites'),
                      component: favorites_template.FavoritesPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/favorites.png',
  ),

  'history' : PageDefinition(
    title         : 'history',
    position      : MenuPosition.profileDrawer,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'history'),
                      component: history_template.HistoryPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/history.png',
  ),

  'profile' : PageDefinition(
    title         : 'profile',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'profile'),
                      component: profile_template.ProfilePageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  'downloads' : PageDefinition(
    title         : 'downloads',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'downloads'),
                      component: downloads_template.DownloadsPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/downloads.png',
  ),

  'subscription' : PageDefinition(
    title         : 'subscription',
    position      : MenuPosition.profileDrawer,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'subscription'),
                      component: subscription_template.SubscriptionPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  // archive sergeant =================================================
  'slideshows' : PageDefinition(
    title         : 'slideshows',
    position      : MenuPosition.profileDrawer,
    permissionType: PermissionType.archive_manager,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'slideshows'),
                      component: slideshows_template.SlideShowsPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  'slideshow' : PageDefinition(
    title         : 'slideshow',
    position      : MenuPosition.none,
    permissionType: PermissionType.archive_manager,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'slideshow/:_id'),
                      component: slideshow_template.SlideShowPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  'archive_artistList' : PageDefinition(
    title         : 'archive_artistList',
    position      : MenuPosition.profileDrawer,
    permissionType: PermissionType.archive_manager,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'archive-artistList'),
                      component: archive_artistList_template.ArchiveArtistListPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  'archive_artist' : PageDefinition(
    title         : 'archive_artist',
    position      : MenuPosition.none,
    permissionType: PermissionType.archive_manager,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'archive-artist/:_id'),
                      component: archive_artist_template.ArchiveArtistPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  'archive_album' : PageDefinition(
    title         : 'archive_album',
    position      : MenuPosition.none,
    permissionType: PermissionType.archive_manager,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'archive-album/:_id'),
                      component: archive_album_template.ArchiveAlbumPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  'archive_convert' : PageDefinition(
    title         : 'archive_convert',
    position      : MenuPosition.profileDrawer,
    permissionType: PermissionType.quality_management,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'archive-convert'),
                      component: archive_convert_template.ArchiveConvertPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  // category sergeant ==========================================================
  'archive_categories' : PageDefinition(
    title         : 'archive_categories',
    position      : MenuPosition.profileDrawer,
    permissionType: PermissionType.categorizing,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'archive-categories'),
                      component: archive_categories_template.ArchiveCategoriesPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  // administrator ==============================================================
  'users' : PageDefinition(
    title         : 'users',
    position      : MenuPosition.profileDrawer,
    permissionType: PermissionType.user_manager,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'users'),
                      component: users_template.UsersPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  'advanced_settings' : PageDefinition(
    title         : 'advanced_settings',
    position      : MenuPosition.profileDrawer,
    permissionType: PermissionType.advanced_settings,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'advanced-settings'),
                      component: advanced_settings_template.AdvancedSettingsPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  // single ===================================
  'artist' : PageDefinition(
    title         : 'artist',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'artist/:id'),
                      component: artsit_template.ArtistPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  'album' : PageDefinition(
    title         : 'album',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'album/:id'),
                      component: album_template.AlbumPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  'playlist' : PageDefinition(
    title         : 'playlist',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'playlist/:id'),
                      component: playlist_template.PlaylistPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/more.png',
  ),

  'search' : PageDefinition(
    title         : 'search',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'search'),
                      component: search_template.SearchPageNgFactory,
                    ),
    iconImgRef    : 'assets/svg/icon_search.svg',
  ),
};

class PageRoutes
{
  UserService _userService;

  PageRoutes(this._userService);

  List<RouteDefinition> getAll()
  {
    List<RouteDefinition> list = [
      // redirect from home to vitrin
      RouteDefinition.redirect(
        path: '/',
        redirectTo: pageDefinitions['vitrin'].route.toUrl() // RoutePaths.vitrin.toUrl()
      )
    ];

    // add all other routers
    pageDefinitions.forEach((String name, PageDefinition page) 
      { 
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
    { 
      bool  isProfilePosition = false;
      bool hasAccess = false;

      // check posion of item
      if(page.position == pType) isProfilePosition = true;

      // check user access
      if(_userService.user != null)
        hasAccess = _userService.user.hasAccess(page.permissionType);

      // add if 
      if(isProfilePosition && hasAccess)
            list.add(page.toMenuItem());
    });

    return list;
  }

  String getRouterUrl (name, [Map<String, String> params]) => pageDefinitions[name].route.toUrl(params ?? {});
}
