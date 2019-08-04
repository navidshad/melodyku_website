@JS()
//library main;
library swiper;

import 'package:js/js.dart';

@JS()
abstract class Swiper
{
	external factory Swiper(String selector, [dynamic options]);
	external void update();
}