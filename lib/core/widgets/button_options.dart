import 'dart:async';

enum ButtonType {sl_x, sl, md, bg}

class ButtonOptions
{
	String lable;
	ButtonType type;
	dynamic arg;
	
	Function(ButtonOptions options) callback;
	Function(dynamic arg, ButtonOptions options) callbackWithArg;
	

	bool _isWaiting = false;
  bool get isWaiting => _isWaiting;

	StreamController<bool> waitingController;
	StreamController<bool> statusController;
	StreamController<String> colorController;

	ButtonOptions({this.lable, this.type, this.callback, this.callbackWithArg})
	{
		waitingController = StreamController();
		statusController = StreamController();
		colorController = StreamController();
	}

	void setActivation(bool key) =>
		statusController.add(key);

	void doWaiting(bool key) {
		_isWaiting = key;
		waitingController.add(isWaiting);
	}

	void setColor(String color) =>
		colorController.add(color);

	String getType() =>
		type.toString().replaceAll('ButtonType.', '').replaceAll('_', '-');

	void done()
	{
		if(callback != null) callback(this);
		else if(callbackWithArg != null) callbackWithArg(arg, this);
	}
}