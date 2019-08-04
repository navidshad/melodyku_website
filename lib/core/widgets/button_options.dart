import 'dart:async';

enum ButtonType {sl_x, sl, md, bg}

class ButtonOptions
{
	String lable;
	ButtonType type;
	Function callback;

	bool isWaiting = false;

	StreamController<bool> waitingController;
	StreamController<bool> statusController;
	StreamController<String> colorController;

	ButtonOptions({this.lable, this.type, this.callback})
	{
		waitingController = StreamController();
		statusController = StreamController();
		colorController = StreamController();
	}

	void setActivation(bool key) =>
		statusController.add(key);

	void doWaiting(bool key) {
		isWaiting = key;
		waitingController.add(isWaiting);
	}

	void setColor(String color) =>
		colorController.add(color);

	String getType() =>
		type.toString().replaceAll('ButtonType.', '');
}