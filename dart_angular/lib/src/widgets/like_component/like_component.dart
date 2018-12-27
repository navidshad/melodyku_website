import 'package:angular/angular.dart';
import 'dart:async';

@Component(
  selector: 'like',
  templateUrl: 'like_component.html',
  styleUrls: ['like_component.scss.css']
)
class LikeComponent 
{
  StreamController<bool> _controller;

  @Input('isLiked')
  bool isLiked;

  @Output()
  Stream get onlike => _controller.stream;

  String _likeIcon = '/assets/imgs/icons/favorites.png';
  String _likedIcon = '/assets/imgs/icons/liked.png';
  
  String get iconpath => (isLiked ) ? _likedIcon : _likeIcon;

  LikeComponent()
  {
    _controller = StreamController();
  }

  String getIcon()
  {
    if(isLiked == null) return _likeIcon;
    else return (isLiked ) ? _likedIcon : _likeIcon;
  }

  void like()
  {
    _controller.add(true);
  }
}