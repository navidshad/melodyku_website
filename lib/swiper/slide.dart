import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class Slide
{
	String id;
	String refId;
	Map local_title;
	Map local_subtitle;
	String imgStamp;
	String link;
	int order;

	Slide({this.id, this.refId, this.local_title, this.local_subtitle, this.imgStamp, this.link, this.order});

	factory Slide.fromMap(Map detail)
	{
		return Slide(
			id				: detail['_id'],
			refId			: detail['refId'],
			local_title		: detail['local_title'],
			local_subtitle	: detail['local_subtitle'],
			imgStamp		: detail['imgStamp'],
			link			: detail['link'],
			order			: detail['order'],
		);
	}

	Map getAsMap()
	{
		return {
			'_id'			: id,
			'local_title'	: local_title,
			'local_subtitle': local_subtitle,
			'imgStamp'		: imgStamp,
			'link'			: link,
			'order'			: order
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
}