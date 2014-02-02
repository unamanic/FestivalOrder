//
//  EventInventoryReserves.h
//  FestivalOrders
//
//  Created by William Witt on 1/28/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Inventory;

@interface EventInventoryReserves : NSManagedObject

@property (nonatomic, retain) NSNumber * reserveQuantity;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Inventory *inventoryItem;

@end
