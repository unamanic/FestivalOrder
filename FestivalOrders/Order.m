//
//  Order.m
//  FestivalOrders
//
//  Created by William Witt on 1/26/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "Order.h"
#import "Band.h"
#import "Inventory.h"


@implementation Order

@dynamic quantity;
@dynamic band;
@dynamic inventoryitem;

- (NSNumber *)total
{
    return [NSNumber numberWithFloat:[[self quantity] floatValue] * [[[self inventoryitem] price] floatValue]];
}
@end
