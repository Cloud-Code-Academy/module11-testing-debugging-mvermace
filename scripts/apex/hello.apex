// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// List<TestData__c> td = [SELECT Id FROM TestData__c];
// System.debug('td: ' + JSON.serializePretty(td));

List<Lead> leads = TestData.createTestLeads();
System.debug('leads: ' + JSON.serializePretty(leads));