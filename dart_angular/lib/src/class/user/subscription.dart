import 'package:melodyku/src/services/stitch_service.dart';
import 'package:melodyku/src/class/injector.dart';

class Subscription 
{
	String plan;
	String refId;
	DateTime startIn;
	DateTime expiresIn;

	StitchService _stitch;

	Subscription()
	{
		this._stitch = Injector.get<StitchService>();
		getUserSubscription();


		expiresIn = DateTime.now().add(Duration(days: 1));
	}

	void getUserSubscription()
	{
		// if(_stitch != null) print('=== appid ${_stitch.app_id}');
		// else print('=== appid null');
	}

	bool canListen()
	{
		bool key = false;

		if(expiresIn != null)
		{
			int difference = DateTime.now().difference(expiresIn).inMinutes;
			print('=== difference $difference');
			// future is less than now
			if(difference < 0) key = true;
		}

		return key;
	}
}