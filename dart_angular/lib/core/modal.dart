/// {@nodoc}
library modal;

import 'dart:html';
import 'dart:async';

class Modal
{
  Element base;
  Function onClose;
  dynamic arg;

  Modal(this.base, {this.onClose, this.arg})
  {
    close(performCallback: false);

    _addMessageSection();
    _addCloseButton();
  }

  void show()
  {
    base.style.display = 'flex';
    base.style.opacity = '1';
  }

  void close({bool performCallback=true}) async
  {
    base.style.opacity = '1';

    // delay for making none
    await Future.delayed(Duration(microseconds: 500));
    base.style.display = 'none';

    doWaiting(false);

    // close callback
    if(performCallback && onClose != null)
    {
      if(arg != null) onClose(arg);
      else onClose();
    }

  }

  void doWaiting(key)
  {
    Element cardContent = base.querySelector('.modal-content');
    cardContent.style.transition = '0.5s';

    if(key) cardContent.style.opacity = '0';
    else cardContent.style.opacity = '1';
  }

  void _addMessageSection()
  {
    Element  ul = Element.tag('ul');
    ul.classes.add('modal-message');
    ul.style.display = 'none';

    base.querySelector('.modal-card').append(ul);
  }

  void _addCloseButton()
  {
    DivElement  div = DivElement();
    div.classes.add('btn-close');
    div.onClick.listen((e) => close());

    ImageElement img = ImageElement(src: '/assets/svg/icon_close.svg');
    div.append(img);

    base.querySelector('.modal-card').append(div);
  }

  void addMessage(String text, {String color})
  {
    Element  li = Element.tag('li');
    if(color != null) li.style.color = color;
    li.appendText(text);

    base.querySelector('.modal-message').append(li);
  }

  void showMessage() => base.querySelector('.modal-message').style.display = 'block';
}