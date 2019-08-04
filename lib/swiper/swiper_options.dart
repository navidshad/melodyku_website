import 'package:melodyku/js_interop/js_interop.dart';

enum SwiperEffect {slide, fade, cube, coverflow, flip}

String _getEffect(SwiperEffect effect)
{
	SwiperEffect temp = effect ?? SwiperEffect.slide;
	return temp.toString().replaceAll('SwiperEffect.', '');
}



class SwiperNavigation
{
	String nextEl;
	String prevEl;

	SwiperNavigation({this.nextEl, this.prevEl});

	Map getMap()
	{
		return {
			'nextEl': nextEl,
			'prevEl': prevEl,
		};
	}
}

class CoverflowEffect 
{
	bool slideShadows;
	int rotate;
	int stretch;
	int depth;
	int modifier;

	CoverflowEffect({this.slideShadows=false, this.rotate=50, this.stretch=0, this.depth=100, this.modifier=1});

	Map getMap()
	{
		return {
			'slideShadows': slideShadows,
			'rotate': rotate,
			'stretch': stretch,
			'depth': depth,
			'modifier': modifier
		};
	}
}

dynamic createSwipeOptions({
	int speed=300,
	SwiperEffect effect,
	bool watchOverflow= false,
	bool centeredSlides=false,
	bool grabCursor=false,
	bool loop=false,
	SwiperNavigation navigation,
	dynamic slidesPerView='auto',
	int spaceBetween=5,
	CoverflowEffect coverflowEffect,
	int initialSlide,
	Map more= const {},
})
{
	Map options = {
		'speed': speed,
		'effect': _getEffect(effect),
		'watchOverflow': watchOverflow,
		'centeredSlides': centeredSlides,
		'grabCursor': grabCursor,
		'loop': loop,
		'slidesPerView': slidesPerView,
		'spaceBetween': spaceBetween,
		'initialSlide': initialSlide,
	};

	if(navigation != null)
		options['navigation'] = navigation.getMap();

	if(coverflowEffect != null){
		options['coverflowEffect'] = coverflowEffect.getMap();
		options['initialSlide'] = initialSlide ?? 1;
	}

	options.addAll(more);

	return jsify(options);
}