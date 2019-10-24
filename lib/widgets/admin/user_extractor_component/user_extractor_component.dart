import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';

@Component(
  selector: 'user-extractor',
  templateUrl: 'user_extractor_component.html',
  styleUrls: ['user_extractor_component.css'],
  directives: [ 
    coreDirectives,
    formDirectives,
    SelectField,
    ButtonRounded,
    DbCollectionTableEditorComponent,
    ],
)
class UserExtractorComponent
{
  String type = 'lastLogin';
  String from;
  String to;
  int moreThan = 0;

  List<DbField> selectTypes = [
    DbField('lastLogin', customTitle: 'Last Login', strvalue: 'lastLogin'),
    DbField('registered', customTitle: 'Registered', strvalue: 'registered'),
    DbField('usubscribed', customTitle: 'Usubscribed', strvalue: 'usubscribed'),
    DbField('subscribed', customTitle: 'Subscribed', strvalue: 'subscribed'),
    DbField('fullPlay', customTitle: 'Full Play', strvalue: 'fullPlay'),
    DbField('like', customTitle: 'Like', strvalue: 'like'),
  ];

  List<DbField> authSchema = [
    DbField('phone'),
    //DbField('type'),
    DbField('createdAt', customTitle: 'registered', fieldType: FieldType.date),
    DbField('updatedAt', customTitle: 'last login', fieldType: FieldType.dateTime),
    DbField('sms'),
  ];

  ButtonOptions updateButton;
  CollectionOptions tableOption;

  UserExtractorComponent()
  {
    updateButton = ButtonOptions(
      lable: 'update', 
      type: ButtonType.sl,
      callback: updateTableOptions);

    tableOption = CollectionOptions(
      allowAdd: false,
      allowRemove: false,
      allowUpdate: false,
      hasNavigator: true,
      autoGet: true,
      database: 'cms',
      collection: 'auth',
      dbFields: authSchema);
  }

  Function updateTableOptions(ButtonOptions op)
  {
    op.doWaiting(true);
    Future.delayed(Duration(seconds: 1)).then((r) => op.doWaiting(false));
    return null;
  }
}