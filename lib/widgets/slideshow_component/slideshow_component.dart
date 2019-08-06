import 'package:angular/angular.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/swiper/swiper.dart';

@Component(
	selector:'slideshow',
	templateUrl: 'slideshow_component.html',
	styleUrls: ['slideshow_component.css'],
	directives: [
		coreDirectives
	]
)
class SlideShowComponent implements OnChanges
{
	LanguageService lang;
	SlideShow slideshow;
	Swiper swiper;

	bool initilized =false;

	@Input()
	String title;

	SlideShowComponent(this.lang);

	void ngOnChanges(Map<String, SimpleChange> changes)
	{
		if(title != null) {
			slideshow = SlideShow(title: title);
			slideshow.initialize()
				.then((r) => initSwiper())
				.catchError((err) => print(err));

			//print('initial swiper ngOnChanges');
		}
	}

	void initSwiper() async
	{
		await Future.delayed(Duration(seconds:1));
		swiper = Swiper(
			'#${slideshow.hashCode}',
			createSwipeOptions(
				slidesPerView: 'auto',
				spaceBetween: 10,
				initialSlide: 1,
				centeredSlides: true,
				navigation: SwiperNavigation(
					nextEl: '.swiper-button-next',
					prevEl: '.swiper-button-prev',),

				effect: SwiperEffect.coverflow,
				coverflowEffect: CoverflowEffect(
					slideShadows: true,
					rotate: 0, 
					depth: 200),

				more: {
					'slideToClickedSlide': true,
				}
			)
		);

		initilized = true;
	}
}