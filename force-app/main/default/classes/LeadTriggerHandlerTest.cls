@IsTest
public with sharing class LeadTriggerHandlerTest {
    
    @IsTest
    public static void testLeadTitleNormalization() {
        
        List<Lead> testLeads = new List<Lead>();
        
        List<TestData__c> testData = [
            SELECT 
                Id, 
                sObjectName__c, 
                FieldName__c, 
                FieldValue__c, 
                AssertedValue__c, 
                AssertedOutcome__c 
            FROM TestData__c
            WHERE
                SObjectName__c = 'Lead' AND
                FieldName__c = 'Title'
            ];

        for (TestData__c tf : testData) {
            Lead newTestLead = new Lead();
            Integer newLeadNum = 0;
            if (tf.sObjectName__c == 'Lead') {
                newTestLead.FirstName = 'test';
                newTestLead.LastName = 'lead' + String.valueOf(newLeadNum);
                newTestLead.title = tf.FieldValue__c;
                newTestLead.LeadSource = 'Web';
                newTestLead.Email = 'test@test.com';
                testLeads.add(newTestLead);
            }
        }

        test.startTest();
        insert testLeads;
        test.stopTest();

        System.assert(testLeads.size() > 0);
    
    }  
    
}