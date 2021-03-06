//
//  BOColor.h
//  FestivalOrders
//
//  Created by William Witt on 1/28/14.
//  Copyright (c) 2014 William Witt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BOColor : NSActionCell

@property NSString *name;
@property NSColor *color;

- (id) init:(NSColor *)color named:(NSString *)name;

@end
