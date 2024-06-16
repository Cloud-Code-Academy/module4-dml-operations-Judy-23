/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Your Name
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account myNewAccount = new Account();

        // Set some fields on the Account
        myNewAccount.Name = 'Skillsshare';
        myNewAccount.Type = 'Education';
        
        // Insert the Account into the database
        insert myNewAccount;

        // Return the Id of the newly created Account
        return myNewAccount.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account myTravelAccount = new Account(Name = name, Industry = industry);
        
        // Insert the Account
        insert myTravelAccount;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact myNewContact = new Contact();
        // Set some fields on the Contact
        myNewContact.FirstName = 'Jane';
        myNewContact.LastName = 'Doe';

        // Set the AccountId field to the given accountId
        myNewContact.AccountId = accountId;

        // Insert the Contact into the database
        insert myNewContact;

        // Return the Id of the newly created Contact
        return myNewContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        Contact myUpdateContact = new Contact();
        myUpdateContact = [SELECT Id, LastName FROM Contact WHERE Id = :contactId LIMIT 1];
       
        // Update the Contact's last name
        myUpdateContact.LastName = newLastName;

        // Update the Contact in the database
        update myUpdateContact;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
       Opportunity myUpdateOpportunity = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId LIMIT 1];

        // Update the Opportunity's stage
        myUpdateOpportunity.StageName = newStage;

        // Update the Opportunity in the database
        update myUpdateOpportunity;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        Account myUpdateAccount = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId LIMIT 1];

        // Update the Account with the given Id with the new name and industry  
       myUpdateAccount.Name = newName;
       myUpdateAccount.Industry = newIndustry;

        //update myUdateAccount;
        update myUpdateAccount;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
        for (Opportunity myOpportunity : opportunities) { 

            // Set the Opportunity's Stage to Qualification
            myOpportunity.StageName = 'Qualification';

            // Set the Opportunity's Close Date to 3 months from today
            myOpportunity.CloseDate = Date.today().addMonths(3);

            // Set the Opportunity's Amount to 50000
            myOpportunity.Amount = 50000;
    }
        // Upsert the opportunities List so that records are either updated or created
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
       Account myAccount = new Account (Name = accountName);
       upsert myAccount;
        
 
         // Query the Account again to get the Id if it was inserted
         myAccount = [SELECT Id FROM Account WHERE Name = :accountName WITH SECURITY_ENFORCED LIMIT 1];
 
         // Create a list to hold the Opportunities
         List <Opportunity> opportunitiesToUpsert = new List<Opportunity>();
         
         // query opportunies to check if they exist
         Map<String, Opportunity> existingOpportunitiesMap = new Map<String, Opportunity>();
         for (Opportunity opp : [SELECT Id, Name FROM Opportunity WHERE Name IN :oppNames AND AccountId = :myAccount.Id WITH SECURITY_ENFORCED]) {
            existingOpportunitiesMap.put(opp.Name, opp);
         }
 

         // Loop through each Opportunity name
        
         for (String oppName : oppNames) {
             // Create an Opportunity with the given name
             Opportunity opp;
             if (existingOpportunitiesMap.containsKey(oppName)){
                opp = existingOpportunitiesMap.get(oppName);
                opp.StageName = 'Qualification';
                opp.CloseDate = Date.today().addMonths(1);
                opp.Amount = 50000;
             } else {
                opp = new Opportunity(
                    Name = oppName,
                    AccountId = myAccount.Id,
                    StageName = 'Qualification',
                    CloseDate = Date.today().addMonths(1),
                    Amount = 50000
                );
             }
             opportunitiesToUpsert.add (opp); 
         }

         // Upsert the opportunities list so that records are either updated or created
         upsert opportunitiesToUpsert;
     }

    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = :accountName];

        Account accountToUpsert;
		// if the Account exists, update the description
        if (!accounts.isEmpty()) {
            accountToUpsert = accounts[0];
            accountToUpsert.Description = 'Updated Account';
        } else {
		// otherwise, create a new Account and set the description
        accountToUpsert = new Account(
                Name = accountName,
                Description = 'New Account'
            );
        }

		// Upsert the Account
        upsert accountToUpsert;

		 // Return the Account that was upserted
        return accountToUpsert;
    }
	

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact
        for (Contact contact : contactsToUpsert) {

		// Extract the Account Name from Contact's LastName
        String accountName = contact.LastName;

		// Get the account based on the name or create one if it doesn't exist
        Account associatedAccount = upsertAccount(accountName);

		// Link the Contact to its Account using the Account Id
        contact.AccountId = associatedAccount.Id;
        }

		// Upsert the Contacts
        upsert contactsToUpsert;
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // List to hold Lead records
        List<Lead> leadsToInsert = new List<Lead>();

        // Loop through each Lead name
        for (String leadName : leadNames) {
            Lead newLead = new Lead(
                FirstName = leadName,
                LastName = 'Kamau', // Example last name, you can adjust as needed
                Company = 'Family Bank' // Example company name, you can adjust as needed
            );
            leadsToInsert.add(newLead);
        }

        // Insert the Leads
        insert leadsToInsert;
    
        // Delete the Leads
        delete leadsToInsert;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
       // List to hold Case records
       List<Case> casesToInsert = new List<Case>();

        // Create Case records dynamically
        for (Integer i = 0; i < numOfCases; i++) {
            Case newCase = new Case(
                Subject = 'Case ' + (i + 1),
                AccountId = accountId,
                Description = 'Description for Case ' + (i + 1)
            );
            casesToInsert.add(newCase);
        }

        // Insert the cases
        insert casesToInsert;


        // Delete the cases
        delete casesToInsert;
    }
}
