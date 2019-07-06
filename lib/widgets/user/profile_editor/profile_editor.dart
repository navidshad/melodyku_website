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
  	String type;

	ProfileEditor(this._userService)
	{
		print('_userService.user.detailId ${_userService.user.detailId}');

		options = CollectionOptions(
			title: 'acountDetail',
			database: 'user',
			collection: 'detail',
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