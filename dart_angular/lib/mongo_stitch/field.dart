enum fieldType {string, bool, select, map}

class DbField {

	String key;
	String strvalue;

	String title;
	fieldType type;
	
	bool isDisable;
	bool isHide;

	//only for map type
	List<DbField> subFields;

	DbField(this.key, {
		String customTitle,
		this.strvalue,
		this.type=fieldType.string,
		this.isDisable=false, 
		this.isHide=false, 
		this.subFields
		})
	{
		title = customTitle ?? key;
	}

	String getType() => type.toString();
}