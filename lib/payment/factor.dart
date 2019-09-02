import 'getway.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class Factor
{
	int id;
	String refId;
	String description;
	bool isPaid;

	int amount;
	Currency currency;

	int discount;
	String coupenId;

	DateTime createdAt;
	DateTime updatedAt;

	Factor(
		this.id,
		this.refId,
		this.description,
		this.isPaid,
		this.amount,
		this.currency,
		this.discount,
		this.coupenId,
		this.createdAt,
		this.updatedAt
	);

	factory Factor.fromMap(Map detail)
	{
		return Factor(
			detail['_id'],
			detail['refId'],
			detail['description'],
			detail['isPaid'],
			detail['amount'],
			getCurrencyFromStr(detail['currency']),
			detail['discount'],
			detail['coupenId'],
			detail['createdAt'],
			detail['updatedAt'],
		);
	}

	Future<String> getPayLink(String getway)
	{
		PaymentService ps = Injector.get<PaymentService>();
		return ps.getPaylink(id, getway);
	}
}