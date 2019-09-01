import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'category-presentor',
	templateUrl: 'catergory_presentor_component.html',
	styleUrls: ['catergory_presentor_component.css'],
	directives: [
		coreDirectives,
		DirectionDirective,
		GridMasonryComponent,
		SliderAdaptiveSizeComponent,
		WidgetLoading,
	],
)
class CategoryPresentorComponent implements OnInit
{
	MongoDBService _mongodb;
	ContentProvider _provider;
	LanguageService lang;

	@Input()
	String id;

	@Input()
	String type;

	Map categoryGroup;
	List<Card> categories = [];

	CategoryPresentorComponent(this.lang, this._provider, this._mongodb);

	ngOnInit()
	{
		prepare();
	}

	String getTitle()
	{
		if(categoryGroup == null)
			return '';
		else return getLocalValue(
			categoryGroup['local_title'], lang.getCode());
	}

	void prepare() async
	{
		// get group
		Map groupQuery = {'_id': id};
		_mongodb.findOne(database:'media', collection:'category_group', query: groupQuery)
		.then((doc) 
		{
			if(doc == null) throw('group category not found');
			categoryGroup = validateFields(doc, SystemSchema.category_group);
		})
		.then((r) 
		{
			Map catQuery = {'groupId': id};
			return _mongodb.find(database:'media', collection:'category', query: catQuery);
		})
		.then((docs) 
		{
			docs.forEach((cat) =>
				categories.add(getCardFromCategorydoc(cat)));

			categories.shuffle();
		});
	}

	Card getCardFromCategorydoc(dynamic doc)
	{
		Map cat = validateFields(doc, SystemSchema.category);
		return Card('',
			id			: cat['_id'],
			localTitle	: cat['local_title'],
			titleLink	: '/#/category/${cat['_id']}',
			thumbnail	: _provider.getImage(database: 'media', type: 'category', id: cat['_id'], imgStamp: cat['imgStamp']),
		);
	}
}