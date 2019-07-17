/// {@nodoc}
library profileEditor;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
	selector:'profile-editor',
	templateUrl: 'profile_editor.html',
	styleUrls: ['profile_editor.css'],
	directives: [
		coreDirectives,
		CoverItemEditor,
		DbCollectionItemEditorComponent,
	],
)
class ProfileEditor
{
	UserService _userService;
	CollectionOptions options;

	String id;
	Map<String, dynamic> accesQuery;
  	String type;

	ProfileEditor(this._userService)
	{
		print('_userService.user.id ${_userService.user.id}');

		// this query is for to aacess only own data from server.
		accesQuery = { 'refId': _userService.user.id };

		options = CollectionOptions(
			title: 'acountDetail',
			database: 'user',
			collection: 'detail',
			query: accesQuery,
			id: _userService.user.detailId,
			dbFields: SystemSchema.userDetail,
			hasCover: false,
		);

		id = _userService.user.id;
    	type = 'user';
	}

	void onUpdated() =>
		_userService.user.getData();

	String get imgStamp => _userService.user.imgStamp;
}