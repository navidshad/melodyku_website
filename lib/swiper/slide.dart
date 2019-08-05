import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class Slide
{
	String id;
	String refId;
	Map localTitle;
	Map localSubTitle;
	String imgStamp;
	String link;
	bool showDetail;

	Slide({this.id, this.refId, this.showDetail, this.localTitle, this.localSubTitle, this.imgStamp, this.link});

	factory Slide.fromMap(Map detail)
	{
		return Slide(
			id				: detail['_id'],
			refId			: detail['refId'],
			localTitle		: detail['local_title'],
			localSubTitle	: detail['local_subtitle'],
			imgStamp		: detail['imgStamp'],
			link			: detail['link'],
			showDetail		: detail['showDetail'],
		);
	}

	Map getAsMap()
	{
		return {
			'_id'			: id,
			'local_title'	: localTitle,
			'local_subtitle': localSubTitle,
			'imgStamp'		: imgStamp,
			'link'			: link,
			'showDetail'	: showDetail
		};
	}

	String getImgLink()
	{
		return Injector.get<ContentProvider>()
			.getImage(database:'cms', type: 'slide', id: id, imgStamp: imgStamp);
	}

	void removeImg()
	{
		Injector.get<ContentProvider>()
			.removeImage(database:'cms', type: 'slide', id: id);
	}

	String getTitle(String languageCode)
	{
		String tempTitle = '';

		if(localTitle.containsKey(languageCode) && 
		    localTitle[languageCode].length > 0)
		  tempTitle = localTitle[languageCode];

		return tempTitle;
	}

	String getSubTitle(String languageCode)
	{
		String tempTitle = '';

		if(localSubTitle.containsKey(languageCode) && 
		    localSubTitle[languageCode].length > 0)
		  tempTitle = localSubTitle[languageCode];

		return tempTitle;
	}
}