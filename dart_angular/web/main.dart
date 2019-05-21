import 'package:angular/angular.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'package:angular_router/angular_router.dart';
//import 'package:pwa/client.dart' as pwa;

import 'package:melodyku/app_component.template.dart' as ng;

import 'main.template.dart' as self;

import 'package:melodyku/mongo_stitch/js_interop.dart';

@GenerateInjector([
  routerProvidersHash, // You can use routerProviders in production
  ClassProvider(Client, useClass: BrowserClient),
])
final InjectorFactory injector = self.injector$Injector;

void main() 
{
	log('make log form js');
  runApp(ng.AppComponentNgFactory, createInjector: injector);

  // register PWA ServiceWorker for offline caching.
  //new pwa.Client();
}
