//
//  BOAggregatedOrders.h
//  FestivalOrders
//
//  Created by William Witt on 1/30/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Inventory;
@class EventInventoryReserves;


@interface BOAggregatedOrders : NSObject

@property (strong) NSString *orderKey;
@property (weak) Inventory *deliveredItem;
@property (strong) NSMutableArray *ordersArray;
@property (strong) NSMutableDictionary *orderQuantityDictionary;
@property (strong) NSMutableDictionary *bandDeliveriesDictionary;
@property (strong) NSNumber *quantiyOrdered;
@property (weak) EventInventoryReserves *reserves;

- (NSString *)requestedItems;
- (NSNumber *)totalOrdered;
- (NSNumber *)totalOrderPrice;
- (NSString *)bandOrders;

@end
