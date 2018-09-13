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