trigger PlantDefaultTrigger on CAMPX__Plant__c (before insert) { 
    Set<Id> gardenIds = new Set<Id>();
    for(CAMPX__Plant__c plant : Trigger.new){
        if(plant.CAMPX__Garden__c != null) {
            gardenIds.add(plant.CAMPX__Garden__c);
        }
    }
    Map<Id, String> gardenSunLightMap = new Map<Id, String>();
    if(!gardenIds.isEmpty()) {
        for(CAMPX__Garden__c garden: [SELECT Id, CAMPX__Sun_Exposure__c FROM CAMPX__Garden__c WHERE Id IN :gardenIds] ){
        gardenSunLightMap.put(garden.Id, garden.CAMPX__Sun_Exposure__c);
        }
    }
    for(CAMPX__Plant__c plant: Trigger.new) {
        if(plant.CAMPX__Soil_Type__c == null) {
            plant.CAMPX__Soil_Type__c = 'All Purpose Potting Soil';
        }
        if(plant.CAMPX__Water__c == null) {
            plant.CAMPX__Water__c ='Once Weekly';
        }
        if(plant.CAMPX__Sunlight__c == null){
            if(plant.CAMPX__Garden__c != null && gardenSunLightMap.containsKey(plant.CAMPX__Garden__c) && gardenSunLightMap.get(plant.CAMPX__Garden__c)!= null) {
                plant.CAMPX__Sunlight__c = gardenSunLightMap.get(plant.CAMPX__Garden__c);
            } else {
                plant.CAMPX__Sunlight__c = 'Partial Sun';
            }
        }
    }
}