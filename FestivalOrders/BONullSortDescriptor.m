//
//  BONullSortDescriptor.m
//  FestivalOrders
//
//  Created by William Witt on 1/31/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "BONullSortDescriptor.h"

@implementation BONullSortDescriptor

- (id)copyWithZone:(NSZone*)zone
{
    return [[[self class] alloc] initWithKey:[self key] ascending:[self ascending] selector:[self selector]];
}
- (NSComparisonResult)compareObject:(id)object1 toObject:(id)object2
{
    if (!(NULL_OBJECT([object1 valueForKeyPath:[self key]])) && !(NULL_OBJECT([object2 valueForKeyPath:[self key]]))) {
        return [(NSString *)[object1 valueForKeyPath:[self key]] caseInsensitiveCompare:(NSString *)[object2 valueForKeyPath:[self key]]];
    }
    
    if (NULL_OBJECT([object1 valueForKeyPath:[self key]])) {
        if (NULL_OBJECT([object2 valueForKeyPath:[self key]]))
            return NSOrderedSame; // If both objects have no awardedOn field, they are in the same "set"
        return NSOrderedAscending; // If the first one has no awardedOn, it is sorted after
    }
    if (NULL_OBJECT([object2 valueForKeyPath:[self key]])) {
        return NSOrderedDescending; // If the second one has no awardedOn, it is sorted after
    }
    return NSOrderedSame; // If they both have an awardedOn field, they are in the same "set"
}
@end
