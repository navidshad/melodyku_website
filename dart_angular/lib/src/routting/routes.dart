import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import '../pages/vitrin/vitrin_page_component.template.dart' as vitrin_page_template;
import '../pages/artists/artists_page_component.template.dart' as artists_page_template;

export 'route_paths.dart';

class Routes
{
  static final vitrin = RouteDefinition(
    routePath: RoutePaths.vitrin,
    component: vitrin_page_template.VitrinPageComponentNgFactory,
  );

  static final artists = RouteDefinition(
    routePath: RoutePaths.artists,
    component: artists_page_template.ArtistsPageComponentNgFactory,
  );

  // redirect to home
  static final rToHome = RouteDefinition.redirect(
    path: '',
    redirectTo: RoutePaths.vitrin.toUrl()
  );

  static final all = <RouteDefinition>[
    rToHome,
    vitrin,
    artists,
  ];
}
