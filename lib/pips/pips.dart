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
class TitlePipe extends PipeTransform
{
	String transform(String str)
	{
		String temp = str ?? '';

		if(str == null || str == '') return '';
		else return '${temp[0].toUpperCase()}${temp.substring(1)}';
	}
}

// @Pipe('uppercase')
// class uppercasePipe extends PipeTransform
// {
// 	String transform(String str)
// 	{
// 		String temp = str ?? '';

// 		if(str == null || str == '') return '';
// 		else return temp.toUpperCase();
// 	}
// }

@Pipe('UpFirstChars')
class UpFirstCharsPipe extends PipeTransform
{
	String transform(String str)
	{
		String temp = '';

		if(str == null || str == '') return '';

		str.split(' ').forEach((word)
		{
			word = word.trim();

      if(word != '') temp += ' ${word[0].toUpperCase()}${word.substring(1)}';
		});

		return temp.trim();
	}
}
