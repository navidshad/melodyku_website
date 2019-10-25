import 'package:melodyku/mongodb/mongodb.dart';
import 'package:melodyku/core/core.dart';
import 'package:melodyku/services/services.dart';

class PiplineMethod {
  List<Map> piplines = [];
  List<TypeCaster> caster;

  PiplineMethod({this.piplines, this.caster});
}

Map<String, Function> getAuthPiplinesMethod = 
{
  'wasOnline': ({DateTime from, DateTime to}) async 
  {
    List<Map> piplines = [
      {
        '\$match': { 'updatedAt': { '\$gte': from.toIso8601String() } }
      },
      {
        '\$match': { 'updatedAt': { '\$lte': to.toIso8601String() } }
      }
    ];

    List<TypeCaster> casters = [
      /**
       * table collection editor will add piplines from 2th index
       */
      TypeCaster('Date', '2.\$match.updatedAt.\$gte'),
      TypeCaster('Date', '3.\$match.updatedAt.\$lte'),
    ];

    return PiplineMethod(piplines: piplines, caster: casters);
  },

  'wasOffline': ({DateTime from, DateTime to}) async 
  {
    List<Map> piplines = [
      {
        '\$match': { 'updatedAt': { '\$ne': from.toIso8601String() } }
      },
      {
        '\$match': { 'updatedAt': { '\$ne': to.toIso8601String() } }
      }
    ];

    List<TypeCaster> casters = [
      /**
       * table collection editor will add piplines from 2th index
       */
      TypeCaster('Date', '2.\$match.updatedAt.\$ne'),
      TypeCaster('Date', '3.\$match.updatedAt.\$ne'),
    ];

    return PiplineMethod(piplines: piplines, caster: casters);
  },

  'registered': ({DateTime from, DateTime to}) async 
  {
    List<Map> piplines = [
      {
        '\$match': { 'createdAt': { '\$gte': from.toIso8601String() } }
      },
      {
        '\$match': { 'createdAt': { '\$lte': to.toIso8601String() } }
      }
    ];

    List<TypeCaster> casters = [
      /**
       * table collection editor will add piplines from 2th index
       */
      TypeCaster('Date', '2.\$match.createdAt.\$gte'),
      TypeCaster('Date', '3.\$match.createdAt.\$lte'),
    ];

    return PiplineMethod(piplines: piplines, caster: casters);
  },

  'usubscribed': ({DateTime from, DateTime to}) async 
  {
    List<Map> piplines = [];
    List or = [];
    List<TypeCaster> casters = [];

    MongoDBService mongodb = Injector.get<MongoDBService>();

    // find subscriptions
    await mongodb.aggregate(
      isLive:true, database: 'user', collection: 'subscription',
      piplines: [
        {
        '\$match': { 'expiresIn': { '\$gte': from.toIso8601String() } }
        },
        {
          '\$match': { 'expiresIn': { '\$lte': to.toIso8601String() } }
        },
        {
          '\$project': {'refId':1, 'expiresIn':1}
        },
      ],
      types: [
        TypeCaster('Date', '0.\$match.expiresIn.\$gte'),
        TypeCaster('Date', '1.\$match.expiresIn.\$lte'),
      ])
      .then((subscriptions)
      {
        for (var i = 0; i < subscriptions.length; i++) 
        {
          or.add({'_id': subscriptions[i]['refId']});
          casters.add(TypeCaster('ObjectId', '2.\$match.\$or.$i._id'));
        }
      });

    // create auth piplines
    piplines = [
      {
        '\$match': { '\$or': or }
      }
    ];    

    return PiplineMethod(piplines: piplines, caster: casters);
  },

  'subscribed': ({DateTime from, DateTime to}) async 
  {
    List<Map> piplines = [];
    List or = [];
    List<TypeCaster> casters = [];

    MongoDBService mongodb = Injector.get<MongoDBService>();

    // find subscriptions
    await mongodb.aggregate(
      isLive:true, database: 'user', collection: 'subscription',
      piplines: [
        {
        '\$match': { 'startsIn': { '\$gte': from.toIso8601String() } }
        },
        {
          '\$match': { 'expiresIn': { '\$lte': to.toIso8601String() } }
        },
        {
          '\$project': {'refId':1, 'startsIn':1, 'expiresIn':1}
        },
      ],
      types: [
        TypeCaster('Date', '0.\$match.startsIn.\$gte'),
        TypeCaster('Date', '1.\$match.expiresIn.\$lte'),
      ])
      .then((subscriptions)
      {
        for (var i = 0; i < subscriptions.length; i++) 
        {
          or.add({'_id': subscriptions[i]['refId']});
          casters.add(TypeCaster('ObjectId', '2.\$match.\$or.$i._id'));
        }
      });

    // create auth piplines
    piplines = [
      {
        '\$match': { '\$or': or }
      }
    ];    

    return PiplineMethod(piplines: piplines, caster: casters);
  },

  'fullPlay': ({DateTime from, DateTime to}) async 
  {
    List<Map> piplines = [];

    List<TypeCaster> casters = [];

    return PiplineMethod(piplines: piplines, caster: casters);
  },

  'like': ({DateTime from, DateTime to}) async 
  {
    List<Map> piplines = [];

    List<TypeCaster> casters = [];

    return PiplineMethod(piplines: piplines, caster: casters);
  },
};