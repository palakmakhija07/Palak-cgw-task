public class CreateInvoiceController {
    public String originRecordId { get; set; }
     public String originRecord { get; set; }
    public String accountName { get; set; }
    public Date invoiceDate { get; set; }
    public Date invoiceDueDate { get; set; }
  
    public String lineItemDescription { get; set; }
    public Decimal lineItemQuantity { get; set; }
    public Decimal lineItemUnitPrice { get; set; }
    
    public String childRelationshipName { get; set; }
    public String lineItemDescriptionField { get; set; }
    public String lineItemQuantityField { get; set; }
    public String lineItemUnitPriceField { get; set; }
    
    public List<OppLineItem> lineItems { get; set; }
    public Map<String, String> urlParams { get; set; }
    
    public class OppLineItem {
        public String description { get; set; }
        public Decimal quantity { get; set; }
        public Decimal unitPrice { get; set; }
    }
    
     
        

    
     public CreateInvoiceController() {
        originRecordId = ApexPages.currentPage().getParameters().get('origin_record');
        accountName = ApexPages.currentPage().getParameters().get('account');
        invoiceDate = Date.valueOf(ApexPages.currentPage().getParameters().get('invoice_date'));
        invoiceDueDate = Date.valueOf(ApexPages.currentPage().getParameters().get('invoice_due_date'));
        childRelationshipName = ApexPages.currentPage().getParameters().get('child_relationship_name');
        lineItemDescriptionField = ApexPages.currentPage().getParameters().get('line_item_description');
        lineItemQuantityField = ApexPages.currentPage().getParameters().get('line_item_quantity');
        lineItemUnitPriceField = ApexPages.currentPage().getParameters().get('line_item_unit_price');
        originRecord='OpportunityId';
        urlParams = new Map<String, String>{
            'origin_record' => originRecordId,
            'account' => accountName,
            'invoice_date' => invoiceDate.format(),
            'invoice_due_date' => invoiceDueDate.format(),
            'child_relationship_name' => childRelationshipName,
            'line_item_description' => lineItemDescriptionField,
            'line_item_quantity' => lineItemQuantityField,
            'line_item_unit_price' => lineItemUnitPriceField
        };
        
        
        if (originRecordId != null && childRelationshipName != null) {
            String query = 'SELECT ' + lineItemDescriptionField + ', ' + lineItemQuantityField + ', ' + lineItemUnitPriceField +
                           ' FROM ' + childRelationshipName +
                           ' WHERE ' + originRecord + ' = :originRecordId';
            List<SObject> oppLineRecords = Database.query(query);
system.debug(query);

            lineItems = new List<OppLineItem>();
            for (SObject record : oppLineRecords) {
                OppLineItem item = new OppLineItem();
                item.description = (String) record.get(lineItemDescriptionField);
                item.quantity = (Decimal) record.get(lineItemQuantityField);
                item.unitPrice = (Decimal) record.get(lineItemUnitPriceField);
                lineItems.add(item);
            }
        }
    
       
    }
}