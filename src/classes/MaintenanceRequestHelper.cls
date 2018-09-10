public class MaintenanceRequestHelper {

    public static void updateWorkOrders(Map<Id, Case> cases){
    	
    	// When testing this method, consider using a Test Data Factory 
        // class or create all the data 
    	
    	// Create a list of Cases 
        List<Case> maintenance_routineList = new List<Case>();
        
        // Create a list to store the Product Maintenance Cycle
        List<Product2> listProduct = [Select Id, Maintenance_Cycle__c from Product2];  
        Map<Id,decimal> mapProduct = new Map<Id, decimal>(); //cycle이 소숫점일수도 있으니까?

        for (Product2 p : listProduct) {
            if (p != null) {
                if(p.Maintenance_Cycle__c != null){
                    mapProduct.put(p.Id, p.Maintenance_Cycle__c);
                }
            }
        }//map에 product '아이디'와 '사용기간' 짝지어서 저장

        System.debug('product: '+mapProduct);
        
        // Now, let's make the magic happen 
        for(Case maintenance:cases.values()){ // 맵 밸류값만큼 루프돌리기, 여기서 받아온 파라미터값을 이용
            Case maintenanceNew = new Case();
            
            maintenanceNew.Subject = maintenance.Subject;  //이런식으로 필드값 하나씩 넣을 수 있음 
            		
            System.debug('Second: ' + mapProduct.get(maintenance.Equipment__c));
            if (mapProduct.get(maintenance.Equipment__c) != null) { //해당 Case의 Equipment를 mapProduct가 가지고있으면
            	
            	// Set the Due Date for the next maintenance 오로지 Date_Due__c 필드값을 채우기 위해 이렇게 한것임. value값으로 바로 찾음  
                 maintenanceNew.Date_Due__c = Date.today().addDays(Integer.valueOf(mapProduct.get(maintenance.Equipment__c)));

            }
            maintenanceNew.Vehicle__c = maintenance.Vehicle__c;
            maintenanceNew.Product__c = maintenance.Product__c;
            maintenanceNew.ContactId  = maintenance.ContactId;
            maintenanceNew.AccountId  = maintenance.AccountId;
            maintenanceNew.AssetId    = maintenance.AssetId;
            maintenanceNew.Type       = 'Routine Maintenance';
            maintenanceNew.Status     = 'New';
            maintenanceNew.Equipment__c = maintenance.Equipment__c;
            maintenanceNew.Date_Reported__c = Date.today();

            // Add this new maintenance to the list
            maintenance_routineList.add(maintenanceNew);
        }
        
        // Finally, with all complete list of future maintenance, we can now add the records:
        insert maintenance_routineList;
    }
}