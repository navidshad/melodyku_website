import 'dart:html';
import 'package:angular/angular.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/swiper/swiper.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector: 'slideshow-editor',
	templateUrl: 'slideshow_editor.html',
	styleUrls: ['slideshow_editor.css'],
	directives: [
		coreDirectives,
		ButtonRounded,
		ElementExtractorDirective,
		ObjectField,
		ImageUploaderComponent,
	]
)
class SlideShowEditorComponent implements OnChanges
{
	Modal modal;

	Map selectedSlideMap;
	String tempStamp;
	List<DbField> slideFieldOptions = SystemSchema.slide;

	SlideShow slideshow;
	Swiper thumbnails;

	ButtonOptions addBtnOptions;

	@Input()
	String id;

	SlideShowEditorComponent()
	{
		addBtnOptions = ButtonOptions(
			lable: 'Add New Slide', type: ButtonType.sl, callback: addNewSlide);
	}

	// get and register modal to modal Manager
	void getElement(Element el) 
	{
		modal = Modal(el, onSubmitAsync: onSlideEdited);
	}

	ngOnChanges(Map<String, SimpleChange> changes)
	{
		if(id != null){
			slideshow = SlideShow(id: id);
			slideshow.initialize()
				.then((r){
					initSwiper();
				}).catchError((err) 
					=> print(err));
		}
	}

	void initSwiper() async
	{
		await Future.delayed(Duration(seconds:1));
		thumbnails = Swiper(
			'.preview-container',
			createSwipeOptions(
				slidesPerView: 'auto',
				spaceBetween: 10,
				navigation: SwiperNavigation(
					nextEl: '.swiper-button-next',
					prevEl: '.swiper-button-prev',),

			)
		);
	}

	Function addNewSlide(ButtonOptions op)
	{
		addBtnOptions.doWaiting(true);

		slideshow.addSlide()
			.then((r) {
				addBtnOptions.doWaiting(false);
				thumbnails.update();
			})
			.catchError((e) => addBtnOptions.doWaiting(false));
	}

	Function onSlideEdited()
	{
		if(tempStamp != null) selectedSlideMap['imgStamp'] = tempStamp;
		slideshow.updateSlide(selectedSlideMap)
			.then((r) {
					addBtnOptions.doWaiting(false);
					thumbnails.update();
				});
	}

	void onUploaded(String s)
		=> tempStamp = s;

	void openSlideOption(int index)
	{
		tempStamp = null;
		selectedSlideMap = slideshow.slides[index.abs() - 1].getAsMap();
		print(selectedSlideMap);
		modal.show();
	}

	void removeSlide(int index) =>
		slideshow.removeSlide(index.abs() - 1);
}