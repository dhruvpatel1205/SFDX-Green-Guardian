@isTest
private class PlantDefaultTriggerTest {
    @isTest
    static void testPlantDefaultValues() {
        CAMPX__Garden__c garden = new CAMPX__Garden__c(Name = 'Test Garden', CAMPX__Sun_Exposure__c = 'Full Sun');
        insert garden;
        CAMPX__Plant__c plant = new CAMPX__Plant__c(Name = 'Test Plant', CAMPX__Garden__c = garden.Id);

        Test.startTest();
        insert plant;
        Test.stopTest();

        CAMPX__Plant__c insertedPlant = [SELECT CAMPX__Soil_Type__c, CAMPX__Water__c, CAMPX__Sunlight__c FROM CAMPX__Plant__c WHERE Id =: plant.Id];
        System.assertEquals('All Purpose Potting Soil', insertedPlant.CAMPX__Soil_Type__c, 'Soil type is default.');
        System.assertEquals('Once Weekly', insertedPlant.CAMPX__Water__c,'Water should be default');
        System.assertEquals('Full Sun', insertedPlant.CAMPX__Sunlight__c,'Sunligth should be inherit from garden');
    }

    @isTest
    static void testPlantDefaultSunlightWhenGardenMissing() {
        CAMPX__Plant__c plant = new CAMPX__Plant__c(Name = 'Test Plant without Garden');
        Test.startTest();
        insert plant;
        Test.stopTest();

        CAMPX__Plant__c insertedPlant = [SELECT CAMPX__Sunlight__c FROM CAMPX__Plant__c WHERE Id =: plant.Id];
        System.assertEquals('Partial Sun', insertedPlant.CAMPX__Sunlight__c, 'Sunlight should be partial when no garden is there');
    }

    @isTest
    static void testPlantNotOverWrittingValues() {
        CAMPX__Garden__c garden = new CAMPX__Garden__c(Name = 'Custom Garden', CAMPX__Sun_Exposure__c = 'Full Shade');
        insert Garden;
        CAMPX__Plant__c plant = new CAMPX__Plant__c(Name = 'Custom Plant', 
        CAMPX__Soil_Type__c ='Sand',
        CAMPX__Water__c = 'Once Weekly',
        CAMPX__Sunlight__c = 'Full Shade',
        CAMPX__Garden__c = garden.Id);

        Test.startTest();
        insert plant;
        Test.stopTest();
        CAMPX__Plant__c insertedPlant = [SELECT CAMPX__Soil_Type__c, CAMPX__Water__c, CAMPX__Sunlight__c
                                            FROM CAMPX__Plant__c WHERE Id =: plant.Id];
        System.assertEquals('Sand', insertedPlant.CAMPX__Soil_Type__c,'This should not be overwritten');
        System.assertEquals('Once Weekly', insertedPlant.CAMPX__Water__c,'This should not be overwritten');
        System.assertEquals('Full Shade', insertedPlant.CAMPX__Sunlight__c,'This should not be overwritten');
    }
}