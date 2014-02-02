//
//  BONavBarViewController.m
//  FestivalOrders
//
//  Created by William Witt on 1/29/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "BONavBarViewController.h"
#import "BOEventViewController.h"

@interface BONavBarViewController ()

@end

@implementation BONavBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (IBAction)eventsButtonClicked:(id)sender {
    [self.tabView selectTabViewItemAtIndex:0];
}
- (IBAction)bandsButtonClicked:(id)sender {
    [self.tabView selectTabViewItemAtIndex:2];
}

- (IBAction)inventoryButtonClicked:(id)sender {
    [self.tabView selectTabViewItemAtIndex:1];
}

- (IBAction)ordersButtonClicked:(id)sender {
    [self.tabView selectTabViewItemAtIndex:3];
}

- (IBAction)deliveriesButtonClicked:(id)sender {
    [self.eventViewController updateData];
    [self.tabView selectTabViewItemAtIndex:4];
}
@end
