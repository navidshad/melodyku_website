import 'package:angular/angular.dart';
import 'dart:async';

@Component(
	selector: 'loading',
	template: 
	'''
	<div>
		<img src="{{src}}">
	</div>
	''',
	styles: [
		'div: {text-align: center;}',
		'img {width:200px; opacity:0.1; filter:blur(2px);}'
	],
)
class WidgetLoading implements OnInit
{
	// box, dna, music
	@Input()
	String type;

	String src = '';

	WidgetLoading()
	{
		// timer to hide loading
		Future.delayed(Duration(seconds:7)).then((r) => src = '');
	}

	void ngOnInit()
	{
		switch(type)
		{
			case 'dan': src = '/assets/svg/loading_dna.svg'; break;
			case 'box': src = '/assets/svg/loading_boxes.svg'; break;
			case 'music': src = '/assets/svg/loading_music_notes.svg'; break;
			case 'points': src = '/assets/svg/loading_ellipsis.svg'; break;
			default: src = '/assets/svg/loading_boxes.svg';
		}
	}
}