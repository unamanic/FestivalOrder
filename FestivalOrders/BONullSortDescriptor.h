//
//  BONullSortDescriptor.h
//  FestivalOrders
//
//  Created by William Witt on 1/31/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NULL_OBJECT(a) ((a) == nil || [(a) isEqual:[NSNull null]])
@interface BONullSortDescriptor : NSSortDescriptor

@end
