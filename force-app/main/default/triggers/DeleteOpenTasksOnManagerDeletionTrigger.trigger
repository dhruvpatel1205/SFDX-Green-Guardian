trigger DeleteOpenTasksOnManagerDeletionTrigger on CAMPX__Garden__c (after update) {
    Set<Id> gardenIdsToCheck = new Set<Id>();
    Map<Id, Id> oldManagerByGarden = new Map<Id, Id>();
    for(CAMPX__Garden__c updatedGarden : Trigger.new) {
        CAMPX__Garden__c oldGarden = Trigger.oldMap.get(updatedGarden.Id);
        Boolean managerUnassigned = oldGarden.CAMPX__Manager__c != null && 
                                updatedGarden.CAMPX__Manager__c == null;
        if(managerUnassigned) {
            gardenIdsToCheck.add(updatedGarden.Id);
            oldManagerByGarden.put(updatedGarden.Id, oldGarden.CAMPX__Manager__c);
        }
    }
    if(gardenIdsToCheck.isEmpty()) return;
    List<Task> taskToDelete = [SELECT Id, Subject, Status, OwnerId, WhatId FROM Task
                                WHERE WhatId IN :gardenIdsToCheck AND Subject = 'Acquire Plants'
                                AND Status != 'Completed' AND OwnerId IN :oldManagerByGarden.values()];
    List<Task> filteredTasks = new List<Task>();
    for(Task t : taskToDelete) {
        if(oldManagerByGarden.containsKey(t.WhatId) && oldManagerByGarden.get(t.WhatId) == t.OwnerId) {
            filteredTasks.add(t);
        }
    }
    delete filteredTasks;
}