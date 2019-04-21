import '../../../mongo_stitch/field.dart';

class SystemSchema
{
	static List artist = 
	[
		DbField('name'),
        DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: [])
	];

	static List album =
	[
		DbField('title'),
     	DbField('artist', isDisable: true),
      	DbField('description'),
      	DbField('artistId', isDisable: true),
      	DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: [])
	];

	static List song = 
	[
		DbField('title', dataType: DataType.string, fieldType: FieldType.text),
		DbField('album', isDisable: true),
		DbField('artist', isDisable: true),
		DbField('genre', dataType: DataType.string, fieldType: FieldType.select, subFields: []),
		DbField('year', dataType: DataType.int, fieldType: FieldType.text),
		DbField('local_title', dataType: DataType.object, fieldType: FieldType.object, subFields: [])
	];

	static List result_artists = 
	[
		DbField('pages', dataType: DataType.string, fieldType: FieldType.text),
		DbField('current', isDisable: true),
		DbField('list', dataType: DataType.array_object, subFields: SystemSchema.artist),
	];

	static List result_albums = 
	[
		DbField('pages', dataType: DataType.string, fieldType: FieldType.text),
		DbField('current', isDisable: true),
		DbField('list', dataType: DataType.array_object, subFields: SystemSchema.album),
	];

	static List result_song = 
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
}