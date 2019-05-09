class SongVersion
{
	String id;
	String refId;
	bool isOriginal;
	double size;
	int bitrate;

	SongVersion({this.id, this.refId, this.bitrate, this.isOriginal, this.size});

	factory SongVersion.createFromMap(Map detail)
	{
		SongVersion version;

		try{
			version = SongVersion(
					id		: detail['_id'].toString(),
					refId	: detail['refId'],
					bitrate	: detail['bitrate'],
					size	: detail['size'],
					isOriginal	: detail['isOriginal'],
				);
			}catch(e)
			{
				print('Version.createFromMap error | $e');
			}

		return version;
	}
}