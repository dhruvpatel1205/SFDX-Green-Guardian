@isTest
private class DeleteOpenTaskOnManagerDeleteTriggerTest {
    @isTest
    static void  testDeleteOpenTasksWhenManagerRemoved() {
        Id oldManagerId = UserInfo.getUserId();

        CAMPX__Garden__c roseGarden = new CAMPX__Garden__c(Name ='Rose Garden', CAMPX__Manager__c = oldManagerId);
        CAMPX__Garden__c mapleGarden = new CAMPX__Garden__c(Name = 'Maple Garden', CAMPX__Manager__c = oldManagerId);
        insert new List<CAMPX__Garden__c>{roseGarden, mapleGarden};
        Task roseGardenTask = new Task (
            Subject = 'Acquire Plants',
            OwnerId = oldManagerId,
            WhatId = roseGarden.Id,
            Status = 'Not Started'
        );

        Task mapleGardenTask = new Task (
            Subject = 'Acquire Plants',
            OwnerId = oldManagerId,
            WhatId = mapleGarden.Id,
            Status = 'Not Started'
        );
        insert new List<Task>{roseGardenTask, mapleGardenTask};
        roseGarden.CAMPX__Manager__c = null;
        Test.startTest();
        update roseGarden;
        Test.stopTest();
        List<Task> tasks =[SELECT Id, WhatId FROM Task WHERE Id IN :new List<Id>{roseGardenTask.Id, mapleGardenTask.Id}];
        System.assertEquals(1, tasks.size(), 'One task should be present');
        System.assertEquals(mapleGarden.Id, tasks[0].WhatId, 'Maple Garden task should be present');
    }

    @isTest
    static void testCompletedTaskIsNotDeleted() {
        Id managerId = UserInfo.getUserId();

        CAMPX__Garden__c garden = new CAMPX__Garden__c(Name ='Rose Garden', CAMPX__Manager__c = managerId);
        insert garden;
        Task completedTask = new Task(
            Subject = 'Acquire Plants',
            OwnerId = managerId,
            WhatId = garden.Id,
            Status = 'Completed'
        );
        insert completedTask;

        garden.CAMPX__Manager__c = null;

        Test.startTest();
        update garden;
        Test.stopTest();
        Task pendingTask = [SELECT Id FROM Task WHERE Id =: completedTask.Id];
        System.assertNotEquals(null, pendingTask, 'Completed task should not be deleted');
    }
}