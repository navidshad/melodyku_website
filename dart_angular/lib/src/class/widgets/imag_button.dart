import 'dart:html';
import '../types.dart';


class ImageButton
{
  ImageElement element;
  ClickType clickType;
  String normalIcon;
  String clickIcon;
  bool _isClicked = false;

  ImageButton(this.element, this.clickType, this.normalIcon, this.clickIcon, Function clickAction) 
  {
    element.attributes['src'] = this.normalIcon;
    element.style.cursor = 'pointer';
    addListeners();
    this.element.onClick.listen((e) {
      clickAction();
    });
  }

  // methods
  void clicked([bool key])
  {
    _isClicked = !_isClicked;
    if(key != null) _isClicked = key;
    String sourceIcon = (_isClicked) ? clickIcon : normalIcon;
    element.attributes['src'] = sourceIcon;
  }

  //events
  void addListeners()
  {
    // click event for switchable mod
    element.onClick.listen(((e) 
    {
      if(clickType != ClickType.switchable) return;
      clicked();
    }));

    // mouse down for trigger mode
    element.onMouseDown.listen((e) 
    {
      if(clickType != ClickType.trigger) return;
      clicked();
    });

    // mouse up for trigger mode
    element.onMouseUp.listen((e)
    {
      if(clickType != ClickType.trigger) return;
      clicked();
    });
  }
}