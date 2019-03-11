enum FieldType {text, textbox, checkbox, select, object}
enum DataType {string, bool, int, float, object, array_string, array_object}

class DbField {
  
	String key;
	String strvalue;

	String title;
	DataType dataType;
	FieldType fieldType;
	
	bool isDisable;
	bool isHide;

	//only for map type
	List<DbField> subFields;

	DbField(this.key, {
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
    switch(dataType)
    {
      case DataType.string:   fieldType =FieldType.text; break;
      case DataType.int:      fieldType =FieldType.text; break;
      case DataType.float:    fieldType =FieldType.text; break;
      case DataType.bool:     fieldType =FieldType.checkbox; break;
      case DataType.object:   fieldType =FieldType.object; break;
      case DataType.array_string: fieldType =FieldType.select; break;
      case DataType.array_object: fieldType =FieldType.select; break;
    }
  }

	//String getType() => dataType.toString();
}