//
//  BOEventViewController.h
//  FestivalOrders
//
//  Created by William Witt on 1/26/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BOAppDelegate;

@interface BOEventViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, NSTabViewDelegate, NSComboBoxCellDataSource> {
    BOAppDelegate *appDelegate;
    NSMutableDictionary *orders;
    NSMutableArray *itemKeys;
    NSMutableDictionary *aggregaredOrders;
    NSMutableDictionary *itemsDelivered;
    NSMutableDictionary *itemsOrdered;
    NSMutableDictionary *inventoryReserves;
    NSMutableDictionary *bands;
    NSArray *inventoryArray;
    
    NSMutableArray *colors;
}
@property (weak) IBOutlet NSTableView *eventTableView;
@property (weak) IBOutlet NSArrayController *eventArrayController;
@property (weak) IBOutlet NSTableView *tableView;
@property (unsafe_unretained) IBOutlet NSPanel *reportViewer;
@property (weak) IBOutlet NSArrayController *bandArrayController;
@property (weak) IBOutlet NSArrayController *inventoryArrayController;
@property (weak) IBOutlet NSPopUpButton *categoryFilterPopUp;
@property (weak) IBOutlet NSArrayController *deliveriesArrayController;
@property (weak) IBOutlet NSButton *generateBandDeliveryReport;
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSTextField *orderedItemTextView;
@property (weak) IBOutlet NSArrayController *inventoryCategotyArrayContorller;

@property (strong) NSMutableArray *tableArray;

- (IBAction)filterChanged:(id)sender;
- (IBAction)reserveQtyUpdated:(NSTextFieldCell *)sender;
- (IBAction)generateEventReport:(id)sender;
- (IBAction)generateBandOrderReport:(id)sender;
- (IBAction)generateOrderForm:(id)sender;
- (IBAction)generateBandExpenseReport:(id)sender;
- (IBAction)generateCategoryReport:(id)sender;
- (IBAction)addToInventory:(id)sender;

- (void)updateData;
@end
