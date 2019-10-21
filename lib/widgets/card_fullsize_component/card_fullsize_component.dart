import 'package:angular/angular.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/pips/pips.dart';

@Component(
	selector:'card-fullsize',
	templateUrl: 'card_fullsize_component.html',
	styleUrls: ['card_fullsize_component.css'],
	directives: [
		coreDirectives,
		DirectionDirective,
	],
  pipes: [
    UpperCasePipe
  ]
)
class CardFullsizeComponent
{
	LanguageService lang;

	@Input()
	Card card;

	CardFullsizeComponent(this.lang);

	String get image =>
		'Url("${card.thumbnail}")';
}