//
//  BONavBarViewController.h
//  FestivalOrders
//
//  Created by William Witt on 1/29/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BOEventViewController;

@interface BONavBarViewController : NSViewController
@property (weak) IBOutlet NSTabView *tabView;
@property (unsafe_unretained) IBOutlet BOEventViewController *eventViewController;

- (IBAction)eventsButtonClicked:(id)sender;
- (IBAction)bandsButtonClicked:(id)sender;
- (IBAction)inventoryButtonClicked:(id)sender;
- (IBAction)ordersButtonClicked:(id)sender;
- (IBAction)deliveriesButtonClicked:(id)sender;
@end
