trigger ReassignGardenTaskTrigger on CAMPX__Garden__c (after update) {
    Map<Id,Id> gardenToReassign = new Map<Id,Id>();
    Map<Id,Id> oldManager = new Map<Id,Id>();
    
    for(CAMPX__Garden__c garden : Trigger.new) {
        CAMPX__Garden__c oldGarden = Trigger.oldMap.get(garden.Id);
        Boolean ChangeManager = garden.CAMPX__Manager__c != null &&
                                oldGarden.CAMPX__Manager__c != null &&
                                garden.CAMPX__Manager__c != oldGarden.CAMPX__Manager__c;
        if(ChangeManager) {
            gardenToReassign.put(garden.Id, garden.CAMPX__Manager__c);
            oldManager.put(garden.Id, oldGarden.CAMPX__Manager__c);
        }
    }

    if (gardenToReassign.isEmpty()) return;

    List<Task> taskToUpdate = [SELECT Id, WhatId, OwnerId, Subject, Status FROM Task
                                WHERE Subject = 'Acquire Plants'
                                AND Status != 'Completed'
                                AND WhatId IN :gardenToReassign.keySet()
                                AND OwnerId IN :oldManager.values()];
    
    for(Task t : taskToUpdate) {
        Id newOwnerId = gardenToReassign.get(t.WhatId);
        t.OwnerId = newOwnerId;
    }
    update taskToUpdate;
}