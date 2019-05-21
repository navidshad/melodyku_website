import 'package:angular/angular.dart';

import 'package:melodyku/src/services/services.dart';
import 'package:melodyku/src/widgets/admin/dbCollection_item_editor/dbCollection_item_editor.dart';
import 'package:melodyku/src/widgets/admin/cover_item_editor/cover_item_editor.dart';

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
  	String imgStamp;

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
		imgStamp = _userService.user.imgStamp;
    	type = 'user';
	}

	void onUpdated() =>
		_userService.user.getData();
}