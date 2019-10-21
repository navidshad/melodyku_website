library pipes;

import 'package:angular/angular.dart';

export 'durationTrans.dart';

@Pipe('BytesToMb')
class BytesToMb extends PipeTransform
{
  String transform(double bytes)
  {
    double mb = bytes / 1000000;
    return mb.toStringAsFixed(1);
  }
}

@Pipe('Title')
class TitlePip extends PipeTransform
{
	String transform(String str)
	{
		String temp = str ?? '';

		if(str == null || str == '') return '';
		else return '${temp[0].toUpperCase()}${temp.substring(1)}';
	}
}

@Pipe('UpperCase')
class UpperCasePip extends PipeTransform
{
	String transform(String str)
	{
		String temp = str ?? '';

		if(str == null || str == '') return '';
		else return temp.toUpperCase();
	}
}

@Pipe('UpFirstChars')
class UpFirstCharsPip extends PipeTransform
{
	String transform(String str)
	{
		String temp = '';

		if(str == null || str == '') return '';

		str.split(' ').forEach((word)
		{
			word = word.trim();
			temp += ' ${word[0].toUpperCase()}${word.substring(1)}';
		});

		return temp.trim();
	}
}
