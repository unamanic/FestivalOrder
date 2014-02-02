//
//  Order.m
//  FestivalOrders
//
//  Created by William Witt on 1/30/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "Order.h"
#import "Band.h"
#import "Inventory.h"
#import "InventoryCategory.h"

#import "BOAppDelegate.h"


@implementation Order

@dynamic quantity;
@dynamic requestedItem;
@dynamic band;
@dynamic deliveredItem;
@dynamic requestedCategory;

- (NSNumber *)total
{
    if ([self deliveredItem]){
        return [NSNumber numberWithFloat:[[self quantity] floatValue] * [[[self deliveredItem] price] floatValue]];
    }
    
    return [NSNumber numberWithFloat:0.0];
}

- (void)setRequestedItem:(NSString *)requestedItem
{
    [self willChangeValueForKey:@"requestedItem"];
    [self setPrimitiveValue:requestedItem forKey:@"requestedItem"];
    
    if (!self.deliveredItem) {
        BOAppDelegate *app = [[NSApplication sharedApplication] delegate];
        for (Inventory *inv in app.inventoryArrayContoller.content){
            if ([inv.name isEqualToString:requestedItem]) {
                self.deliveredItem = inv;
            }
        }
        /*if (!self.deliveredItem){
         self.deliveredItem = [NSEntityDescription insertNewObjectForEntityForName:@"Inventory" inManagedObjectContext:app.managedObjectContext];
         self.deliveredItem.name = requestedItem;
         }*/
    }
    
    [self didChangeValueForKey:@"requestedItem"];
}

- (NSString *)orderKey
{
    if (self.deliveredItem) {
        return self.deliveredItem.name;
    }
    return self.requestedItem;
}
@end
