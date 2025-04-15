@isTest
private class GardenDefaultTriggerTest {
    @isTest
    static void testGardenDefaultValue() {
        CAMPX__Garden__c garden = new CAMPX__Garden__c(Name = 'Test Gardeb');
        Test.startTest();
        insert garden;
        Test.stopTest();

        CAMPX__Garden__c insertedGarden = [SELECT CAMPX__Status__c,CAMPX__Max_Plant_Count__c,
                                            CAMPX__Minimum_Plant_Count__c, CAMPX__Total_Plant_Count__c, CAMPX__Total_Unhealthy_Plant_Count__c
                                            FROM CAMPX__Garden__c WHERE Id=: garden.Id];
        
        System.assertEquals('Awaiting Resources', insertedGarden.CAMPX__Status__c, 'Status should be set to Awaiting Resources.');
        System.assertEquals(100, insertedGarden.CAMPX__Max_Plant_Count__c, 'Max Plant Count should be 100.');
        System.assertEquals(1, insertedGarden.CAMPX__Minimum_Plant_Count__c, 'Minimum Plant Count should be 1.');
        System.assertEquals(0, insertedGarden.CAMPX__Total_Plant_Count__c, 'Total Plant Count should be 0.');
        System.assertEquals(0, insertedGarden.CAMPX__Total_Unhealthy_Plant_Count__c, 'Total Unhealthy Plant Count should be 0.');
    }

    @isTest
    static void testGardenDoesNotOverWriteValues() {
        CAMPX__Garden__c garden = new CAMPX__Garden__c(Name = 'Custom Garden',
                                                        CAMPX__Status__c = 'Operational',
                                                        CAMPX__Max_Plant_Count__c = 50,
                                                        CAMPX__Minimum_Plant_Count__c = 5,
                                                        CAMPX__Total_Plant_Count__c = 20,
                                                        CAMPX__Total_Unhealthy_Plant_Count__c = 2);
        
        Test.startTest();
        insert garden;
        Test.stopTest();

        CAMPX__Garden__c insertedGarden = [SELECT CAMPX__Status__c, CAMPX__Max_Plant_Count__c,
                                            CAMPX__Minimum_Plant_Count__c, CAMPX__Total_Plant_Count__c, CAMPX__Total_Unhealthy_Plant_Count__c
                                            FROM CAMPX__Garden__c WHERE Id=: garden.Id];
        System.assertEquals('Operational', insertedGarden.CAMPX__Status__c, 'Status should not be overwritten.');
        System.assertEquals(50, insertedGarden.CAMPX__Max_Plant_Count__c, 'Max Plant Count should remain 50.');
        System.assertEquals(5, insertedGarden.CAMPX__Minimum_Plant_Count__c, 'Minimum Plant Count should remain 5.');
        System.assertEquals(20, insertedGarden.CAMPX__Total_Plant_Count__c, 'Total Plant Count should remain 20.');
        System.assertEquals(2, insertedGarden.CAMPX__Total_Unhealthy_Plant_Count__c, 'Total Unhealthy Plant Count should remain 2.');
    }
}