import 'package:angular/angular.dart';

import 'package:melodyku/src/services/services.dart';

@Component(
	selector:'user-activity-detail',
	templateUrl: 'user_activity_detail.html',
	styleUrls: ['user_activity_detail.css'],
	directives: [
		coreDirectives,
	],
)
class UserActivityDetail
{
	LanguageService lang;
	UserService _userService;
	StitchService _stitch;

	String subscriptionPlan = '...';
	String daysLeft = '0';
	String listenlastMonth = '0';
	String likedLastMonth = '0';

	UserActivityDetail(this._stitch, this._userService, this.lang)
	{
		fetDetail();
	}

	void fetDetail() async
	{
		// plan & days left
		if(_userService.user.subscription.hasSubscription())
		{
			subscriptionPlan = _userService.user.subscription.plan;
			daysLeft = _userService.user.subscription.getDurationLeft().inDays.toString();
		}
		else {
			subscriptionPlan = lang.getStr('youDontHaveSubscriptionYet');
			daysLeft = '0';
		}

		// days days
	}
}