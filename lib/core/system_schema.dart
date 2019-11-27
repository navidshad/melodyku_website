/// {@nodoc}
library systemSchema;

import 'package:melodyku/mongodb/mongodb.dart';

class SystemSchema
{
	// Media ====================================
	static List<DbField> mediaItems = 
	[
		DbField('artist'),
		DbField('album'),
		DbField('song'),
		DbField('playlist'),
	];

	static List<DbField> artist = 
	[
		DbField('name'),
		DbField('imgStamp', isDisable:true, isLowerCase: true),
        DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
        DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
	];

	static List<DbField> album =
	[
		DbField('title', isLowerCase: true),
		DbField('imgStamp', isDisable:true),
		DbField('imgStamp_artist', isHide:true),
		DbField('artistId', isHide: true),
     	DbField('artist', isDisable: true),
      	DbField('description', fieldType: FieldType.textbox),
      	DbField('year', dataType: DataType.int, fieldType: FieldType.text),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
      	DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
	];

	static List<DbField> album_populteVer =
	[
		DbField('title', isLowerCase: true),
		DbField('imgStamp', isDisable:true),
		DbField('imgStamp_artist', isHide:true),
      	DbField('description', fieldType: FieldType.textbox),
      	DbField('year', dataType: DataType.int, fieldType: FieldType.text),
      	DbField('artistId', dataType: DataType.object, fieldType: FieldType.object, subFields: SystemSchema.artist),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
      	DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
	];

	static List<DbField> song_version = 
	[
		DbField('title', isLowerCase: true),
		DbField('size', dataType: DataType.float),
		DbField('duration', dataType: DataType.float),
		DbField('bitrate', dataType: DataType.int),
		//DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
	];

	static List<DbField> song = 
	[
		DbField('artistId', isHide:true),
		DbField('albumId', isHide:true),
		DbField('title', dataType: DataType.string, fieldType: FieldType.text, isLowerCase: true),
		DbField('album', isDisable: true),
		DbField('artist', isDisable: true),
		DbField('year', dataType: DataType.int, fieldType: FieldType.text),
		DbField('track', dataType: DataType.int, fieldType: FieldType.text),
		DbField('duration', dataType: DataType.float, isHide:true),
		DbField('size', dataType: DataType.float, isHide:true),
		DbField('bitrate', dataType: DataType.float, isHide:true),
		DbField('versions', isHide:true, dataType: DataType.array_object, subFields: song_version),
		DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
		DbField('imgStamp', isDisable:true),
		DbField('imgStamp_album', isHide:true),
		DbField('imgStamp_artist', isHide:true),
		DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
	];

	static List<DbField> song_populateVer = 
	[
		DbField('artistId', dataType: DataType.object, fieldType: FieldType.object, subFields: SystemSchema.artist),
		DbField('albumId', dataType: DataType.object, fieldType: FieldType.object, subFields: SystemSchema.album),
		DbField('title', dataType: DataType.string, fieldType: FieldType.text, isLowerCase: true),
		// DbField('album', isDisable: true),
		// DbField('artist', isDisable: true),
		DbField('year', dataType: DataType.int, fieldType: FieldType.text),
		DbField('track', dataType: DataType.int, fieldType: FieldType.text),
		DbField('duration', dataType: DataType.float, isHide:true),
		DbField('size', dataType: DataType.float, isHide:true),
		DbField('bitrate', dataType: DataType.float, isHide:true),
		DbField('versions', isHide:true, dataType: DataType.array_object, subFields: song_version),
		DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
		DbField('imgStamp', isDisable:true),
		DbField('imgStamp_album', isHide:true),
		DbField('imgStamp_artist', isHide:true),
		DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
	];

	static List<DbField> playlist =
	[
		DbField('title', isLowerCase: true),
      	DbField('description', fieldType: FieldType.textbox),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
      	DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
      	DbField('list', dataType: DataType.array_string, fieldType: FieldType.showLength, subFields: []),
      	DbField('imgStamp', isDisable:true),
      	DbField('forGenerator', dataType: DataType.bool, fieldType: FieldType.checkbox),
      	DbField('limitMode', dataType: DataType.bool, fieldType: FieldType.checkbox),
      	DbField('limitation', dataType: DataType.int, fieldType: FieldType.number),
      	DbField('isActive', dataType: DataType.bool, fieldType: FieldType.checkbox),
	];

	static List<DbField> playlist_populateVer =
	[
		DbField('title', isLowerCase: true),
      	DbField('description', fieldType: FieldType.textbox),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
      	DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
      	DbField('list', dataType: DataType.array_object, fieldType: FieldType.showLength, subFields: SystemSchema.song_populateVer),
      	DbField('imgStamp', isDisable:true),
      	DbField('forGenerator', dataType: DataType.bool, fieldType: FieldType.checkbox),
      	DbField('limitMode', dataType: DataType.bool, fieldType: FieldType.checkbox),
      	DbField('limitation', dataType: DataType.int, fieldType: FieldType.number),
      	DbField('isActive', dataType: DataType.bool, fieldType: FieldType.checkbox),
	];

	static List<DbField> mediaPack =
	[
		DbField('title', isLowerCase: true),
      	DbField('description', fieldType: FieldType.textbox),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
      	DbField('type', fieldType: FieldType.select, subFields: []),
      	DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
      	DbField('list', dataType: DataType.array_string, fieldType: FieldType.showLength),
      	DbField('imgStamp', isDisable:true),
      	DbField('forGenerator', dataType: DataType.bool, fieldType: FieldType.checkbox),
      	DbField('limitMode', dataType: DataType.bool, fieldType: FieldType.checkbox),
      	DbField('limitation', dataType: DataType.int, fieldType: FieldType.number),
      	DbField('isActive', dataType: DataType.bool, fieldType: FieldType.checkbox),
	];

	static List<DbField> mediaPack_populateVer =
	[
		DbField('title', isLowerCase: true),
      	DbField('description', fieldType: FieldType.textbox),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
      	DbField('type', fieldType: FieldType.select, subFields: []),
      	DbField('categories', dataType: DataType.array_string, fieldType: FieldType.multiSelect, subFields: []),
      	DbField('list', dataType: DataType.array_object, fieldType: FieldType.showLength, subFields: []),
      	DbField('imgStamp', isDisable:true),
      	DbField('forGenerator', dataType: DataType.bool, fieldType: FieldType.checkbox),
      	DbField('limitMode', dataType: DataType.bool, fieldType: FieldType.checkbox),
      	DbField('limitation', dataType: DataType.int, fieldType: FieldType.number),
      	DbField('isActive', dataType: DataType.bool, fieldType: FieldType.checkbox),
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

	static List<DbField> languageStr = 
	[
		DbField('title'),
		DbField('local_str', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
	];

	static List<DbField> tariff = 
	[
		DbField('title'),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
      	DbField('local_description', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
		DbField('days', dataType: DataType.int),
		// DbField('price_irt', dataType: DataType.int),
		// DbField('price_eur', dataType: DataType.int),
		DbField('suggested', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('currencies', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
	];

	static List<DbField> coupen = 
	[
		DbField('title'),
		DbField('code'),
      	DbField('total', dataType: DataType.int),
		DbField('discount_percent', dataType: DataType.int),
		DbField('isUnlimited', dataType: DataType.bool, fieldType: FieldType.checkbox),
	];

	static List<DbField> convert_preset =
	[
		DbField('title'),
		DbField('type'),
		DbField('input', fieldType: FieldType.textbox),
		DbField('output', fieldType: FieldType.textbox),
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

	static List<DbField> slide = 
	[
		DbField('showDetail', dataType: DataType.bool, fieldType: FieldType.checkbox),
		DbField('refId', isHide: true),
		DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
		DbField('local_subtitle', dataType: DataType.object, fieldType: FieldType.object, subFields: []),
		DbField('imgStamp', isHide: true),
		DbField('link'),
		DbField('order', dataType: DataType.int, fieldType: FieldType.number),
	];

	static List<DbField> slideshow = 
	[
		DbField('title'),
		DbField('width', dataType: DataType.int),
		DbField('height', dataType: DataType.int),
	];

	// user ====================================
	static List<DbField> userAuth = 
	[
		DbField('type', fieldType: FieldType.select, subFields: [
				DbField('user', strvalue: 'user'),
			]),

		DbField('email'),
		DbField('phone'),
		DbField('createdAt', dataType: DataType.dateTime, fieldType: FieldType.date),
		DbField('updatedAt', dataType: DataType.dateTime, fieldType: FieldType.date),
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
		DbField('categories', dataType: DataType.array_string),
	];

	static List<DbField> factor = 
	[
		DbField('refId'),
		DbField('isPaid', dataType: DataType.bool),
		DbField('amount', dataType: DataType.int),
		DbField('currency'),
		DbField('description', fieldType: FieldType.textbox),
		DbField('createdAt', dataType: DataType.dateTime),
		DbField('updatedAt', dataType: DataType.dateTime),
		
		DbField('discount', dataType: DataType.int),
		DbField('coupenId', ),
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