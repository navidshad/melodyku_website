import 'getway.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class Factor
{
	String id;
	String refId;
	String description;
	bool isPaid;

	int amount;
	Currency currency;

	DateTime createdAt;
	DateTime updatedAt;

	Factor(
		this.id,
		this.refId,
		this.description,
		this.isPaid,
		this.amount,
		this.currency,
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
			detail['createdAt'],
			detail['updatedAt']
		);
	}

	Future<String> getPayLink(String getway)
	{
		PaymentService ps = Injector.get<PaymentService>();
		return ps.getPaylink(id, getway);
	}
}