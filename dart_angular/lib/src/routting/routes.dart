import 'package:angular_router/angular_router.dart';

import '../services/language_service.dart';
import '../services/user_service.dart';
import '../class/page/page_definition.dart';
import '../class/types.dart';
import '../class/widgets/menu_item.dart';

// pages
import '../pages/_email_confirmation/email_confirmation.template.dart' as email_confirmation_template;
import '../pages/_password_reset/password_reset.template.dart' as password_reset_template;

import '../pages/m_albums/albums_page.template.dart' as albums_page_template;
import '../pages/m_playlists/playlists_page.template.dart' as playlists_page_template;
import '../pages/m_artists/artists_page.template.dart' as artists_page_template;
import '../pages/m_genres/genres_page.template.dart' as genres_page_template;
import '../pages/m_top_tracks/top_tracks_page.template.dart' as top_tracks_page_template;
import '../pages/m_vitrin/vitrin_page.template.dart' as vitrin_page_template;

import '../pages/p_archive_artistList/archive_artistList_page.template.dart' as archive_artistList_template;
import '../pages/p_archive_artist/archive_artist_page.template.dart' as archive_artist_template;
import '../pages/p_archive_album/archive_album_page.template.dart' as archive_album_template;

import '../pages/p_advanced_settings/advanced_settings_page.template.dart' as advanced_settings_template;
import '../pages/p_archive_categories/archive_categories_page.template.dart' as archive_categories_template;
import '../pages/p_archive_convert/archive_convert_page.template.dart' as archive_convert_template;
import '../pages/p_archive_upload/archive_upload_page.template.dart' as archive_upload_template;
import '../pages/p_downloads/downloads_page.template.dart' as downloads_template;
import '../pages/p_favorites/favorites_page.template.dart' as favorites_template;
import '../pages/p_history/history_page.template.dart' as history_template;
import '../pages/p_profile/profile_page.template.dart' as profile_template;
import '../pages/p_users/users_page.template.dart' as users_template;
import '../pages/p_subscription/subscription_page.template.dart' as subscription_template;

import '../pages/s_artist/artist_page.template.dart' as artsit_template;
import '../pages/s_album/album_page.template.dart' as album_template;
import '../pages/s_playlist/playlist_page.template.dart' as playlist_template;

Map<String, PageDefinition> pageDefinitions = pageDefinitions = 
{
  // user validation ========================
  'email_confirmation' : PageDefinition(
    title         : 'email_confirmation',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'email_confirmation/token/:token/tokenId/:tokenId'),
                      component: email_confirmation_template.EmailConfirmationPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/home.png',
  ),
  
  'password_reset' : PageDefinition(
    title         : 'password_reset',
    position      : MenuPosition.none,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'password_reset/token/:token/tokenId/:tokenId'),
                      component: password_reset_template.PasswordResetPageNgFactory,
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
    position      : MenuPosition.mainMenuDrawer,
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
    position      : MenuPosition.profileDrawer,
    permissionType: PermissionType.customer_access,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'downloads'),
                      component: downloads_template.DownloadsPageNgFactory,
                    ),
    iconImgRef    : 'assets/imgs/icons/downloads.png',
  ),

  // archive sergeant
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

  'archive_upload' : PageDefinition(
    title         : 'archive_upload',
    position      : MenuPosition.profileDrawer,
    permissionType: PermissionType.archive_manager,
    route         : RouteDefinition(
                      routePath: RoutePath(path: 'archive-upload'),
                      component: archive_upload_template.ArchiveUploadPageNgFactory,
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

  // category sergeant
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

  // administrator
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

  String getRouterUrl (name, [Map params]) => pageDefinitions[name].route.toUrl(params);
}
