import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
	selector:'grid-masonry',
	templateUrl: 'grid_masonry_component.html',
	styleUrls: ['grid_masonry_component.css'],
	directives: [
		coreDirectives,
		CardFullsizeComponent,
	]
)
class GridMasonryComponent
{
	LanguageService lang;

	@Input()
	List<Card> cards;

	GridMasonryComponent(this.lang);
}