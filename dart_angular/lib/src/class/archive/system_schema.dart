import '../../../mongo_stitch/field.dart';

class SystemSchema
{
	// Media ====================================
	static List<DbField> artist = 
	[
		DbField('name'),
        DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: [])
	];

	static List<DbField> album =
	[
		DbField('title'),
     	DbField('artist', isDisable: true),
      	DbField('description'),
      	DbField('artistId', isDisable: true),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: [])
	];

	static List<DbField> song = 
	[
		DbField('title', dataType: DataType.string, fieldType: FieldType.text),
		DbField('album', isDisable: true),
		DbField('artist', isDisable: true),
		DbField('genre', dataType: DataType.string, fieldType: FieldType.select, subFields: []),
		DbField('year', dataType: DataType.int, fieldType: FieldType.text),
		DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: [])
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
	// ];

	// CMS ======================================
	static List<DbField> tariff = 
	[
		DbField('title'),
		DbField('days', dataType: DataType.int),
		DbField('price', dataType: DataType.int),
		DbField('suggested', dataType: DataType.bool, fieldType: FieldType.checkbox),
	];

	// user ====================================
	static List<DbField> userDetail = 
	[
		DbField('refId'),
		DbField('fullname'),
		DbField('email'),
		DbField('permissionId'),
	];

	static List<DbField> subscription = 
	[
		DbField('refId'),
		DbField('plan'),
		DbField('startsIn', dataType: DataType.dateTime),
		DbField('expiresIn', dataType: DataType.dateTime),
	];
}