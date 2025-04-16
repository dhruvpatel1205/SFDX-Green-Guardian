trigger GardenManagerAssignmentTrigger on CAMPX__Garden__c (after update) {
    List<Task> taskToInsert = new List<Task>();
    for(CAMPX__Garden__c garden : Trigger.new) {
        CAMPX__Garden__c oldGarden = Trigger.oldMap.get(garden.Id);
        Boolean managerAssigned = oldGarden.CAMPX__Manager__c == null && garden.CAMPX__Manager__c != null;
        if(managerAssigned) {
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