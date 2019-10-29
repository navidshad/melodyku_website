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
    SMSSenderComponent,
    ],
)
class UserExtractorComponent
{
  String type = 'wasOnline';
  String from;
  String to;
  int moreThan = 0;

  List<String> phoneNumbers = [];

  List<DbField> selectTypes = [
    DbField('wasOnline', customTitle: 'was online', strvalue: 'wasOnline'),
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

    tableOption.onLoadPageControler.stream.listen(onLoadUsers);
  }

  Function updateTableOptions(ButtonOptions op)
  {
    phoneNumbers = [];
    op.doWaiting(true);

    DateTime fromDate = DateTime.now().add(Duration(days: -1));
    DateTime toDate = DateTime.now();

    try {
      fromDate = DateTime.parse(from);
      toDate = DateTime.parse(to);
    } catch (e) {
    }
    
    getAuthPiplinesMethod[type](from:fromDate, to:toDate, moreThan:moreThan)
      .then((PiplineMethod pm)
      {
        tableOption.piplines = pm.piplines;
        tableOption.piplines.add({
          '\$project':{ 'phone':1, 'createdAt':1, 'updatedAt':1 }
        });

        tableOption.types = pm.caster;
        tableOption.query = {'type':'user'};
        tableOption.sort = {'updatedAt':-1};
        
        if(pm.additionalColumn != null)
          tableOption.aditionalColumns = [pm.additionalColumn];

        tableOption.getData();

      }).whenComplete(() => op.doWaiting(false));
  }

  void onLoadUsers(List<Map> users)
  {
    phoneNumbers = [];
    users.forEach((user) => phoneNumbers.add(user['phone']));
  }
}