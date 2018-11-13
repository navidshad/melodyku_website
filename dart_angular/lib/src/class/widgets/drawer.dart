import 'dart:html';

class Drawer {
  int width;
  String mainMargine;
  String direction;
  Element el_drawer;
  Element el_main;
  Element el_plane;
  Element el_btn;

  bool isDrawerOpen = false;
  bool pushing;

  Drawer(this.width, this.mainMargine, this.direction, 
    this.el_drawer, this. el_main);

  void doOpenClose(Element btn, Element plane)
  {
    pushing = false;
    el_drawer.style.zIndex = "2";
    if(btn != null) el_btn = btn;
    if(btn != null) el_plane = plane;

    // switcher
    if(isDrawerOpen) _close();
    else _open();
    
    isDrawerOpen = !isDrawerOpen;
  }

  void doOpenCloseWithPushing(Element btn)
  {
    pushing = true;
    el_drawer.style.zIndex = "0";
    el_plane = null;
    if(btn != null) el_btn = btn;

    if(isDrawerOpen) _close();
    else _open();

    isDrawerOpen = !isDrawerOpen;
  }

  void _open()
  {
    blockScreen(true);
    el_btn.classes.add('rotate-half');
    _changeStyleForOpenClose('0px', mainMargine);
  }

  void _close()
  {
    blockScreen(false);
    el_btn.classes.remove('rotate-half');
    String move = '-${width}px';
    _changeStyleForOpenClose(move, '0px');
  }

  void _changeStyleForOpenClose(String drawer, String main)
  {
    switch(direction)
    {
      case 'right':
        el_drawer.style.right = drawer;
        if(pushing) el_main.style.marginRight = main;
        else el_main.style.marginRight = '0px';
        break;

      case 'left':
        el_drawer.style.left = drawer;
        if(pushing) el_main.style.marginLeft = main;
        else el_main.style.marginLeft = '0px';
        break;
    }
  }

  void blockScreen(key)
  {
    if(el_plane == null) return;

    if(key)
    {
      el_plane.style.display= "block";
      el_plane.style.opacity= "0.8";
    }
    else {
      el_plane.style.opacity= "0";
      el_plane.style.display= "none";
    }
  }
}