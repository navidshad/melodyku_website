enum FieldType {text, textbox, checkbox, select, object}
enum DataType {string, bool, int, float, object, array_string, array_object, dateTime}

class DbField {
  	
  	// the main key of object property.
	String key;
	// the custom title of this property
	String title;
	// the data type of this property
	DataType dataType;
	// the type of field for this property
	FieldType fieldType;
	// value of this obtion for select FieldType type.
	String strvalue;
	
	// the field of this property could be disable
	bool isDisable;
	// the field of this property could be hide
	bool isHide;

	//only for map type
	List<DbField> subFields;

	DbField(
		this.key, {
		String customTitle,
		this.strvalue,
		this.dataType=DataType.string,
    	this.fieldType,
		this.isDisable=false, 
		this.isHide=false, 
		this.subFields
		})
	{
		title = customTitle ?? key;
    	if(fieldType == null) setDefaultFields();
	}

  void setDefaultFields()
  {
  	//fieldType =FieldType.text;
    switch(dataType)
    {
      case DataType.string:   fieldType =FieldType.text; break;
      case DataType.int:      fieldType =FieldType.text; break;
      case DataType.float:    fieldType =FieldType.text; break;
      case DataType.bool:     fieldType =FieldType.checkbox; break;
      case DataType.object:   fieldType =FieldType.object; break;
      case DataType.array_string: fieldType =FieldType.select; break;
      case DataType.array_object: fieldType =FieldType.select; break;
      case DataType.dateTime: fieldType =FieldType.text; break;
    }
  }

	//String getType() => dataType.toString();
}