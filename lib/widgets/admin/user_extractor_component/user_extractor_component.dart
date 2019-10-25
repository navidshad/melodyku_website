import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';
import 'package:melodyku/widgets/widgets.dart';

import 'extract_methods.dart';

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
  String type = 'wasOnline';
  String from;
  String to;
  int moreThan = 0;

  List<DbField> selectTypes = [
    DbField('wasOnline', customTitle: 'was online', strvalue: 'wasOnline'),
    DbField('wasOffline', customTitle: 'was Offline', strvalue: 'wasOffline'),
    DbField('registered', customTitle: 'Registered', strvalue: 'registered'),
    DbField('usubscribed', customTitle: 'Usubscribed', strvalue: 'usubscribed'),
    DbField('subscribed', customTitle: 'Subscribed', strvalue: 'subscribed'),
    DbField('fullPlay', customTitle: 'Full Play', strvalue: 'fullPlay'),
    DbField('like', customTitle: 'Like', strvalue: 'like'),
  ];

  List<DbField> authSchema = [
    DbField('phone'),
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
      autoGet: false,
      database: 'cms',
      collection: 'auth',
      dbFields: authSchema);
  }

  Function updateTableOptions(ButtonOptions op)
  {
    op.doWaiting(true);

    DateTime fromDate = DateTime.now().add(Duration(days: -1));
    DateTime toDate = DateTime.now();

    try {
      fromDate = DateTime.parse(from);
      toDate = DateTime.parse(to);
    } catch (e) {
    }
    
    getAuthPiplinesMethod[type](from:fromDate, to:toDate)
      .then((PiplineMethod pm)
      {
        tableOption.piplines = pm.piplines;
        tableOption.types = pm.caster;
        tableOption.query = {'type':'user'};
        tableOption.sort = {'updatedAt':-1};
        tableOption.getData();

      }).whenComplete(() => op.doWaiting(false));
  }
}