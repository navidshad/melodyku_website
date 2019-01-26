import '../classes.dart';

class Result_Singer extends ListResult
{
  List<Singer> list;

  // constructor
  Result_Singer(int pages, int current, this.list) 
    : super(pages, current);

  factory Result_Singer
  .fromjson(int pages, int current, dynamic items)
  {
    List<Singer> singers = [];
    items.forEach((item) 
      => singers.add(Singer.fromjson(item)));

    return Result_Singer(
      pages, 
      current,
      singers,
      );
  }
}