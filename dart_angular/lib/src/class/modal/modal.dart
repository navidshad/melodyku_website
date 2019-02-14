import 'dart:html';
import 'dart:async';

class Modal
{
  Element base;

  Modal(this.base)
  {
    close();
    addCloseButton();
  }

  void show()
  {
    base.style.display = 'flex';
    base.style.opacity = '1';
  }

  void close() async
  {
    base.style.opacity = '1';

    // delay for making none
    await Future.delayed(Duration(microseconds: 500));
    base.style.display = 'none';

    doWaiting(false);
  }

  void doWaiting(key)
  {
    Element cardContent = base.querySelector('.modal-content');
    cardContent.style.transition = '0.5s';

    if(key) cardContent.style.opacity = '0';
    else cardContent.style.opacity = '1';
  }

  void addCloseButton()
  {
    DivElement  div = DivElement();
    div.classes.add('btn-close');
    div.onClick.listen((e) => close());

    ImageElement img = ImageElement(src: '/assets/svg/icon_close.svg');
    div.append(img);

    base.querySelector('.modal-card').append(div);
  }
}