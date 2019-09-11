import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'dart:async';

import 'package:melodyku/mongodb/field.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';
import 'package:melodyku/directives/directives.dart';

import 'countries.dart';

@Component(
	selector: 'phone-number',
	templateUrl: 'phone_number_field.html',
	styleUrls: ['phone_number_field.css'],
	directives: [
		coreDirectives,
		formDirectives,
		SelectField,
		DirectionDirective,
	]
)
class PhoneNumberField
{
	LanguageService lang;
	StreamController<int> sc = StreamController();
	
	@Input()
	String code;

	int phone;

	@Output('onPhone')
	get onPhone => sc.stream;

	List<DbField> countries = [];
  	List<String> flags = [];

  	PhoneNumberField(this.lang)
  	{
  		getCountries();
  	}

  	void setCode(String value)
  	{
  		if(!value.startsWith('+'))
  			value = '+' + value;

  		if(countries.indexWhere((f) => f.strvalue == value) >= 0)
  			code = value;
  	}

  	void setPhone(int value)
  	{
  		//print('setPhone $value');
  		//if(value.length < 1) return;

  		// if(int.parse(value, onError: (e) => 0) == 0);
  		// 		value = '';

  		if(value.toString().startsWith('0'))
  			value = int.parse(value.toString().replaceRange(0,1, ''));

  		if(value.toString().length > 10)
  			value = int.parse(value.toString().replaceRange(10, value.toString().length-1, ''));

  		phone = value;
  		emitPhone();
  	}

  	emitPhone()
  	{
  		String temp = code.toString() + phone.toString();
  		temp = temp.replaceRange(0,1, '');

  		int castedPhone = int.parse(temp);
  		sc.add(castedPhone);
  	}

  	bool validatePhone()
	{
		String pattern = r'^\d{10,15}$';
		RegExp reg = RegExp(pattern, caseSensitive: false);

		return reg.hasMatch(phone.toString());
	}

  	bool normalizePhone()
	{
		// bool key = false;

		// int temp = int.tryParse(strPhone);

		// if(temp == null) {
		//   strPhone = '';
		//   errorMessage = 'enterEnglishPhone';
		//   swicher.showLast();
		//   return key;
		// }

		// normalizedPhone = temp.toString();
		// key = true;

		// normalizedPhone.replaceAll('+', '');

		// if(normalizedPhone.startsWith(countryCode))
		//   normalizedPhone = normalizedPhone.replaceRange(0, countryCode.length, '');

		// if(normalizedPhone.startsWith('0'))
		//   normalizedPhone = normalizedPhone.replaceRange(0, 1, '');

		// normalizedPhone = countryCode + normalizedPhone;

		// return key;
	}

	List<DbField> getCountries()
	{
		countriesRawDetail.forEach((raw) 
		{
			DbField field = DbField(raw['nativeName'], strvalue: '+${raw['callingCode']}');
			countries.add(field);
			//flags.add(raw['flag']);
		});
	}
}