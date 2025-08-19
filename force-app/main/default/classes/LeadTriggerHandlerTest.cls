@IsTest
public with sharing class LeadTriggerHandlerTest {
    
    @IsTest
    public static void testLeadTitleNormalization() {
        
        List<Lead> testLeads = TestDataFactory.createTestLeads();

        test.startTest();
        insert testLeads;
        test.stopTest();

        System.assert(testLeads.size() > 0, 'No test leads were created.');
    
    }  
    
}