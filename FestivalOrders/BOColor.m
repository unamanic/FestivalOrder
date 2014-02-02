//
//  BOColor.m
//  FestivalOrders
//
//  Created by William Witt on 1/28/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import "BOColor.h"

@implementation BOColor

- (id) init:(NSColor *)color named:(NSString *)name
{
    self = [super init];
    
    if (self) {
        self.color = color;
        self.name = name;
    }
    
    return self;
}

@end
