@isTest
private class ReassignGardenTasksTriggerTest {
    @isTest
    static void testTaskReassignmentOnManagerChange() {
        Id oldManagerId = UserInfo.getUserId();

        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User newManager = new User(
            Alias = 'newmgr',
            Email = 'newmgr@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'NewManager',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'newmgr_' + System.currentTimeMillis() + '@test.com'
        );
        insert newManager;
        CAMPX__Garden__c garden = new CAMPX__Garden__c(Name = 'Evergreen Garden', CAMPX__Manager__c = oldManagerId);
        insert garden;
        Task task = new Task(
            WhatId = garden.Id,
            OwnerId = oldManagerId,
            Subject = 'Acquire Plants',
            Status = 'Not Started'
        );
        Task completedTask = new Task(
            WhatId = garden.Id,
            OwnerId = oldManagerId,
            Subject = 'Acquire Plants',
            Status = 'Completed'
        );
        insert new List<Task>{task, completedTask};
        garden.CAMPX__Manager__c = newManager.Id;
        Test.startTest();
        update garden;
        Test.stopTest();
        Task openAfter = [SELECT Id, OwnerId FROM Task WHERE Id =: task.Id];
        Task completedAfter = [SELECT Id, OwnerId FROM Task WHERE Id =: completedTask.Id];

        System.assertEquals(newManager.Id, openAfter.OwnerId,'Task should be reassigned to the new manager');
        System.assertEquals(oldManagerId,completedAfter.OwnerId,'Completed task should not be reassigned');
    }
}