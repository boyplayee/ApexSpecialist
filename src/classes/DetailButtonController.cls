public class DetailButtonController {
    private ApexPages.StandardController standardController;
	private PageReference pageRef = new PageReference('https://www.naver.com/');
    public DetailButtonController(ApexPages.StandardController standardController) 
    { 
        this.standardController = standardController;
    }

    public PageReference doSomething()
    {
        // Apex code for handling record from a Detail page goes here
        Id recordId = standardController.getId();
        Work_Part__c record = (Work_Part__c) standardController.getRecord();  //-->해당 레코드를 찾아냄
        List<Product2> relatedProducts = new List<Product2>();
        return (pageRef); //후 여기서 또 Equipment List페이지를 어떻게 띄운담~
    }   
}