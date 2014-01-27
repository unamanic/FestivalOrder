//
//  InventoryCategory.h
//  FestivalOrders
//
//  Created by William Witt on 1/26/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Inventory;

@interface InventoryCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *inventoryItems;
@end

@interface InventoryCategory (CoreDataGeneratedAccessors)

- (void)addInventoryItemsObject:(Inventory *)value;
- (void)removeInventoryItemsObject:(Inventory *)value;
- (void)addInventoryItems:(NSSet *)values;
- (void)removeInventoryItems:(NSSet *)values;

@end
