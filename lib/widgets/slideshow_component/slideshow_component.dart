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
	MongoDBService _mongodb;
	SlideShow slideshow;
	Swiper swiper;

	bool initilized =false;

	@Input()
	String title;

	SlideShowComponent(this._mongodb);

	ngOnChanges(Map<String, SimpleChange> changes) async
	{
		if(title != null) {
			slideshow = SlideShow(title: title);
			await slideshow.initialize();
			print('initial swiper ngOnChanges');
			initSwiper();
		}
	}

	void initSwiper() async
	{
		await Future.delayed(Duration(seconds:1));
		swiper = Swiper(
			'#${slideshow.title}',
			createSwipeOptions(
				slidesPerView: 'auto',
				spaceBetween: 10,
				navigation: SwiperNavigation(
					nextEl: '.swiper-button-next',
					prevEl: '.swiper-button-prev',),

				effect: SwiperEffect.coverflow,
				coverflowEffect: CoverflowEffect(
					slideShadows: true,
					rotate: 0, 
					depth: 200)
			)
		);

		initilized = true;
	}
}