//
//  Order.h
//  FestivalOrders
//
//  Created by William Witt on 1/30/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Band, Inventory, InventoryCategory;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * requestedItem;
@property (nonatomic, retain) Band *band;
@property (nonatomic, retain) Inventory *deliveredItem;
@property (nonatomic, retain) InventoryCategory *requestedCategory;

- (NSNumber *)total;
- (NSString *)orderKey;
@end
