import 'dart:math';

int randomRange(int min, int max) 
{
  final _random = new Random();
  return min + _random.nextInt(max - min);
}

String getSongDuration(int length)
{
  int hours = (length / 3600).floor();
  int minutes = (length % 3600 / 60).floor();
  int seconds =(length % 3600 % 60).floor();

  String duration;
  if(hours > 0) duration += '$hours : ';
  duration += '$minutes : $seconds';

  return duration;
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