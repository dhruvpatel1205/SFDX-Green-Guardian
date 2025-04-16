@isTest
private class GardenManagerAssignmentTriggerTest {
    @isTest
    static void testTaskCreatedWhenManagerIsAssigned() {
        Id managerId = UserInfo.getUserId();

        CAMPX__Garden__c garden = new CAMPX__Garden__c(Name ='Rose Garden');
        insert garden;
        garden.CAMPX__Manager__c = managerId;
        Test.startTest();
        update garden;
        Test.stopTest();
        List<Task> tasks = [SELECT Id, WhatId, OwnerId, Subject FROM Task WHERE WhatId =: garden.Id];
        System.assertEquals(1, tasks.size(), 'One task should be created');
        System.assertEquals(managerId, tasks[0].OwnerId, 'Task should be assigned to the manager');
        System.assertEquals('Acquire Plants', tasks[0].Subject, 'Subject should be same');
    }

    @isTest
    static void testNoTaskCreatedManagerPresent() {
        Id managerId = UserInfo.getUserId();

        CAMPX__Garden__c garden = new CAMPX__Garden__c(Name = 'Rose Garden', CAMPX__Manager__c = managerId);
        insert garden;

        garden.Name = 'Updated Garden';

        Test.startTest();
        update garden;
        Test.stopTest();

        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId =: garden.Id];
        System.assertEquals(1, tasks.size(), 'No task should be created Manager is already present');
    }

    @isTest
    static void testNoTaskCreatedManagerStillNull () {
        CAMPX__Garden__c garden = new CAMPX__Garden__c(Name = 'Rose Garden');
        insert garden;
        garden.Name = 'Updated Garden';
        Test.startTest();
        update garden;
        Test.stopTest();
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId =: garden.Id];
        System.assertEquals(0, tasks.size(), 'No task should be created Manager is still null');
    }
}