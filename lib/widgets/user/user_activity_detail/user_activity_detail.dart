/// {@nodoc}
library userActivityDetail;

import 'package:angular/angular.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';

@Component(
	selector:'user-activity-detail',
	templateUrl: 'user_activity_detail.html',
	styleUrls: ['user_activity_detail.css'],
	directives: [
		coreDirectives,
		DirectionDirective,
	],
)
class UserActivityDetail
{
	LanguageService lang;
	UserService _userService;

	String subscriptionPlan = '...';
	int daysLeft = 0;
	int listenlastMonth = 0;
	int likedLastMonth = 0;

	UserActivityDetail(this._userService, this.lang)
	{
		getDetail();
	}

	void getDetail() async
	{
		// plan & days left
		if(_userService.user.subscription.hasSubscription())
		{
			subscriptionPlan = _userService.user.subscription.plan;
			daysLeft = _userService.user.subscription.getDurationLeft().inDays;
		}
		else {
			subscriptionPlan = lang.getStr('youDontHaveSubscriptionYet');
			daysLeft = 0;
		}

		// get listenlastMonth
		_userService.user.traker
			.getTotalActivity(collection: 'song_history', from: getLastMonDate())
			.then((count) => listenlastMonth = count);

		// get likedLastMonth
		_userService.user.traker
			.getTotalActivity(collection: 'song_favorite', from: getLastMonDate())
			.then((count) => likedLastMonth = count);
	}

	DateTime getLastMonDate()
	{
		DateTime now = DateTime.now().toUtc();
		DateTime earlyMon = now.add(Duration(days: - now.day));
		DateTime lastMon = getDate(earlyMon);

		return lastMon;
	}
}