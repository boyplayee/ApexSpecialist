public with sharing class WarehouseCalloutService {

    public static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    
	@future(callout=true)
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
        	List<Object> equipments = (List<Object>) JSON.deserializeUntyped(response.getBody());
        	List<Product2> products = new List<Product2>();
        	
        	for(Object equipment : equipments){
        		Map<String, Object> mapProduct = (Map<String, Object>) equipment;
        		
        		Product2 product = new Product2();
                product.Name = (String)mapProduct.get('name');
                product.Cost__c = (Integer)mapProduct.get('cost');
                product.Current_Inventory__c = (Integer)mapProduct.get('quantity');
                product.Maintenance_Cycle__c = (Integer)mapProduct.get('maintenanceperiod');
                product.Replacement_Part__c = (Boolean)mapProduct.get('replacement');
                product.Lifespan_Months__c = (Integer)mapProduct.get('lifespan');
                product.Warehouse_SKU__c = (String)mapProduct.get('sku');
                product.ProductCode = (String)mapProduct.get('_id');
                products.add(product);
        	}
        	if(products.size() > 0){
                System.debug(products);
                upsert products;
                //여기서 왜 products만 해줬지?
                //아..세일즈포스상에서 inventory정보를 싱크맞춰줘야해서??
                //완전 같은 부품이라도 계속적으로 추가가 된다?
                //UPSERT를 쓴 이유, update or insert...
                //근데 어떤 id기준으로 upsert를 하는거지
                //To determine whether a record already exists, 
                //the upsert statement or Database method uses the record's ID
                //as the key to match records, a custom external ID field, 
                //or a standard field with the idLookup attribute set to true
                //Apex Specialist 질문글중에..
                //Your class maps the following fields: replacement part(always true),
                //cost, current inventory, lifespan, maintenance cycle, and warehouse SKU.
                //Use the warehouse SKU as the *external ID* to identify which equipment records
                //to update within Salesforce.
                //------->this confuses me..because there are multiple records with the exact same SKU
                //-->it was because I didn't set the field to be unique !!!!!!! stupid..
            }
        }
    }
}