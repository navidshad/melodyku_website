import 'slide.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class SlideShow
{
	String id;
	String title;
	int width;
	int height;
	List<Slide> slides = [];

	bool initilized = false;

	MongoDBService _mongodb;

	SlideShow({this.id, this.title})
	{
		_mongodb = Injector.get<MongoDBService>();
	}

	Future<void> initialize() async
	{
		Map query = {};
		if(id != null) query['_id'] = id;
		else if(title != null) query['title'] = title;

		return _mongodb.findOne(database: 'cms', collection: 'slideshow', query: query)
			.then((doc)
			{
				Map detail = validateFields(doc, SystemSchema.slideshow);
				id = detail['_id'];
				title = detail['title'];
				width = detail['width'];
				height = detail['height'];

				// get slides
				return getSlides();
			})
			.then((r) => initilized=true);
	}

	Future<void> getSlides()
	{
		slides = [];
		Map query = { 'refId': id };
		return _mongodb.find(database: 'cms', collection: 'slide', query: query)
			.then((docs){
				docs.forEach((doc) 
				{
					Map detail = validateFields(doc, SystemSchema.slide);
					Slide s = Slide.fromMap(detail);
					slides.add(s);
				});
			});
	}

	Future<void> updateSlide(Map detail)
	{
		int index;

		for(int i=0; i<slides.length; i++)
		{
			if(slides[i].id == detail['_id']){
				index = i;
			}
		}

		if(index != null) 
			slides[index] = Slide.fromMap(detail);

		Map query = { '_id': detail['_id'] };
		
		detail.remove('_id');

		Map update = {
			"\$set": detail
		};

		return _mongodb.updateOne(database: 'cms', collection: 'slide', query: query, update: update);
	}

	Future<void> addSlide()
	{
		Map doc = { 'refId': id };
		return _mongodb.insertOne(database: 'cms', collection: 'slide', doc:doc)
			.then((r) => getSlides());
	}

	Future<void> removeSlide(int i)
	{
		slides[i].removeImg();
		Map query = {'_id': slides[i].id };

		return _mongodb.removeOne(database: 'cms', collection: 'slide', query:query)
			.then((r) => slides.removeAt(i));
	}
}