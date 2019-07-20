/// {@nodoc}
library systemSchema;

import 'package:melodyku/mongodb/mongodb.dart';

class SystemSchema
{
	// Media ====================================
	static List<DbField> artist = 
	[
		DbField('name'),
		DbField('imgStamp', isDisable:true),
        DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
        DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
	];

	static List<DbField> album =
	[
		DbField('title'),
		DbField('imgStamp', isDisable:true),
		DbField('imgStamp_artist', isHide:true),
		DbField('artistId', isHide: true),
     	DbField('artist', isDisable: true),
      	DbField('description'),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
      	DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
	];

	static List<DbField> song_version = 
	[
		DbField('title'),
		DbField('size', dataType: DataType.float),
		DbField('duration', dataType: DataType.float),
		DbField('bitrate', dataType: DataType.int),
		//DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
	];

	static List<DbField> song = 
	[
		DbField('artistId', isHide:true),
		DbField('albumId', isHide:true),
		DbField('title', dataType: DataType.string, fieldType: FieldType.text),
		DbField('album', isDisable: true),
		DbField('artist', isDisable: true),
		DbField('year', dataType: DataType.int, fieldType: FieldType.text),
		DbField('duration', dataType: DataType.float, isHide:true),
		DbField('size', dataType: DataType.float, isHide:true),
		DbField('bitrate', dataType: DataType.int, isHide:true),
		DbField('versions', isHide:true, dataType: DataType.array_object, subFields: song_version),
		DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
		DbField('imgStamp', isDisable:true),
		DbField('imgStamp_album', isHide:true),
		DbField('imgStamp_artist', isHide:true),
		DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
	];

	static List<DbField> result_artists = 
	[
		DbField('pages', dataType: DataType.string, fieldType: FieldType.text),
		DbField('current', isDisable: true),
		DbField('list', dataType: DataType.array_object, subFields: SystemSchema.artist),
	];

	static List<DbField> result_albums = 
	[
		DbField('pages', dataType: DataType.string, fieldType: FieldType.text),
		DbField('current', isDisable: true),
		DbField('list', dataType: DataType.array_object, subFields: SystemSchema.album),
	];

	static List<DbField> result_song = 
	[
		DbField('pages', dataType: DataType.string, fieldType: FieldType.text),
		DbField('current', isDisable: true),
		DbField('list', dataType: DataType.array_object, subFields: SystemSchema.song),
	];

	// static List result_playlist = 
	// [
	// 	DbField('pages', dataType: DataType.string, fieldType: FieldType.text),
	// 	DbField('current', isDisable: true),
	// 	DbField('list', dataType: DataType.array_object, subFields: ArchiveSchema.song),
	//  DbField('imgStamp', isHide:true),
	// ];

	static List<DbField> category =
	[
		DbField('groupId', fieldType: FieldType.select, subFields: []),
		DbField('title'),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
      	DbField('imgStamp', isDisable:true),
	];

	static List<DbField> category_group =
	[
		DbField('title'),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: [])
	];

	// CMS ======================================
	static List<DbField> language = 
	[
		DbField('code'),
		DbField('isDefault', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('isActive', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('title'),
		DbField('title_en'),
		DbField('direction'),
	];

	static List<DbField> tariff = 
	[
		DbField('title'),
		DbField('days', dataType: DataType.int),
		DbField('price_irt', dataType: DataType.int),
		DbField('price_eur', dataType: DataType.int),
		DbField('suggested', dataType: DataType.bool, fieldType: FieldType.checkbox),
	];

	static List<DbField> convert_preset =
	[
		DbField('title'),
		DbField('type'),
		DbField('input'),
		DbField('output'),
	];

	static List<DbField> permission =
	[
		DbField('title'),
		DbField('isDefault', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('isAnonymous', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('advanced_settings', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('categorizing', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('archive_manager', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('customer_access', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('anonymous_access', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('quality_management', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('user_manager', dataType: DataType.bool, fieldType: FieldType.checkbox),
	];

	// user ====================================
	static List<DbField> userAuth = 
	[
		DbField('type', isDisable: true),
		DbField('email'),
		DbField('phone'),
		DbField('permission', fieldType: FieldType.select, subFields: []),
	];

	static List<DbField> userDetail = 
	[
		DbField('refId', isHide: true, isDisable: true),
		DbField('fullname'),
		DbField('imgStamp', isHide:true, isDisable: true),		
	];

	static List<DbField> subscription = 
	[
		DbField('refId'),
		DbField('plan'),
		DbField('startsIn', dataType: DataType.dateTime),
		DbField('expiresIn', dataType: DataType.dateTime),
	];

	static List<DbField> trackedSong = 
	[
		DbField('refId'),
		DbField('songId'),
		DbField('artistId', dataType: DataType.dateTime),
	];

	// methods ==================================
	static List<DbField> injectSubfields(fielKey, List<DbField> schema, List<DbField> subfields)
	{
		for(int i =0; i < schema.length; i++)
		{
			if(schema[i].key == fielKey)
				schema[i].subFields = subfields;
		}

		return schema;
	}
}