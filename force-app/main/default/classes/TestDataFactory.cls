@IsTest
public class TestDataFactory {
    
    public static List<Lead> createTestLeads() {
        
        Set<String> setSObjs = new Set<String>{'Lead'};
        Set<String> setFields = new Set<String>{'FirstName','LastName','Title','Email','LeadSource','Phone', 'Industry'};
        Set<String> setTitleValues = new Set<String>{'vp','v.p.','vice president','mr','manager','head of department','exec','assist'};
        //Set<String> set
        
        List<Lead> testLeads = new List<Lead>();
        
        List<TestData__c> testData =[SELECT sObjectName__c, FieldName__c, FieldValue__c, AssertedValue__c, AssertedOutcome__c FROM TestData__c];
        
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
        
        return testLeads;
    }


}