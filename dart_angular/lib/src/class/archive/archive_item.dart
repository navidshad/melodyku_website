import '../classes.dart';

abstract class ArchiveItem {
  List<Card> getCardList();
  List<ListItem> getItemList();
}