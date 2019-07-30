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

	Future<void> show(String selector) async
	{
		await hideAll();

		Element el;

		String normal = selector.replaceAll('.', '');
		normal = normal.replaceAll('#', '');
		
		selectors.forEach((element) 
		{
			if(selector.startsWith('.') && element.classes.contains(normal))
				el = element;
			else if(element.id == normal)
				el = element;
		});

		if(el == null) return;

		el.style.setProperty('display', 'block');
		el.style.setProperty('opacity', '1');
	}
}