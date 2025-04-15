trigger GardenTaskTrigger on CAMPX__Garden__c (after insert) {
    List<Task> taskToInsert = new List<Task>();
    for(CAMPX__Garden__c garden : Trigger.new) {
        if(garden.CAMPX__Manager__c != null) {
            Task t = new Task(
                WhatId = garden.Id,
                OwnerId = garden.CAMPX__Manager__c,
                Subject = 'Acquire Plants'
            );
            taskToInsert.add(t);
        }
    }
    insert taskToInsert;
}