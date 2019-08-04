/// {@nodoc}
library modal;

import 'dart:html';
import 'dart:async';

class Modal
{
  Element base;
  DivElement submitBtn;
  Function onClose;
  Function onSubmitAsync;
  dynamic closeArg;
  bool isSubmitting = false;

  Modal(this.base, {this.onClose, this.onSubmitAsync, this.closeArg})
  {
    close(performCallback: false);

    _addMessageSection();
    _addButtons();
  }

  void show()
  {
    isSubmitting = false;
    base.style.display = 'flex';
    base.style.opacity = '1';
  }

  void submit() async
  {
    if(isSubmitting) return;

    if(onSubmitAsync != null) {
      isSubmitting = true;
      submitBtn.classes.add('btn-disabled');
      await onSubmitAsync();
      submitBtn.classes.remove('btn-disabled');
    }

    base.style.opacity = '1';

    // delay for making none
    await Future.delayed(Duration(microseconds: 500));
    base.style.display = 'none';

    doWaiting(false);
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
      if(closeArg != null) onClose(closeArg);
      else onClose();
    }

  }

  Future<void> doWaiting(key) async
  {
    Element cardContent = base.querySelector('.modal-content');
    cardContent.style.transition = '0.5s';

    if(key) cardContent.style.opacity = '0';
    else cardContent.style.opacity = '1';

    return Future.delayed(Duration(milliseconds: 500));
  }

  void _addMessageSection()
  {
    Element  ul = Element.tag('ul');
    ul.classes.add('modal-message');
    ul.style.display = 'none';

    base.querySelector('.modal-card').append(ul);
  }

  void _addButtons()
  {
    // submit
    submitBtn = DivElement();
    submitBtn.classes.add('btn-sl-x');
    submitBtn.text = "submite";
    submitBtn.onClick.listen((e) => submit());

    // close
    DivElement  div_close = DivElement();
    div_close.classes.add('btn-close');
    div_close.onClick.listen((e) => close());
    ImageElement img = ImageElement(src: '/assets/svg/icon_close.svg');
    div_close.append(img);

    // group div
    DivElement  div_group = DivElement();
    div_group.classes.add('flex-row');
    div_group.classes.add('flex-center');
    div_group.style.setProperty('width', '200px');
    
    div_group.append(div_close);
    if(onSubmitAsync != null) 
      div_group.append(submitBtn);

    base.querySelector('.modal-card').append(div_group);
  }

  void addMessage(String text, {String color})
  {
    Element  li = Element.tag('li');
    if(color != null) li.style.color = color;
    li.appendText(text);

    base.querySelector('.modal-message').append(li);
  }

  void clearMessages()
  {
    base.querySelector('.modal-message').children = [];
  }

  void showMessage() => base.querySelector('.modal-message').style.display = 'block';
}