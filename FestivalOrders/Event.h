//
//  Event.h
//  FestivalOrders
//
//  Created by William Witt on 2/2/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Band, EventInventoryReserves;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSData * eventLogo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSSet *bands;
@property (nonatomic, retain) NSSet *inventoryReserves;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addBandsObject:(Band *)value;
- (void)removeBandsObject:(Band *)value;
- (void)addBands:(NSSet *)values;
- (void)removeBands:(NSSet *)values;

- (void)addInventoryReservesObject:(EventInventoryReserves *)value;
- (void)removeInventoryReservesObject:(EventInventoryReserves *)value;
- (void)addInventoryReserves:(NSSet *)values;
- (void)removeInventoryReserves:(NSSet *)values;

@end
