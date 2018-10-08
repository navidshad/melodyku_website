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