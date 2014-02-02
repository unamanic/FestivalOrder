//
//  BOBandViewController.m
//  FestivalOrders
//
//  Created by William Witt on 1/29/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "BOBandViewController.h"

@interface BOBandViewController ()

@end

@implementation BOBandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (IBAction)emailPointOfContact:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"Mailto:%@", self.email.stringValue]]];
}
@end
