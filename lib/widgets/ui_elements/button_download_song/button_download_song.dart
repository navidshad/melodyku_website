import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/archive/archive.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/services/services.dart';

@Component(
	selector: 'button-download-song',
	templateUrl: 'button_download_song.html',
  	styleUrls: ['button_download_song.css'],
  	directives: [
    	coreDirectives,
    	ButtonRoundedProgress,
  	],
)
class ButtonDownloadSong implements OnChanges
{
	ContentProvider _provider;

	ButtonOptions options;
	bool isDownloaded = false;

	@Input()
	Song song;

	ButtonDownloadSong(this._provider)
	{
		options = ButtonOptions(lable:'0', type:ButtonType.sl_x, callback: download);
    	options.icon = 'assets/imgs/icons/downloads.png';
    	options.watingIcon = 'assets/svg/loading_cycle.svg';
	}

	void ngOnChanges(Map<String, SimpleChange> changes)
	{
		getDownloadedStatus();
	}

	void getDownloadedStatus() async
	{
		await song.getDownloadedStatus()
		  .then((s) => isDownloaded = s);

		if(isDownloaded){
		  options.icon = '/assets/svg/icon_checked.svg';
		  options.setActivation(false);
		}
	}

	void download(ButtonOptions op)
	{
		op.doWaiting(true);

		_provider.downloadSong(song, 
		  (int percent) => op.lable = percent.toString())
		.then((r)
		{
		  op.lable = '';
		  op.icon = '/assets/svg/icon_checked.svg';
		  op.doWaiting(false);
		  op.setActivation(false);
		})
		.catchError((r) async {
		  op.lable = '';
		  op.icon = '/assets/svg/icon_warning.svg';
		  op.doWaiting(false);

		  Future.delayed(Duration(seconds:2)).then((r)
		  {
		  	op.lable = '';
		  	op.icon = 'assets/imgs/icons/downloads.png';
		  });
		});
	}
}