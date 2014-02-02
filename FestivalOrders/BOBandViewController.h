//
//  BOBandViewController.h
//  FestivalOrders
//
//  Created by William Witt on 1/29/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BOBandViewController : NSViewController
@property (weak) IBOutlet NSTextField *email;

- (IBAction)emailPointOfContact:(id)sender;
@end
