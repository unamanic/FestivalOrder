//
//  Order.h
//  FestivalOrders
//
//  Created by William Witt on 1/26/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Band, Inventory;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) Band *band;
@property (nonatomic, retain) Inventory *inventoryitem;

@property (nonatomic, readonly) NSNumber *total;
@end
