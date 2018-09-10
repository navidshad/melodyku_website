import 'dart:math';

int randomRange(int min, int max) 
{
  final _random = new Random();
  return min + _random.nextInt(max - min);
}