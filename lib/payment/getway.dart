import 'package:melodyku/core/core.dart';

enum Currency { irt, eur }

Currency getCurrencyFromStr(String str)
{
	if(str == 'irt') return Currency.irt;
	else if(str == 'eur') return Currency.eur;
	else return Currency.irt;
}

String getCurrencyAsStr (Currency currency)
{
	if(currency == Currency.irt) return 'irt';
	if(currency == Currency.eur) return 'eur';
	else return 'irt';
}

class Getway 
{
	String title;
	Currency currency;

	Getway(this.title, strCurrency)
	{
		this.currency = getCurrencyFromStr(strCurrency);
	}
}