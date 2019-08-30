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
