@isTest
private class GardenTaskTriggerTest {
    @isTest
    static void testTaskIsCreatedWhenManagerAssigned() {
        Id managerId = UserInfo.getUserId();
        CAMPX__Garden__c garden = new CAMPX__Garden__c(Name = 'Rose Garden', CAMPX__Manager__c = managerId);

        Test.startTest();
        insert garden;
        Test.stopTest();
        List<Task> tasks = [SELECT Id, WhatId, OwnerId, Subject FROM Task WHERE WhatId =: garden.Id];
        System.assertEquals(1, tasks.size(), 'One task should be created');
        System.assertEquals('Acquire Plants',tasks[0].Subject,'Subject should be same');
        System.assertEquals(managerId, tasks[0].OwnerId, 'Task should be assigned to the manager');
    }

    @isTest
    static void testNoTaskIsCreatedWithoutManager() {
        CAMPX__Garden__c garden = new CAMPX__Garden__c(Name = 'Rose Garden');

        Test.startTest();
        insert garden;
        Test.stopTest();

        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId =: garden.Id];
        System.assertEquals(0, tasks.size(), 'No task should be created');
    }
}