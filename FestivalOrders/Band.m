//
//  Band.m
//  FestivalOrders
//
//  Created by William Witt on 2/2/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "Band.h"
#import "BandCategory.h"
#import "Event.h"
#import "Order.h"


@implementation Band

@dynamic date;
@dynamic email;
@dynamic name;
@dynamic pointOfContact;
@dynamic readyTime;
@dynamic stage;
@dynamic category;
@dynamic event;
@dynamic orders;

- (void) awakeFromInsert
{
    [super awakeFromInsert];
    self.date = [NSDate date];
    self.readyTime = [NSDate date];
    // or [self setPrimitiveDate:[NSDate date]];
    // to avoid triggering KVO notifications
    
}

@end
