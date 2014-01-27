//
//  BOEventViewController.h
//  FestivalOrders
//
//  Created by William Witt on 1/26/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BOEventViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, NSTabViewDelegate> {
    NSMutableDictionary *orders;
    NSMutableDictionary *items;
    NSMutableDictionary *bands;
    NSArray *tableArray;
}
@property (weak) IBOutlet NSArrayController *eventArrayController;
@property (weak) IBOutlet NSTableView *tableView;
@property (unsafe_unretained) IBOutlet NSPanel *reportViewer;
@property (weak) IBOutlet NSArrayController *bandArrayController;
@property (weak) IBOutlet NSArrayController *inventoryArrayController;

- (IBAction)generateEventReport:(id)sender;
- (IBAction)generateBandOrderReport:(id)sender;
- (IBAction)generateOrderForm:(id)sender;
@end
