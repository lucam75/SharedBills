public with sharing class Utils {
	public static Boolean hasSObjectField(String fieldName, SObject so) {
		return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
	}

	public static Boolean hasFieldInObject(String fieldName, String objectName) {
		return Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
	}
}
