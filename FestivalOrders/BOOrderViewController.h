//
//  BOOrderViewController.h
//  FestivalOrders
//
//  Created by William Witt on 1/29/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BOReportViewController;

@interface BOOrderViewController : NSViewController <NSComboBoxDataSource> {
    NSArray *inventoryArray;
}
@property (weak) IBOutlet NSArrayController *inventoryArrayController;
@property (weak) IBOutlet NSArrayController *orderArrayController;
@property (unsafe_unretained) IBOutlet BOReportViewController *reportViewController;
@property (weak) IBOutlet NSArrayController *inventoryCategoryArrayController;
@property (weak) IBOutlet NSArrayController *bandArrayController;
@property (unsafe_unretained) IBOutlet NSPanel *reportViewer;


- (IBAction)generateBandOrderReport:(id)sender;
- (IBAction)generateBandOrderExpenseReport:(id)sender;

@end
