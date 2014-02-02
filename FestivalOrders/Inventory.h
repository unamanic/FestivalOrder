//
//  Inventory.h
//  FestivalOrders
//
//  Created by William Witt on 1/28/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventInventoryReserves, InventoryCategory, Order;

@interface Inventory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) InventoryCategory *category;
@property (nonatomic, retain) NSSet *deliveries;
@property (nonatomic, retain) NSSet *eventReserves;
@end

@interface Inventory (CoreDataGeneratedAccessors)

- (void)addDeliveriesObject:(Order *)value;
- (void)removeDeliveriesObject:(Order *)value;
- (void)addDeliveries:(NSSet *)values;
- (void)removeDeliveries:(NSSet *)values;

- (void)addEventReservesObject:(EventInventoryReserves *)value;
- (void)removeEventReservesObject:(EventInventoryReserves *)value;
- (void)addEventReserves:(NSSet *)values;
- (void)removeEventReserves:(NSSet *)values;

@end
