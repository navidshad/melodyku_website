import 'dart:html';

class Drawer {
  int width = 100;
  String mainMargine = "80px";
  String direction = "right";
  String planeOpacity = "0.8";
  Element el_drawer;
  Element el_main;
  Element el_plane;
  Element el_btn_pushing;
  Element el_btn_noPushing;
  bool openOnInitialied;

  bool isDrawerOpen = false;
  bool pushing = false;

  Drawer(this.el_drawer, this. el_main, 
    {this.width, this.mainMargine, this.direction, this.planeOpacity,
     this.el_btn_pushing, this.el_btn_noPushing, this.el_plane, this.openOnInitialied=false})
  {
    setupStyle();
    setupButtons();
  }



  void setupStyle()
  {
    //print('setupStyle');
    el_drawer.style.height    = "100%";
    el_drawer.style.width     = "${width}px";
    el_drawer.style.position  = "fixed";
    el_drawer.style.zIndex    = "1";
    el_drawer.style.top       = "0";
    el_drawer.style.overflowX = "hidden";
    el_drawer.style.transition = "0.5s";

    //direction
    String moveOut = '-${width}px';
    if(direction == 'left') el_drawer.style.left = moveOut;
    else el_drawer.style.right = moveOut;
  }

  void setupButtons()
  {
    if(el_btn_noPushing != null) {
      el_btn_noPushing.onClick.listen((e) => doOpenClose());
    }
    
    if(el_btn_pushing != null) {
      el_btn_pushing.onClick.listen((e) => doOpenCloseWithPushing());
    }
  }

  void doOpenClose()
  {
    //print('doOpenClose');
    pushing = false;
    el_drawer.style.zIndex = "2";

    // switcher
    if(isDrawerOpen) close();
    else _open();
  }

  void doOpenCloseWithPushing()
  {
    //print('doOpenCloseWithPushing');
    pushing = true;
    el_drawer.style.zIndex = "0";

    if(isDrawerOpen) close();
    else _open();
  }

  void _open()
  {
    //print('open');
    blockScreen(true);
    _changeStyleForOpenClose('0px', mainMargine);

    if(el_btn_pushing != null) el_btn_pushing.classes.add('rotate-half');
    if(el_btn_noPushing != null) el_btn_noPushing.classes.add('rotate-half');

    isDrawerOpen = true;
  }

  void close()
  {
    //print('close');
    blockScreen(false);

    if(el_btn_pushing != null) el_btn_pushing.classes.remove('rotate-half');
    if(el_btn_noPushing != null) el_btn_noPushing.classes.remove('rotate-half');

    String move = '-${width}px';
    _changeStyleForOpenClose(move, '0px');
    isDrawerOpen = false;
  }

  
  void _changeStyleForOpenClose(String drawer, String main)
  {
    //print('_changeStyleForOpenClose $direction');
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
    if(pushing) return;

    if(key)
    {
      el_plane.style.display= "block";
      el_plane.style.opacity= planeOpacity;
    }
    else {
      el_plane.style.opacity= "0";
      el_plane.style.display= "none";
    }
  }
}