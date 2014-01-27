//
//  BOEventViewController.m
//  FestivalOrders
//
//  Created by William Witt on 1/26/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "BOEventViewController.h"
#import "Event.h"
#import "Order.h"
#import "Inventory.h"
#import "InventoryCategory.h"
#import "Band.h"

#import "BOReportViewController.h"

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
    NSLog(@"awaking from nib");
    [self.eventArrayController addObserver:self forKeyPath:@"selectedObjects" options:NSKeyValueObservingOptionNew context:NULL];
    NSLog(@"TableView is: %@", self.tableView);

    [[self tableView] reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //[self updateData];
    
    NSLog(@"TableView is: %@", self.tableView);

    [[self tableView] reloadData];
    
}

- (void)updateData
{
    NSLog(@"TableView is: %@", self.tableView);

    items = [[NSMutableDictionary alloc] init];
    orders = [[NSMutableDictionary alloc] init];
    bands = [[NSMutableDictionary alloc] init];
    
        if(self.eventArrayController.selectionIndexes.count != 0){
            Event *event = [self.eventArrayController.selectedObjects objectAtIndex:0];
            for (Band *band in event.bands){
                for (Order * order in band.orders) {
                    int qty;
                    if ([orders valueForKey:order.inventoryitem.name]) {
                        qty = [(NSNumber *)[orders valueForKey:order.inventoryitem.name] integerValue];
                    } else {
                        qty = 0;
                    }
                    qty += [order.quantity integerValue];
                    [orders setValue:[NSNumber numberWithInt:qty] forKey:order.inventoryitem.name];
                    
                    if (![items valueForKey:order.inventoryitem.name]) {
                        [items setValue:order.inventoryitem forKey:order.inventoryitem.name];
                    }
                    
                    NSMutableArray *bandArray;
                    
                    if (![bands valueForKey:order.inventoryitem.name]) {
                        bandArray = [[NSMutableArray alloc] init];
                    } else {
                        bandArray = [bands valueForKey:order.inventoryitem.name];
                    }
                    [bandArray addObject:[NSString stringWithFormat:@"%@ - %li", band.name, qty]];
                    [bands setValue:bandArray forKey:order.inventoryitem.name];
                }
            }
        }
    
    tableArray = [items allKeys];
    [self.tableView display];
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
    return tableArray.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Inventory *item = [items valueForKey:[tableArray objectAtIndex:row]];
    NSNumber *qty = [orders valueForKey:[tableArray objectAtIndex:row]];
    
    
    if([tableColumn.identifier isEqualTo:@"Item"]){
        return [tableArray objectAtIndex:row];
    } else if([tableColumn.identifier isEqualTo:@"Price"]){
        return item.price;
    } else if([tableColumn.identifier isEqualTo:@"Quantity"]){
        return qty;
    } else if([tableColumn.identifier isEqualTo:@"Total"]){
        return [NSNumber numberWithFloat:[qty floatValue] * [item.price floatValue]];
    } else if([tableColumn.identifier isEqualTo:@"Bands"]){
        NSString *bandString = @"";
        NSMutableArray *bandArray = [bands valueForKey:[tableArray objectAtIndex:row]];
        for (NSString *band in bandArray){
            if ([bandString isEqualTo:@""]){
                bandString = band;
            } else {
                bandString = [bandString stringByAppendingFormat:@", %@", band];
            }
        }
        return bandString;
    }
    
    return nil;
}


- (IBAction)generateEventReport:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EventOrders" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:path];
    
    path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString *styleContent = [NSString stringWithContentsOfFile:path];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[STYLE]" withString:styleContent];


    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    float eventTotal = 0.0;
    
    NSString *eventString = @"";
    
    if(self.eventArrayController.selectionIndexes.count != 0){
        Event *event = [self.eventArrayController.selectedObjects objectAtIndex:0];
        eventString = event.name;
    }
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[EVENT]" withString:eventString];
    
    NSString *ordersString = @"";
    
    for (NSString *itemKey in tableArray) {
        Inventory *item = [items valueForKey:itemKey];
        NSNumber *qty = [orders valueForKey:itemKey];
        NSMutableArray *bandArray = [bands valueForKey:itemKey];
        NSString *bandString = @"";
        for (NSString *band in bandArray){
            if ([bandString isEqualTo:@""]){
                bandString = band;
            } else {
                bandString = [bandString stringByAppendingFormat:@", %@", band];
            }
        }
        
        eventTotal += [qty floatValue] * [item.price floatValue];
        
        NSString *priceString = [numberFormatter stringFromNumber:item.price];
        NSString *totalString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[qty floatValue] * [item.price floatValue]]];
        
        ordersString = [ordersString stringByAppendingFormat:@"<tr><td>%@</td><td>%@</td><td>%i</td><td>%@</td><td>%@</td></tr>",
                        item.name, priceString, [qty integerValue], totalString, bandString];
    }
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[ORDERS]" withString:ordersString];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[EVENTTOTAL]" withString:[numberFormatter stringFromNumber:[NSNumber numberWithFloat:eventTotal]]];
    
    BOReportViewController *vc = [self.reportViewer delegate];
    [[vc.web mainFrame] loadHTMLString:htmlContent baseURL:nil];
    [self.reportViewer setIsVisible:YES];
}

- (IBAction)generateBandOrderReport:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BandOrderReport" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:path];
    
    path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString *styleContent = [NSString stringWithContentsOfFile:path];
    
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
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[PHONE]" withString:band.phoneNumber];
 
        NSString *ordersString = @"";
        
        float eventTotal = 0.0;
        
        for (Order* order in band.orders) {
            float itemTotal = [order.quantity floatValue] * [order.inventoryitem.price floatValue];
            eventTotal += itemTotal;
            NSString *priceString = [numberFormatter stringFromNumber:order.inventoryitem.price];
            NSString *itemTotalString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:itemTotal]];
            
            ordersString = [ordersString stringByAppendingFormat:@"<tr><td>%@</td><td>%@</td><td>%li</td><td>%@</td></tr>",
                            order.inventoryitem.name, priceString, (long)[order.quantity integerValue], itemTotalString];
            
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
    NSString *htmlContent = [NSString stringWithContentsOfFile:path];
    
    path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString *styleContent = [NSString stringWithContentsOfFile:path];
    
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
@end
