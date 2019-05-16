import 'package:angular/angular.dart';

import '../../services/services.dart';
import '../../class/page/page.dart';
import 'package:melodyku/src/widgets/admin/converter_component/converter_component.dart';

@Component(
  selector: 'page',
  templateUrl: 'archive_convert_page.html',
  styleUrls: [ 'archive_convert_page.css' ],
  directives: [
    ConverterComponent,
  ]
)
class ArchiveConvertPage 
{
  Page _page;
  LanguageService lang;
  UserService _userservice;
  MessageService _messageService;
  ContentProvider _contentProvider;

  // constructor ==================================
  ArchiveConvertPage(this._contentProvider, this._messageService, this._userservice)
  {
    _page = Page(
      userService: _userservice, 
      messageService: _messageService, 
      permissionType: PermissionType.archive_manager,
      needLogedIn: true,
      title: 'archive_convert');
  }
}