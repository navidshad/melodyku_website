import 'dart:async';

class PopupService
{
	StreamController<Map<String, dynamic>> popupController = StreamController<Map<String, dynamic>>();
	StreamController<bool> popupCloser = StreamController<bool>();
	
	void showPopup(String name, dynamic arg)
	{
		Map<String, dynamic> detail = {};
		detail[name] = arg;

		popupController.add(detail);
	}

	void closePopups() => popupCloser.add(true);
}