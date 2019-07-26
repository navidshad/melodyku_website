import 'dart:html';

class SectionSwitcher
{
	List<HtmlElement> selectors;

	SectionSwitcher(this.selectors)
	{
		selectors.forEach((element) =>
			element.style.setProperty('transition', 'all ease 0.5s'));
		
		hideAll();
	}

	Future<void> hideAll() async
	{
		selectors.forEach((element) =>
			element.style.setProperty('opacity', '0'));

		await Future.delayed(Duration(milliseconds: 500));

		selectors.forEach((element) =>
			element.style.setProperty('display', 'none'));
	}

	Future<void> show(String classSelector) async
	{
		await hideAll();
		
		selectors.forEach((element) {
			if(element.classes.contains(classSelector))
				element.style.setProperty('display', 'block');
		});

		selectors.forEach((element) {
			if(element.classes.contains(classSelector))
				element.style.setProperty('opacity', '1');
		});
	}
}