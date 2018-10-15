import 'package:angular/angular.dart';

@Pipe('durationStr')
class DurationToString extends PipeTransform
{
  String transform(var value)
  {
    int tempValue = int.parse(value.toString());
    return getDuration(tempValue);
  }

  String getDuration(int customLength)
  {
    int length = 0;
    if(!customLength.isNaN) length = customLength;

    int hours = (length / 3600).floor();
    int minutes = (length % 3600 / 60).floor();
    int seconds =(length % 3600 % 60).floor();

    //print('hours ${hours.toString()} , minutes ${minutes.toString()} , seconds ${seconds.toString()}, customLength ${customLength.toString()}');

    String durationStr = '';
    if(hours > 0) durationStr += '$hours : ';
    durationStr += '$minutes : $seconds';

    return durationStr;
  }
}