//
//  BOEventViewController.m
//  FestivalOrders
//
//  Created by William Witt on 1/26/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "BOEventViewController.h"
#import "BOAppDelegate.h"
#import "BOAggregatedOrders.h"
#import "BONullSortDescriptor.h"

#import "Event.h"
#import "Order.h"
#import "Inventory.h"
#import "InventoryCategory.h"
#import "EventInventoryReserves.h"
#import "Band.h"

#import "BOReportViewController.h"
#import "NSColor+BOColor.h"

#import "BOColor.h"

@interface BOEventViewController ()

@end

@implementation BOEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    appDelegate = [[NSApplication sharedApplication] delegate];
    
    NSLog(@"awaking from nib");
    [self.eventArrayController addObserver:self forKeyPath:@"selectedObjects" options:NSKeyValueObservingOptionNew context:NULL];
    NSLog(@"TableView is: %@", self.tableView);
    
    colors = [[NSMutableArray alloc] init];
    [colors addObject:[[BOColor alloc] init:[NSColor blackColor] named:@"Black"]];
    [colors addObject:[[BOColor alloc] init:[NSColor blueColor] named:@"Blue"]];
    [colors addObject:[[BOColor alloc] init:[NSColor brownColor] named:@"Brown"]];
    [colors addObject:[[BOColor alloc] init:[NSColor darkGrayColor] named:@"Dark Gray"]];
    [colors addObject:[[BOColor alloc] init:[NSColor greenColor] named:@"Green"]];
    [colors addObject:[[BOColor alloc] init:[NSColor purpleColor] named:@"Purple"]];
    [colors addObject:[[BOColor alloc] init:[NSColor redColor] named:@"Red"]];
    
    [[self tableView] reloadData];
    
    NSSortDescriptor *categoryDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"category.name" ascending:YES];
    
    inventoryArray  =[self.inventoryArrayController.content sortedArrayUsingDescriptors:[NSArray arrayWithObject:categoryDescriptor]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //[self updateData];
    
    NSLog(@"TableView is: %@", self.tableView);

    [self  updateData];
    
}

- (void)updateData
{
    
    //inventoryArray  =[ self.inventoryArrayController.content sortedArrayUsingDescriptors:[NSArray arrayWithObject:categoryDescriptor]];
    
    //NSLog(@"TableView is: %@", self.tableView);
    
    aggregaredOrders = [[NSMutableDictionary alloc] init];
    
    //itemKeys = [[NSMutableArray alloc] init];
    //itemsOrdered = [[NSMutableDictionary alloc] init];
    //itemsDelivered = [[NSMutableDictionary alloc] init];
    //inventoryReserves = [[NSMutableDictionary alloc] init];
    //orders = [[NSMutableDictionary alloc] init];
    //bands = [[NSMutableDictionary alloc] init];
    
    InventoryCategory *cat = self.categoryFilterPopUp.selectedItem.representedObject;
    
        if(self.eventArrayController.selectionIndexes.count != 0){
            Event *event = [self.eventArrayController.selectedObjects objectAtIndex:0];
            for (Band *band in event.bands){
                for (Order * order in band.orders) {
                    if (!cat || !order.deliveredItem ||order.deliveredItem.category == cat) {
                        BOAggregatedOrders *aggOrder;
                        if (![aggregaredOrders valueForKey:order.orderKey]) {
                            aggOrder = [[BOAggregatedOrders alloc] init];
                        } else {
                            aggOrder = [aggregaredOrders valueForKey:order.orderKey];
                        }
                        
                        aggOrder.orderKey = order.orderKey;
                        
                        if (aggOrder.ordersArray) {
                            [aggOrder.ordersArray addObject:order];
                        } else {
                            aggOrder.ordersArray = [NSMutableArray arrayWithObject:order];
                        }
                        
                        if (order.deliveredItem) {
                            aggOrder.deliveredItem = order.deliveredItem;
                        }
                        
                        if ([aggOrder.orderQuantityDictionary valueForKey:order.requestedItem]) {
                            NSNumber *orderQty = [aggOrder.orderQuantityDictionary valueForKey:order.requestedItem];
                            orderQty = [NSNumber numberWithInt:[orderQty intValue] + [order.quantity intValue]];
                            [aggOrder.orderQuantityDictionary setObject:orderQty forKey:order.requestedItem];
                        } else {
                            [aggOrder.orderQuantityDictionary setObject:order.quantity forKey:order.requestedItem];
                        }
                        
                        if ([aggOrder.bandDeliveriesDictionary valueForKey:order.requestedItem]) {
                            NSNumber *orderQty = [aggOrder.bandDeliveriesDictionary valueForKey:order.band.name];
                            orderQty = [NSNumber numberWithInt:[orderQty intValue] + [order.quantity intValue]];
                            [aggOrder.bandDeliveriesDictionary setObject:orderQty forKey:order.band.name];
                        } else {
                            [aggOrder.bandDeliveriesDictionary setObject:order.quantity forKey:order.band.name];
                        }
                        
                        NSNumber *quantity = [NSNumber numberWithInt:0];
                        if (aggOrder.quantiyOrdered) {
                            quantity = aggOrder.quantiyOrdered;
                        }
                        aggOrder.quantiyOrdered = [NSNumber numberWithInt:[quantity intValue] + [order.quantity intValue]];
                        
                        for (EventInventoryReserves *res in band.event.inventoryReserves){
                            if (res.inventoryItem == order.deliveredItem) {
                                aggOrder.reserves = res;
                                break;
                            }

                        }
                        if (!aggOrder.reserves) {
                            EventInventoryReserves *res = [NSEntityDescription insertNewObjectForEntityForName:@"EventInventoryReserves" inManagedObjectContext:appDelegate.managedObjectContext];
                            res.event = event;
                            res.inventoryItem = order.deliveredItem;
                            res.reserveQuantity = [NSNumber numberWithInt:0];
                            aggOrder.reserves = res;
                        }
                        [aggregaredOrders setObject:aggOrder forKey:order.orderKey];
                        
                        /*int qty;
                        if ([orders valueForKey:order.orderKey]) {
                            qty = [(NSNumber *)[orders valueForKey:order.orderKey] integerValue];
                        } else {
                            qty = 0;
                        }
                        qty += [order.quantity integerValue];
                        [orders setValue:[NSNumber numberWithInt:qty] forKey:order.orderKey];
                        
                        if (![itemsDelivered valueForKey:order.orderKey]) {
                            [itemsDelivered setValue:order.deliveredItem forKey:order.orderKey];
                        }
                        
                        //Store requests in a dictionary per delivered item since multiple requested items might have the same delivered item;
                        NSMutableDictionary *itemsOrderedForDeliveredItem;
                        if (![itemsOrdered valueForKey:order.orderKey]) {
                            itemsOrderedForDeliveredItem = [[NSMutableDictionary alloc] init];
                        } else {
                            itemsOrderedForDeliveredItem = [itemsOrdered valueForKey:order.orderKey];
                        }
                        
                        int req = 0;
                        if ([itemsOrderedForDeliveredItem valueForKey:order.requestedItem]) {
                            req = [(NSNumber *)[itemsOrderedForDeliveredItem valueForKey:order.requestedItem] intValue] + [order.quantity intValue];
                        } else {
                            req = [order.quantity intValue];
                        }
                        [itemsOrderedForDeliveredItem setValue:[NSNumber numberWithInt:req] forKey:order.requestedItem];
                        [itemsOrdered setObject:itemsOrderedForDeliveredItem forKey:order.orderKey];
                        
                        
                        //get reserved items quantity
                        for (EventInventoryReserves *res in event.inventoryReserves) {
                            if ([res.inventoryItem.name isEqualToString:order.deliveredItem.name]) {
                                [inventoryReserves setValue:res forKey:order.orderKey];
                            }
                        }
                        
                        //set one to 0 if none exestis
                        if (![inventoryReserves objectForKey:order.orderKey])
                        {
                            EventInventoryReserves *res = [NSEntityDescription insertNewObjectForEntityForName:@"EventInventoryReserves" inManagedObjectContext:appDelegate.managedObjectContext];
                            res.event = event;
                            res.inventoryItem = order.deliveredItem;
                            res.reserveQuantity = 0;
                            [inventoryReserves setValue:res forKey:order.orderKey];
                        }
                        
                        NSMutableDictionary *bandDict;
                        
                        if (![bands valueForKey:order.orderKey]) {
                            bandDict = [[NSMutableDictionary alloc] init];
                        } else {
                            bandDict = [bands valueForKey:order.orderKey];
                        }
                        
                        int bandQty = [order.quantity intValue];
                        
                        if([bandDict valueForKey:band.name])
                            {
                             bandQty += [(NSNumber *)[bandDict valueForKey:band.name] intValue];
                            }
                        [bandDict setObject:[NSNumber numberWithInt:bandQty] forKey:band.name];
                        
                        [bands setValue:bandDict forKey:order.orderKey];
                         */
                    }
                }
            }
        }
    NSSortDescriptor *categoryDescriptor = [BONullSortDescriptor sortDescriptorWithKey:@"deliveredItem.category.name" ascending:YES];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderKey" ascending:YES];

    
    NSArray *tableItemArray = [[aggregaredOrders allValues] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:categoryDescriptor, nameDescriptor, nil ]];
    self.tableArray = [[NSMutableArray alloc] init];
    for (BOAggregatedOrders *inv in tableItemArray) {
        [self.tableArray addObject:inv];
    }
    
    [self.deliveriesArrayController rearrangeObjects];
    
    //[self.tableView display];
}



- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{

}

- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    [[self tableView] reloadData];
}



#pragma mark - NSTableView Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    [self updateData];
    return self.tableArray.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    //Inventory *item = [itemsDelivered valueForKey:[tableArray objectAtIndex:row]];
    //NSNumber *qty = [orders valueForKey:[tableArray objectAtIndex:row]];
    //NSNumber *reserve = [[inventoryReserves valueForKey:[[[tableArray objectAtIndex:row] deliveredItem] name]] reserveQuantity];
    
    
    if([tableColumn.identifier isEqualTo:@"Category"]){
        return [[[(BOAggregatedOrders *)[self.tableArray objectAtIndex:row] deliveredItem] category] name];
    } else if([tableColumn.identifier isEqualTo:@"ItemDelivered"]){
        return [[(BOAggregatedOrders *)[self.tableArray objectAtIndex:row] deliveredItem] name];
    } else if([tableColumn.identifier isEqualTo:@"ItemOrdered"]){
       return [(BOAggregatedOrders *)[self.tableArray objectAtIndex:row] requestedItems];
    } else if([tableColumn.identifier isEqualTo:@"Extra"]){
        return [[(BOAggregatedOrders *)[self.tableArray objectAtIndex:row] reserves] reserveQuantity];
    } else if([tableColumn.identifier isEqualTo:@"Price"]){
        return [[(BOAggregatedOrders *)[self.tableArray objectAtIndex:row] deliveredItem] price];
    } else if([tableColumn.identifier isEqualTo:@"OrderedQuantity"]){
        return [(BOAggregatedOrders *)[self.tableArray objectAtIndex:row] quantiyOrdered];
    } else if([tableColumn.identifier isEqualTo:@"Quantity"]){
         return [(BOAggregatedOrders *)[self.tableArray objectAtIndex:row] totalOrdered];
    } else if([tableColumn.identifier isEqualTo:@"Total"]){
        return [(BOAggregatedOrders *)[self.tableArray objectAtIndex:row] totalOrderPrice];
    } else if([tableColumn.identifier isEqualTo:@"Bands"]){
        return [(BOAggregatedOrders *)[self.tableArray objectAtIndex:row] bandOrders];
    }
    
    return nil;
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([tableColumn.identifier isEqualToString:@"Extra"]){
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([tableColumn.identifier isEqualToString:@"Extra"]){
        EventInventoryReserves *res = [inventoryReserves valueForKey:[self.tableArray objectAtIndex:row]];
        res.reserveQuantity = [NSNumber numberWithInt:[(NSString *)object intValue]];
        [inventoryReserves setObject:res forKey:[self.tableArray objectAtIndex:row]];
    } 
}



#pragma mark - NSComboBoxCellDatasource Methods


- (id)comboBoxCell:(NSComboBoxCell *)aComboBoxCell objectValueForItemAtIndex:(NSInteger)index
{
    return ((Inventory *)[inventoryArray objectAtIndex:index]).name;
}

- (NSUInteger)comboBoxCell:(NSComboBoxCell *)aComboBoxCell indexOfItemWithStringValue:(NSString *)string
{
    for(Inventory *inv in inventoryArray) {
        if ([inv.name isEqualToString:string]) {
            return [inventoryArray indexOfObject:inv];
        }
    }
    return NSNotFound;
}

- (NSInteger)numberOfItemsInComboBoxCell:(NSComboBoxCell *)comboBoxCell
{
    return inventoryArray.count;
}

- (NSString *)comboBoxCell:(NSComboBoxCell *)aComboBoxCell completedString:(NSString *)uncompletedString
{
    if (uncompletedString.length > 0){
        for(Inventory *inv in inventoryArray) {
            if ([inv.name hasPrefix:uncompletedString]) {
                return inv.name;
            }
        }
    }
    return uncompletedString;
}



#pragma mark - IBActions

- (IBAction)filterChanged:(id)sender {
    [self updateData];
}

- (IBAction)reserveQtyUpdated:(NSTextFieldCell *)sender {
    
}

- (IBAction)generateEventReport:(id)sender {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    // Build data set;
    
    // grab current event
    Event *event = self.eventArrayController.selectedObjects.firstObject;
    NSString *eventString = event.name;
    
    float totalCost = 0.0;
    
    // iterate through event bands
    NSMutableArray *reportArray = [[NSMutableArray alloc] init];
    [self updateData];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EventOrders" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString *styleContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //inject extra styles - none for band expense report
    NSString *styles = @"";
    for (InventoryCategory *cat in self.inventoryCategotyArrayContorller.arrangedObjects) {
        NSString *hexColorString = [(NSColor *)cat.color hexadecimalValueOfAnNSColor];
        styles = [styles stringByAppendingFormat:@".%@ td {color: %@;}\n", cat.name, hexColorString];
    }
    
    styleContent = [styleContent stringByReplacingOccurrencesOfString:@"[STYLEINJECT]" withString:styles];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[STYLE]" withString:styleContent];
    
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[EVENT]" withString:eventString];
    
    //Event logo
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[LOGO]" withString:[NSString stringWithFormat:@"file://%@", [[appDelegate getLogoURL] absoluteString]]];
    
    float eventTotal = 0.0;
    
    //table content
    NSString *tableString = @"";
    
    BOOL isAlt = NO;
    
    for (BOAggregatedOrders *agg in self.tableArray) {
        
        NSString *altString =@"primary";
        if(isAlt){
            altString =@"alt";
        }
        isAlt = !isAlt;
        
        tableString = [tableString stringByAppendingFormat:@"<tr class='%@ %@'><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",
                       agg.deliveredItem.category.name,
                       altString,
                       agg.deliveredItem.name,
                       agg.quantiyOrdered,
                       agg.reserves.reserveQuantity,
                       agg.totalOrdered,
                       [numberFormatter stringFromNumber:agg.deliveredItem.price],
                       [numberFormatter stringFromNumber:agg.totalOrderPrice],
                       agg.requestedItems];
        eventTotal += agg.totalOrderPrice.floatValue;
    }
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[ORDERS]" withString:tableString];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[EVENTTOTAL]" withString:[numberFormatter stringFromNumber:[NSNumber numberWithFloat:eventTotal]]];
    
    
    BOReportViewController *vc = [self.reportViewer delegate];
    [[vc.web mainFrame] loadHTMLString:htmlContent baseURL:nil];
    [self.reportViewer setIsVisible:YES];
}

- (IBAction)generateBandOrderReport:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BandOrderReport" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString *styleContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[STYLE]" withString:styleContent];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    if (self.bandArrayController.selectedObjects.count == 1) {
        
        Band *band = [self.bandArrayController.selectedObjects objectAtIndex:0];
        //Generate HTML
        NSString *eventString = @"";
        
        if(self.eventArrayController.selectionIndexes.count != 0){
            Event *event = [self.eventArrayController.selectedObjects objectAtIndex:0];
            eventString = event.name;
        }
        
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[EVENT]" withString:eventString];
        
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[BAND]" withString:band.name];
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[CONTACT]" withString:band.pointOfContact];
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[EMAIL]" withString:band.email];
 
        NSString *ordersString = @"";
        
        float eventTotal = 0.0;
        
        for (Order* order in band.orders) {
            float itemTotal = [order.quantity floatValue] * [order.deliveredItem.price floatValue];
            eventTotal += itemTotal;
            NSString *priceString = [numberFormatter stringFromNumber:order.deliveredItem.price];
            NSString *itemTotalString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:itemTotal]];
            
            ordersString = [ordersString stringByAppendingFormat:@"<tr><td>%@</td><td>%@</td><td>%li</td><td>%@</td></tr>",
                            order.deliveredItem.name, priceString, (long)[order.quantity integerValue], itemTotalString];
            
        }
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[ORDERS]" withString:ordersString];
        
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[EVENTTOTAL]" withString:[numberFormatter stringFromNumber:[NSNumber numberWithFloat:eventTotal]]];
        
        BOReportViewController *vc = [self.reportViewer delegate];
        [[vc.web mainFrame] loadHTMLString:htmlContent baseURL:nil];
        [self.reportViewer setIsVisible:YES];
    }

}

- (IBAction)generateOrderForm:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"OrderForm" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString *styleContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[STYLE]" withString:styleContent];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSString *itemString = @"";
    
    NSSortDescriptor *categoryDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"category.name" ascending:YES];
    
    NSArray *itemArray =[self.inventoryArrayController.content sortedArrayUsingDescriptors:[NSArray arrayWithObject:categoryDescriptor]];
    
    for(Inventory *item in itemArray) {
        itemString = [itemString stringByAppendingFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>&nbsp;</td></tr>",
                      item.category.name, item.name, [numberFormatter stringFromNumber:item.price]];

    }
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[ITEMS]" withString:itemString];

    BOReportViewController *vc = [self.reportViewer delegate];
    [[vc.web mainFrame] loadHTMLString:htmlContent baseURL:nil];
    [self.reportViewer setIsVisible:YES];

}


- (IBAction)generateBandExpenseReport:(id)sender {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    // Build data set;
    
    // grab current event
    Event *event = self.eventArrayController.selectedObjects.firstObject;
    NSString *eventString = event.name;
    
    float totalCost = 0.0;
    
    // iterate through event bands
    NSMutableArray *reportArray = [[NSMutableArray alloc] init];
    for (Band *band in event.bands)
    {
        NSMutableDictionary *bandDict = [[NSMutableDictionary alloc] init];
        
        [bandDict setObject:band.name forKey:@"bandName"];
        
        float cost = 0.0;
        for (Order *order in band.orders) {
            cost += [order.quantity floatValue] * [order.deliveredItem.price floatValue];
        }
        
        totalCost += cost;
        
        [bandDict setObject:[NSNumber numberWithFloat:cost] forKey:@"bandCost"];
        
        [reportArray addObject:bandDict];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BandExpenseReport" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString *styleContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //inject extra styles - none for band expense report
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[STYLE]" withString:styleContent];
    

    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[EVENT]" withString:eventString];
    
    //Event logo
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[LOGO]" withString:[NSString stringWithFormat:@"file://%@", [[appDelegate getLogoURL] absoluteString]]];
    
    BOOL isAlt = NO;
    
    //table content
    NSString *tableString = @"";
    for (NSMutableDictionary *bandDict in reportArray) {
        
        NSString *altString =@"primary";
        if(isAlt){
            altString =@"alt";
        }
        isAlt = !isAlt;
        
        NSString *bandName = [bandDict valueForKey:@"bandName"];
        NSString *bandCost = [numberFormatter stringFromNumber:[bandDict valueForKey:@"bandCost"]];
        
        tableString = [tableString stringByAppendingFormat:@"<tr class='%@'><td>%@</td><td>%@</td></tr>\n", altString, bandName, bandCost];
    }

    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[ITEMS]" withString:tableString];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[TOTAL]" withString:[numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalCost]]];

    
    BOReportViewController *vc = [self.reportViewer delegate];
    [[vc.web mainFrame] loadHTMLString:htmlContent baseURL:nil];
    [self.reportViewer setIsVisible:YES];
}

- (IBAction)generateCategoryReport:(id)sender {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    // Build data set;
    
    // grab current event
    Event *event = self.eventArrayController.selectedObjects.firstObject;
    NSString *eventString = event.name;
    
    float totalCost = 0.0;
    
    // iterate through event bands
    NSMutableArray *reportArray = [[NSMutableArray alloc] init];
    [self updateData];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CategoryReport" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString *styleContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //inject extra styles - none for band expense report
    NSString *styles = @"";
    for (InventoryCategory *cat in self.inventoryCategotyArrayContorller.arrangedObjects) {
        NSString *hexColorString = [(NSColor *)cat.color hexadecimalValueOfAnNSColor];
        styles = [styles stringByAppendingFormat:@".%@ td {color: %@;}\n", cat.name, hexColorString];
    }
    
    styleContent = [styleContent stringByReplacingOccurrencesOfString:@"[STYLEINJECT]" withString:styles];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[STYLE]" withString:styleContent];
    
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[EVENT]" withString:eventString];
    
    //Event logo
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[LOGO]" withString:[NSString stringWithFormat:@"file://%@", [[appDelegate getLogoURL] absoluteString]]];
    
    float eventTotal = 0.0;
    
    //table content
    NSString *tableString = @"";
    
    BOOL isAlt = NO;
    
    for (BOAggregatedOrders *agg in self.tableArray) {
        for (Order *order in agg.ordersArray) {
            NSString *altString =@"primary";
            if(isAlt){
                altString =@"alt";
            }
            isAlt = !isAlt;
            
            tableString = [tableString stringByAppendingFormat:@"<tr class='%@ %@'><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",
                           agg.deliveredItem.category.name,
                           altString,
                           agg.deliveredItem.category.name,
                           agg.deliveredItem.name,
                           order.band.name,
                           order.quantity];
            eventTotal += agg.totalOrderPrice.floatValue;
        }

    }
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[ORDERS]" withString:tableString];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[EVENTTOTAL]" withString:[numberFormatter stringFromNumber:[NSNumber numberWithFloat:eventTotal]]];
    
    
    BOReportViewController *vc = [self.reportViewer delegate];
    [[vc.web mainFrame] loadHTMLString:htmlContent baseURL:nil];
    [self.reportViewer setIsVisible:YES];
    
}
- (IBAction)addToInventory:(id)sender {
    
    Inventory *item = [NSEntityDescription insertNewObjectForEntityForName:@"Inventory" inManagedObjectContext:appDelegate.managedObjectContext];
    item.name = self.orderedItemTextView.stringValue;
    BOAggregatedOrders *agg = self.deliveriesArrayController.selectedObjects.firstObject;
    agg.deliveredItem = item;
    agg.reserves.inventoryItem = item;
    agg.reserves.event = self.eventArrayController.selectedObjects.firstObject;
    [self.inventoryArrayController setSelectedObjects:[NSArray arrayWithObject:item]];

    [self.tabView selectTabViewItemWithIdentifier:@"2"];
}
@end
