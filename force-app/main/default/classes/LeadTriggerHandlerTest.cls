@IsTest
public with sharing class LeadTriggerHandlerTest {
    
    @IsTest
    public static void testLeadTitleInserts() {
        
        // Retrieve a List<Lead> from TestData class
        List<Lead> testLeads = TestData.createTestLeads();

        // Construct and fill a Map<> with the key = Lead LastName and value = original Title
        Map<String, String> beforeIns = new Map<String, String>();
        for (Lead ld : testLeads) {
            beforeIns.put(ld.LastName, ld.Title);
        }

        test.startTest();
        insert testLeads;
        test.stopTest();

        // Requery the testLeads List 
        List<Lead> afterIns = [SELECT Id, LastName, Title FROM Lead WHERE Id IN :testLeads];
       
        // Parse the afterIns Leads and test the handleTitleNormalization method in the LeadTriggerHandler Class.
        for (Lead ld : afterIns) {
            
            if (beforeIns.get(ld.LastName) == 'vp' || beforeIns.get(ld.LastName).contains('v.p.') || beforeIns.get(ld.LastName).contains('vice president')) {   
                Assert.areEqual('Vice President', ld.Title, 'The Title was not changed to Vice President.');
            } else if (beforeIns.get(ld.LastName) == 'vip') {
                Assert.areNotEqual('Vice President', ld.Title, 'The Title was changed and should remain vip.');
            } else if (beforeIns.get(ld.LastName).contains('mgr') || beforeIns.get(ld.LastName).contains('manage') || beforeIns.get(ld.LastName).contains('head of department')) {
                Assert.areEqual('Manager', ld.Title, 'The Title was not changed to Vice President.');
            } else if (beforeIns.get(ld.LastName) == 'mngr') {
                Assert.areNotEqual('Manager', ld.Title, 'The Title was changed and should remain mngr.');
            } else if (beforeIns.get(ld.LastName).contains('exec') || beforeIns.get(ld.LastName) == 'chief' || beforeIns.get(ld.LastName).contains('head')) {
                Assert.areEqual('Executive', ld.Title, 'The Title was not changed to Executive.');
            } else if (beforeIns.get(ld.LastName) == 'Ex.') {
                Assert.areNotEqual('Executive', ld.Title, 'The Title was changed and should remain Ex.');
            } else if (beforeIns.get(ld.LastName).contains('assist') || beforeIns.get(ld.LastName).contains('deputy') || beforeIns.get(ld.LastName) == 'jr') {
                Assert.areEqual('Assistant', ld.Title, 'The Title was not changed to Assistant.');
            } else if (beforeIns.get(ld.LastName) == 'junior') {
                Assert.areNotEqual('Assistant', ld.Title, 'The Title was changed and should remain junior.');
            }          

        }        

    }
    
    @IsTest
    public static void testLeadTitleUpdates() {
        
        List<Lead> testLeads = TestData.createTestLeads();
        
        Map<String, String> beforeIns = new Map<String, String>();
        for (Lead ld : testLeads) {
            beforeIns.put(ld.LastName, ld.Title);
        }    

        insert testLeads;
        
        List<Lead> afterIns = [SELECT Id, LastName, Title FROM Lead WHERE Id IN :testLeads];

        //System.debug('afterIns: ' + JSON.serializePretty(afterIns));  

        List<Lead> missedLeads = new List<Lead>();
    
        for (Lead ld : afterIns) {
            if (ld.Title == 'vip') {
                ld.Title = 'vp';
                missedLeads.add(ld);
            } else if (ld.Title == 'mngr') {
                ld.Title = 'mgr';
                missedLeads.add(ld);
            } else if (ld.Title == 'Ex.') {
                ld.Title = 'exec';
                missedLeads.add(ld);
            } else if (ld.Title == 'junior') {
                ld.Title = 'assist';
                missedLeads.add(ld);
            }
            
        }
        
        //System.debug('missedLeads: ' + JSON.serializePretty(missedLeads));
        
        update missedLeads;      

        List<Lead> afterUpd = [SELECT Id, LastName, Title FROM Lead WHERE Id IN :missedLeads];

        //System.debug('afterUpd: ' + JSON.serializePretty(afterUpd));
        
        for (Lead ld : afterUpd) {
            if (beforeIns.get(ld.LastName) == 'vip') {
                Assert.areEqual('Vice President', ld.Title, 'The Title was not changed to Vice President.');
            } else if (beforeIns.get(ld.LastName) == 'mngr') {
                Assert.areEqual('Manager', ld.Title, 'The Title was not changed to Manager.');
            } else if (beforeIns.get(ld.LastName) == 'Ex.') {
                Assert.areEqual('Executive', ld.Title, 'The Title was not changed to Executive.');
            } else if (beforeIns.get(ld.LastName) == 'junior') {
                Assert.areEqual('Assistant', ld.Title, 'The Title was not changed to Assistant.');
            }              
        }

    }

    @IsTest
    public static void testAutoLeadScoring() {

        // Create Lead records for testing
        List<Lead> testLeads = TestData.createTestLeads();

        for (Lead tl : testLeads) {
            Integer leadScore = 10;
            if (tl.LeadSource == 'Website' && tl.Email != null) {
                leadScore = leadScore + 3;
            } 
            if (tl.Phone != null) {
                leadScore = leadscore + 5;
            }
            if (tl.Industry == 'Technology') {
                leadScore = leadScore + 10;
            }
            tl.Lead_Score__c = leadScore;
        }

        //System.debug('testLeads: ' + JSON.serializePretty(testLeads));

        insert testLeads;
        
        List<Lead> insLeads = [SELECT Id, LeadSource, Email, Phone, Industry, Lead_Score__c FROM Lead WHERE ID IN :testLeads];
        
        //System.debug('insLeads: ' + JSON.serializePretty(insLeads));

        for (Lead tl : insLeads) {
            Integer leadScore = 10;
            if (tl.LeadSource == 'Website' && tl.Email != null) {
                leadScore = leadScore + 3;
            } 
            if (tl.Phone != null) {
                leadScore = leadscore + 5;
            }
            if (tl.Industry == 'Technology') {
                leadScore = leadScore + 10;
            }
            //System.debug('leadScore:' + String.valueOf(leadScore));
            //System.debug('tl.Lead_Score__c: ' + String.valueOf(tl.Lead_Score__c));
            Assert.areEqual(leadScore, tl.Lead_Score__c, 'The calculated leadScore does not match the Lead_Score__c field value.');
        }

        for (Lead tl : insLeads) {
            tl.Email = null;
            tl.Phone = null;
            tl.Industry = null;
        }
        
        //System.debug('UPDATED insLeads: ' + JSON.serializePretty(insLeads));
        
        update insLeads;

        List<Lead> updatedLeads = [SELECT Id, LeadSource, Email, Phone, Industry, Lead_Score__c FROM Lead WHERE ID IN :testLeads];

        for (Lead tl : updatedLeads) {
            Integer leadScore = 10;
            if (tl.LeadSource == 'Website' && tl.Email != null) {
                leadScore = leadScore + 3;
            } 
            if (tl.Phone != null) {
                leadScore = leadscore + 5;
            }
            if (tl.Industry == 'Technology') {
                leadScore = leadScore + 10;
            }
            //System.debug('leadScore:' + String.valueOf(leadScore));
            //System.debug('tl.Lead_Score__c: ' + String.valueOf(tl.Lead_Score__c));
            Assert.areEqual(10, tl.Lead_Score__c, 'The Lead_Score__c should be 10.');
        }

    }

    @IsTest
    public static void testLeadAutoConvert() {

        // TEST INSERTED LEADS
        // Retrieve List<Contact>
        List<Contact> testContacts = TestData.createTestContacts();
        
        // Iterate over List<Contact> and build Set<String> of Contact Emails
        Set<String> setContactEmail = new Set<String>();
        for (Contact c : testContacts){
            setContactEmail.add(c.Email);
        }
        insert testContacts;
        
        // Retrieve List<Lead>
        List<Lead> testLeads = TestData.createTestLeads();     
        insert testLeads;
        
        // Iterate over inserted Leads and map LeadId(key) to IsConverted(Boolean; Value)
        Map<Id,Boolean> testLeadsConverted = new Map<Id,Boolean>();
        for (Lead l : testLeads) {
            Boolean foundEmail = setContactEmail.contains(l.Email);
            testLeadsConverted.put(l.Id, foundEmail);
        }

        List<Lead> insLeads = [SELECT Id, FirstName, LastName, Email, Status, IsConverted FROM Lead WHERE Id IN :testLeads];
        
        // Iterate over inserted Leads and check Converted Status against Map created above - Assert they should match for eavery Lead.
        for (Lead l : insLeads) {
            Assert.areEqual(testLeadsConverted.get(l.Id), l.IsConverted, 'The Lead Email and check for Contact Email do not match.');
        }

        // TEST UPDATED LEAD
        // Update single Lead record Email to match second Contact record Email.  This should fire auto-Convert for UPDATED record.
        testLeads[1].Email = testContacts[1].Email;
        update testLeads;

        List<Lead> updLeads = [SELECT Id, FirstName, LastName, Email, Status, IsConverted FROM Lead WHERE Id IN :testLeads];
        Assert.areEqual(updLeads[1].IsConverted, true);

        // Update updLeads - no conversions should occur
        
        update updLeads;
        List<Lead> upd2Leads = [SELECT Id, FirstName, LastName, Email, Status, IsConverted FROM Lead WHERE Id IN :testLeads];
        System.debug(JSON.serializePretty(upd2Leads));
        // for (Lead l : upd2Leads) {
        //     Assert.areEqual(upd2Leads.IsConverted, false);
        // }

    }
    
}