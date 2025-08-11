@IsTest()
public class LeadTestFactory {
    
    public static List<Lead> createTestLeads() {
        return [SELECT sObjectName__c, FieldName__c, FieldValue__c, AssertedValue__c, AssertedOutcome__c FROM TestData__c];
    }


}