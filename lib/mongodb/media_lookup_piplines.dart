import 'package:melodyku/core/core.dart';
import 'package:melodyku/mongodb/mongodb.dart';

Map getOtherFieldOfSchema(List<DbField> dbFields, Map additional)
{
	Map shownFieldsOnProject = {};
	dbFields.forEach((df) => shownFieldsOnProject[df.key] = 1);

	shownFieldsOnProject.addAll(additional);

	return shownFieldsOnProject;
}

List<Map> getPiplines(String collection)
{
	Map<String, List<Map>> piplines =
	{
		'song': [
			{
				"\$lookup":{
					"from": "albums",
					"localField": "albumId",
					"foreignField": "_id",
					"as": "albumId"
				}
			},
			{
				"\$lookup":{
					"from": "artists",
					"localField": "artistId",
					"foreignField": "_id",
					"as": "artistId"
				}
			},
			{
				"\$project": getOtherFieldOfSchema(SystemSchema.song_populateVer, {
						"albumId": { "\$arrayElemAt": ["\$albumId", 0] },
						"artistId": { "\$arrayElemAt": ["\$artistId", 0] }
					}),
			}
		],

		'album': [
			{
				"\$lookup":{
					"from": "artists",
					"localField": "artistId",
					"foreignField": "_id",
					"as": "artistId"
				}
			},
			{
				"\$project": getOtherFieldOfSchema(SystemSchema.album_populteVer, {
						"artistId": { "\$arrayElemAt": ["\$artistId", 0] }
					}),
			}
		]
	};

	return piplines[collection];
}
