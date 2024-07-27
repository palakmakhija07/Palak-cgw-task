public class DisplayInvoiceJSONController {
    public String invoiceJSON { get; set; }

    public DisplayInvoiceJSONController() {
        invoiceJSON = ApexPages.currentPage().getParameters().get('invoiceJSON');
    }

    public PageReference createInvoice() {
        Map<String, Object> invoiceData = (Map<String, Object>) JSON.deserializeUntyped(invoiceJSON);

        Invoice__c newInvoice = new Invoice__c();
        newInvoice.Account__c = (String) invoiceData.get('AccountId');
        newInvoice.Invoice_Date__c = Date.valueOf((String) invoiceData.get('Date'));
        newInvoice.Due_Date__c = Date.valueOf((String) invoiceData.get('DueDate'));
        newInvoice.Invoice_Reference__c = (String) invoiceData.get('Reference');
        insert newInvoice;

        List<Map<String, Object>> lineItems = (List<Map<String, Object>>) invoiceData.get('LineItems');
        List<Invoice_Line_Item__c> newLineItems = new List<Invoice_Line_Item__c>();
        for (Map<String, Object> lineItem : lineItems) {
            Invoice_Line_Item__c newLineItem = new Invoice_Line_Item__c();
            newLineItem.Invoice__c = newInvoice.Id;
            newLineItem.Line_Description__c    = (String) lineItem.get('Description');
            newLineItem.Quantity__c = (Decimal) lineItem.get('Quantity');
            newLineItem.Unit_Price__c = (Decimal) lineItem.get('UnitAmount');
            //newLineItem.Amount__c= (Decimal) lineItem.get('LineAmount');
            newLineItems.add(newLineItem);
        }
        insert newLineItems;
        PageReference invoicePage = new PageReference('/' + newInvoice.Id);
        invoicePage.setRedirect(true);
        return invoicePage;
    }
}