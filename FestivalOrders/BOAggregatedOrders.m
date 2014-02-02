//
//  BOAggregatedOrders.m
//  FestivalOrders
//
//  Created by William Witt on 1/30/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "BOAggregatedOrders.h"
#import "Inventory.h"
#import "EventInventoryReserves.h"
#import "Order.h"


@implementation BOAggregatedOrders {
    Inventory *_deliveredItem;
}

- (void)setDeliveredItem:(Inventory *)deliveredItem
{
    if (deliveredItem) {

        for (Order *order in self.ordersArray) {
            order.deliveredItem = deliveredItem;
        }
    }
    
    _deliveredItem = deliveredItem;
}

- (Inventory *)deliveredItem
{
    return _deliveredItem;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.orderQuantityDictionary = [[NSMutableDictionary alloc] init];
        self.bandDeliveriesDictionary = [[NSMutableDictionary alloc] init];

    }
    return self;
}

- (NSString *)requestedItems
{
    NSString *reqString;
    for (NSString * req in self.orderQuantityDictionary.allKeys) {
        if (!reqString) {
            reqString = [NSString stringWithFormat:@" %@ - %@", req, (NSNumber *)[self.orderQuantityDictionary valueForKey:req]];
        } else {
            reqString = [reqString stringByAppendingFormat:@" %@ - %@", req, (NSNumber *)[self.orderQuantityDictionary valueForKey:req]];
        }
    }
    
    return reqString;
}

- (NSNumber *)totalOrdered
{
    return [NSNumber numberWithInt:([self.quantiyOrdered intValue] +
                                    [self.reserves.reserveQuantity intValue])];
}

- (NSNumber *)totalOrderPrice
{
    return [NSNumber numberWithFloat:([self.quantiyOrdered floatValue] +
                               [self.reserves.reserveQuantity floatValue]) *
                               [self.deliveredItem.price floatValue]];
}

- (NSString *)bandOrders
{
    NSMutableDictionary *bandOrders = self.bandDeliveriesDictionary;
    
    NSString *bandString;
    for (NSString * req in bandOrders.allKeys) {
        if (!bandString) {
            bandString = [NSString stringWithFormat:@" %@ - %@", req, (NSNumber *)[bandOrders valueForKey:req]];
        } else {
            bandString = [bandString stringByAppendingFormat:@" %@ - %@", req, (NSNumber *)[bandOrders valueForKey:req]];
        }
    }
    return bandString;
}

@end
