import 'dart:html';
import 'package:angular/angular.dart';

import 'package:melodyku/services/services.dart';
import 'package:melodyku/directives/directives.dart';
import 'package:melodyku/core/core.dart';

@Component(
    selector: 'adv-presentor',
    templateUrl: 'advertisement_presentor.html',
    styleUrls: [
      'advertisement_presentor.css'
    ],
    directives: [
      coreDirectives,
      DirectionDirective,
    ])
class AdvertisementPresentor implements OnInit {
  MongoDBService _mongo;
  ContentProvider _contentProvider;

  AdvertisementPresentor(this._mongo, this._contentProvider);

  String db = 'cms';
  String coll = 'advertisement';

  @Input()
  String type = 'square';

  String image;
  String link;
  String id;

  @override
  void ngOnInit() => getAdvDetail();

  getAdvDetail() {
    _mongo
        .getRandomItems(
            isLive: true,
            database: db,
            collection: coll,
            query: {'type': type},
            total: 1)
        .then((items) {
      if (items.length == 0) return;

      Map advItem = validateFields(items[0], SystemSchema.advertisement);

      id = advItem['_id'];
      link = advItem['link'] ?? '#';
      image = _contentProvider.getImage(
        database: db,
        type: coll,
        id: id,
        imgStamp: advItem['imgStamp'],
      );

      incrementViews();
    });
  }

  incrementViews() {
    _mongo.updateOne(database: db, collection: coll, query: {
      '_id': id
    }, update: {
      '\$inc': {'views': 1}
    });
  }

  openAdv() {
    window.open(link, '_blank');

    _mongo.updateOne(database: db, collection: coll, query: {
      '_id': id
    }, update: {
      '\$inc': {'clicks': 1}
    });
  }
}
