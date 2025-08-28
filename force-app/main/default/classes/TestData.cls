public class TestData {
        
    @TestVisible
    public static List<Lead> createTestLeads() {
                     
        //Set<String> setFields = new Set<String>{'FirstName','LastName','Title','Email','LeadSource','Phone', 'Industry'};
        Set<String> setTitleValues = new Set<String>{'vp','v.p.','vice president','vip', 'mgr','manage','head of department','mngr','exec','chief','head','Ex.','assist','deputy','jr','junior','other'};
        Set<String> setLeadSourceValues = new Set<String>{'Web','Phone Inquiry'};
        
        List<Lead> testLeads = new List<Lead>();

        Integer newLeadNum = 0;

        for (String title : setTitleValues) {
            
            for (String leadSource : setLeadSourceValues) {
            
                Lead newTestLead = new Lead();
                
                newTestLead.FirstName = 'test';
                newTestLead.LastName = 'lead' + String.valueOf(newLeadNum);
                newTestLead.Title = title;
                newTestLead.Company = 'test company';
                newTestLead.Email = 'test' + String.valueOf(newLeadNum) + '@test.com';
                newTestLead.LeadSource = (Math.mod(newLeadNum,2) == 0) ? 'Website' : 'Phone Inquiry';
                newTestLead.Phone = (Math.mod(newLeadNum,3) == 0) ? '123-456-7890' : null;
                newTestLead.Industry = (Math.mod(newLeadNum,4) == 0) ? 'Technology' : 'Other';
                
                testLeads.add(newTestLead);
                
                newLeadNum++;

            }
                
        }
        
        return testLeads;

    }  

    @TestVisible
    public static List<Contact> createTestContacts() {

        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        List<Contact> testContacts = new List<Contact>();

        Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'contact0';
        c.Email = 'test0@test.com';
        c.AccountId = a.Id;
        testContacts.add(c);

        Contact c2 = new Contact();
        c2.FirstName = 'test';
        c2.LastName = 'contact100';
        c2.Email = 'test100@test.com';
        c2.AccountId = a.Id;
        testContacts.add(c2);
                
        return testContacts;

    }

}