/// {@nodoc}
library math;

import 'dart:math';

int randomRange(int min, int max) 
{
  final _random = new Random();
  return min + _random.nextInt(max - min);
}

String getDigitStyle(int number, int totalZero)
{
  String digit = number.toString();

  int length = number.toString().length;
  if(length <= totalZero ){
    int totalInjectedZero = totalZero - length;
    digit = injectZero(totalInjectedZero, number);
  }

  return digit;
}

String injectZero(int total, int number)
{
  String digit = '';
  for (var i = 0; i < total; i++) {
    digit += '0';
  }

  digit += number.toString();
  return digit;
}

String getRandomColor()
{
  // String hex = '#' + (Random.se * 16777215).floor().toString();
  // return hex;
  Random random = new Random();
  int length = 6;
  String chars = '0123456789ABCDEF';
  String hex = '#';
  while(length-- > 0) hex += chars[(random.nextInt(16)) | 0];
  return hex;
}

int getPercent(total, number)
{
  return ((number/total) * 100).toInt();
}