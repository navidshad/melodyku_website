import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/archive/archive.dart';

// Map items = {
// 	'addToPlayingList': PopupButtonOptions(
// 		lableSku: 'addToPlayingList', 
// 		icon: '', 
// 		dynamic arg, () → dynamic callback, (dynamic) → dynamic callbackWithArg})
// };

int getSongMenuItemsCount() => getSongMenuItems(null).length;
List<PopupButtonOptions> getSongMenuItems(Song item)
{
	List<PopupButtonOptions> list = [

		PopupButtonOptions(
			lableSku: 'addToPlayingList', 
			icon: '', 
			arg: item, 
			callbackWithArg: (dynamic song)
			{
				PlayerService playerS = Injector.get<PlayerService>();
				playerS.addToPlayingList(song as Song);

				//tracking
				Injector.get<AnalyticService>()
					.trackEvent('addToPlayingList', category: 'popup menu', label: 'song');
			}),
	];

	// add button - "add to playlist"
	UserService userService = Injector.get<UserService>();
	if(userService.user.hasAccess(PermissionType.archive_manager))
	{
		PopupButtonOptions btn = PopupButtonOptions();
		btn..lableSku = 'addTOGlobalPlaylists'
		..icon = ''
		..arg = item?.id
		..callbackWithArg = (dynamic id)
		{
			PopupService popupService = Injector.get<PopupService>();
			popupService.showPopup('globalPlaylistInjector', id);
		};

		list.add(btn);
	}

	return list;
}

List<PopupButtonOptions> getSingleAlbumMenuItems(List<Song> songs)
{
	List<PopupButtonOptions> list = [

		PopupButtonOptions(
			lableSku: 'addToPlayingList', 
			icon: '', 
			arg: songs, 
			callbackWithArg: (dynamic songs)
			{
				PlayerService playerS = Injector.get<PlayerService>();
				playerS.addToPlayingList_ByList(songs);

				//tracking
				Injector.get<AnalyticService>()
					.trackEvent('addToPlayingList', category: 'popup menu', label: 'media item');
			}),
	];

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