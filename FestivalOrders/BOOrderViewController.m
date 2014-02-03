//
//  BOOrderViewController.m
//  FestivalOrders
//
//  Created by William Witt on 1/29/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "BOOrderViewController.h"
#import "Order.h"
#import "Inventory.h"
#import "InventoryCategory.h"
#import "Band.h"
#import "BandCategory.h"

#import "BOAppDelegate.h"
#import "BOReportViewController.h"
#import "NSColor+BOColor.h"

@interface BOOrderViewController () {
    BOAppDelegate *appDelegate;
}

@end

@implementation BOOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    appDelegate = [[NSApplication sharedApplication] delegate];
}

-(id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    return ((Inventory *)[inventoryArray objectAtIndex:index]).name;
}


- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string

{
    for(Inventory *inv in inventoryArray) {
        if ([inv.name isEqualToString:string]) {
            return [inventoryArray indexOfObject:inv];
        }
    }
    return NSNotFound;
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    NSSortDescriptor *categoryDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"category.name" ascending:YES];
    
    inventoryArray  =[self.inventoryArrayController.content sortedArrayUsingDescriptors:[NSArray arrayWithObject:categoryDescriptor]];
    
    return inventoryArray.count;
}

- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)string
{
    if (string.length > 0){
        for(Inventory *inv in inventoryArray) {
            if ([inv.name hasPrefix:string]) {
                return inv.name;
            }
        }
    }
    return string;
}


- (IBAction)generateBandOrderReport:(id)sender {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    
    // Build data set;
    
    Band *band = self.bandArrayController.selectedObjects.firstObject;
    

    float totalCost = 0.0;
    
    // iterate through event bands
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BandOrderReport" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString *styleContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //inject extra styles - none for band expense report
    NSString *styles = @"";
    for (InventoryCategory *cat in self.inventoryCategoryArrayController.arrangedObjects) {
        NSString *hexColorString = [(NSColor *)cat.color hexadecimalValueOfAnNSColor];
        styles = [styles stringByAppendingFormat:@".%@ td {color: %@;}\n", cat.name, hexColorString];
    }
    
    styleContent = [styleContent stringByReplacingOccurrencesOfString:@"[STYLEINJECT]" withString:styles];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[STYLE]" withString:styleContent];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *bandNotes = @"";
    if (band.notes) {
        bandNotes = band.notes;
    }
    
    bandNotes = [bandNotes stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[NOTES]" withString:bandNotes];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[DATE]" withString:[dateFormatter stringFromDate:band.date]];
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[TIME]" withString:[dateFormatter stringFromDate:band.readyTime]];
    
    NSString *stage = @"Not Entered";
    if (band.stage)
    {
        stage = band.stage;
    }
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[STAGE]" withString:stage];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[BAND]" withString:band.name];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[RATING]" withString:band.category.name];

    
    //Event logo
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[LOGO]" withString:[NSString stringWithFormat:@"file://%@", [[appDelegate getLogoURL] absoluteString]]];
    
    float eventTotal = 0.0;
    
    //table content
    NSString *tableString = @"";
    
    BOOL isAlt = NO;
    
    for (Order *order in self.orderArrayController.arrangedObjects) {
            NSString *altString =@"primary";
            if(isAlt){
                altString =@"alt";
            }
            isAlt = !isAlt;
            
            tableString = [tableString stringByAppendingFormat:@"<tr class='%@ %@'><td>%@</td><td>%@</td><td>%@</td></tr>\n",
                           order.deliveredItem.category.name,
                           altString,
                           order.requestedItem,
                           order.deliveredItem.name,

                           order.quantity];
        
    }
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[ORDERS]" withString:tableString];

    
    BOReportViewController *vc = [self.reportViewer delegate];
    [[vc.web mainFrame] loadHTMLString:htmlContent baseURL:nil];
    [self.reportViewer setIsVisible:YES];
}

- (IBAction)generateBandOrderExpenseReport:(id)sender {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Build data set;
    
    Band *band = self.bandArrayController.selectedObjects.firstObject;
    
    
    float totalCost = 0.0;
    
    // iterate through event bands
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BandOrderExpenseReport" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    NSString *styleContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //inject extra styles - none for band expense report
    NSString *styles = @"";
    for (InventoryCategory *cat in self.inventoryCategoryArrayController.arrangedObjects) {
        NSString *hexColorString = [(NSColor *)cat.color hexadecimalValueOfAnNSColor];
        styles = [styles stringByAppendingFormat:@".%@ td {color: %@;}\n", cat.name, hexColorString];
    }
    
    styleContent = [styleContent stringByReplacingOccurrencesOfString:@"[STYLEINJECT]" withString:styles];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[STYLE]" withString:styleContent];
    
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[BAND]" withString:band.name];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[RATING]" withString:band.category.name];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *bandNotes = @"";
    if (band.notes) {
        bandNotes = band.notes;
    }
    
    bandNotes = [bandNotes stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[NOTES]" withString:bandNotes];

    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[DATE]" withString:[dateFormatter stringFromDate:band.date]];
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[TIME]" withString:[dateFormatter stringFromDate:band.readyTime]];
    
    NSString *stage = @"Not Entered";
    if (band.stage)
    {
        stage = band.stage;
    }
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[STAGE]" withString:stage];
    
    
    
    //Event logo
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[LOGO]" withString:[NSString stringWithFormat:@"file://%@", [[appDelegate getLogoURL] absoluteString]]];
    
    float eventTotal = 0.0;
    
    //table content
    NSString *tableString = @"";
    
    BOOL isAlt = NO;
    
    for (Order *order in self.orderArrayController.arrangedObjects) {
        NSString *altString =@"primary";
        if(isAlt){
            altString =@"alt";
        }
        isAlt = !isAlt;
        
        float itemtotal = order.quantity.floatValue * order.deliveredItem.price.floatValue;
        totalCost += itemtotal;
        
        tableString = [tableString stringByAppendingFormat:@"<tr class='%@ %@'><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",
                       order.deliveredItem.category.name,
                       altString,
                       order.requestedItem,
                       order.deliveredItem.name,
                       order.quantity,
                       [numberFormatter stringFromNumber:order.deliveredItem.price],
                       [numberFormatter stringFromNumber:[NSNumber numberWithFloat:itemtotal]]];
        
    }
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[ORDERS]" withString:tableString];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"[TOTAL]" withString:[numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalCost]]];
    
    BOReportViewController *vc = [self.reportViewer delegate];
    [[vc.web mainFrame] loadHTMLString:htmlContent baseURL:nil];
    [self.reportViewer setIsVisible:YES];
}
@end
