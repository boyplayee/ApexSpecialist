public with sharing class ListButtonController {
	private ApexPages.StandardSetController standardSetController;

    public ListButtonController(ApexPages.StandardSetController standardSetController) 
    { 
        this.standardSetController = standardSetController;
    }

    public PageReference doSomething()
    {
        // Apex code for handling records from a List View goes here
        List<Product2> listViewRecords = 
            (List<Product2>) standardSetController.getRecords();
        List<Product2> selectedListViewRecords = 
            (List<Product2>) standardSetController.getSelected();
        Boolean hasMore = standardSetController.getHasNext();
        return null;
    }
}