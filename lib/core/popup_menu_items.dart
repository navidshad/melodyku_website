import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

int getSongMenuItemsCount() => getSongMenuItems('').length;
List<PopupButtonOptions> getSongMenuItems(String songid)
{
	List<PopupButtonOptions> list = [];

	UserService userService = Injector.get<UserService>();

	// add button - "add to playlist"
	if(userService.user.hasAccess(PermissionType.archive_manager))
	{
		PopupButtonOptions btn = PopupButtonOptions();
		btn..lableSku = 'addTOGlobalPlaylists'
		..icon = ''
		..arg = songid
		..callbackWithArg = (dynamic id)
		{
			PopupService popupService = Injector.get<PopupService>();
			popupService.showPopup('globalPlaylistInjector', id);
		};

		list.add(btn);
	}

	return list;
}

int getMediaMenuItemsCount() => getMediaMenuItems('').length;
List<PopupButtonOptions> getMediaMenuItems(dynamic item)
{
	List<PopupButtonOptions> list = [];

	UserService userService = Injector.get<UserService>();

	// add button - "add to mediapack"
	if(userService.user.hasAccess(PermissionType.archive_manager))
	{
		PopupButtonOptions btn = PopupButtonOptions();
		btn..lableSku = 'addTOGlobalMediaPacks'
		..icon = ''
		..arg = item
		..callbackWithArg = (dynamic item)
		{
			PopupService popupService = Injector.get<PopupService>();
			popupService.showPopup('globalMediaPackInjector', item);
		};

		list.add(btn);
	}

	return list;
}