import 'dart:html';
import 'dart:async';

class Modal
{
  Element base;

  Modal(this.base)
  {
    close();
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
  }

  void doWaiting(key)
  {
    Element cardContent = base.querySelector('.modal-content');
    cardContent.style.transition = '0.5s';

    if(key) cardContent.style.opacity = '0';
    else cardContent.style.opacity = '1';
  }
}