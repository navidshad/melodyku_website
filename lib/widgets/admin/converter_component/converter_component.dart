/// {@nodoc}
library converterComponent;

import 'package:angular/angular.dart';
import 'dart:html';

import 'package:melodyku/services/services.dart';

import 'package:melodyku/core/core.dart';
import 'package:melodyku/pips/pips.dart';
import 'package:melodyku/directives/directives.dart';

import 'package:melodyku/widgets/widgets.dart';

@Component(
    selector: 'converter',
    templateUrl: 'converter_component.html',
    styleUrls: [
      'converter_component.css'
    ],
    directives: [
      coreDirectives,
      SelectField,
      DbCollectionTableEditorComponent,
      ElementExtractorDirective,
    ],
    pipes: [
      BytesToMb,
    ]
)
class ConverterComponent {
  LanguageService lang;
  MongoDBService _mongodb;
  Modal modal;

  CollectionOptions songCollectionOptions;
  CollectionOptions presetCollectionOptions;

  ConvertService convertService;

  String getMode = "hasn't";

  List<DbField> presets = [];

  String selectedPreset = '';

  List<DbField> getmodes = [
    DbField("hasn't", strvalue: "hasn't"),
    DbField('has', strvalue: 'has'),
  ];

  ConverterComponent(this.lang, this._mongodb) {
    convertService = ConvertService();

    convertService.connectToSocket();

    _prepare();
  }

  void _prepare() async {
    await _mongodb
        .find(database: 'cms', collection: 'convert_preset')
        .then((dynamic docs) {
      docs.forEach((dynamic doc) {
        Map converted = validateFields(doc, SystemSchema.convert_preset);

        DbField field =
            DbField(converted['title'], strvalue: converted['title']);

        presets.add(field);
      });
    });

    if (presets.length > 0) selectedPreset = presets[0].title;

    songCollectionOptions = CollectionOptions(
      database: 'media',
      collection: 'song',
      allowAdd: false,
      allowUpdate: false,
      allowRemove: false,
      autoGet: false,
      dbFields: [
        DbField('title'),
        DbField('album'),
        DbField('artist'),
        DbField('versions',
            dataType: DataType.array_object,
            fieldType: FieldType.array,
            subFields: [
              DbField('title'),
              DbField('type'),
              DbField('size'),
              DbField('duration'),
            ]),
      ],
    );

    selectPreset(selectedPreset);
  }

  List<ActionButton> getActionButtons() {
    List<ActionButton> list = [];

    if (getMode == "hasn't")
      list = [ ActionButton(title: 'convert', onEvent: convertById) ];

    else if (getMode == "has")
      list = [ ActionButton( title: 'remove $selectedPreset', onEvent: removeSongVersion) ];

    return list;
  }

  Map<String, dynamic> getQuery() {
    if (getMode == "hasn't")
      return { 'versions.title': {'\$ne': selectedPreset} };
    else if (getMode == "has")
      return { 'versions.title': {'\$eq': selectedPreset} };
  }

  void selectPreset(String title) 
  {
    selectedPreset = title;
    songCollectionOptions.query = getQuery();
    songCollectionOptions.actionButtons = getActionButtons();

    songCollectionOptions.clear();
  }

  void onSelectGetMode(String mode) 
  {
    getMode = mode;
    selectPreset(selectedPreset);

    songCollectionOptions.clear();
  }

  void convertAll() 
  {
    if (convertService.isConverting || selectedPreset == null) return;
    convertService.convertAll(selectedPreset);
  }

  void convertById(Map doc, ButtonOptions options) async 
  {
    options.doWaiting(true);

    convertService.convertById(selectedPreset, doc['_id']).then((r) {
      options.doWaiting(false);

      options.setActivation(false);
    }).catchError((err) => options.doWaiting(false));
  }

  void removeSongVersion(Map doc, ButtonOptions options) {
    options.doWaiting(true);

    convertService.removeById(selectedPreset, doc['_id'])
    .then((r) 
    {
      options.doWaiting(false);
      options.setActivation(false);
    }).catchError((err) => options.doWaiting(false));
  }

  void setupPresetModal(Element el)
  {
    modal = Modal(el, onClose: _prepare);

    presetCollectionOptions = CollectionOptions(
        title: 'Presets',
        database: 'cms',
        collection: 'convert_preset',
        allowQuery: false,
        dbFields: SystemSchema.convert_preset,
      );
  }

  void showPresets()
  {
    modal.show();
  }
}
